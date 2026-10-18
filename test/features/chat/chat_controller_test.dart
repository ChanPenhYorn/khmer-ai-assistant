import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/core/errors/app_failure.dart';
import 'package:khmer_ai_assistant/features/ai/data/datasources/ai_data_source.dart';
import 'package:khmer_ai_assistant/features/ai/data/dto/ai_request_dto.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_message.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_reply.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_stream_event.dart';
import 'package:khmer_ai_assistant/features/chat/domain/entities/chat_message.dart';
import 'package:khmer_ai_assistant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:khmer_ai_assistant/features/chat/presentation/providers/chat_providers.dart';
import 'package:khmer_ai_assistant/features/chat/presentation/providers/chat_state.dart';

import '../../helpers/fake_ai_data_source.dart';
import '../../helpers/test_harness.dart';

/// Fails the first stream and succeeds on the next one.
class _PhaseDataSource implements AiDataSource {
  int streamCalls = 0;

  @override
  Future<AiReply> complete(AiRequestDto request) async =>
      const AiReply(text: 'unused');

  @override
  Stream<AiStreamEvent> stream(AiRequestDto request) async* {
    streamCalls++;
    if (streamCalls == 1) {
      yield const AiStreamFailed(ProviderFailure());
      return;
    }
    yield const AiStreamDelta('recovered');
    yield const AiStreamCompleted(AiReply(text: 'recovered'));
  }
}

/// Lets pending microtasks and zero-duration timers run.
Future<void> flush([int rounds = 8]) async {
  for (var i = 0; i < rounds; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;

  Future<void> setUpContainer(AiDataSource dataSource) async {
    container = testContainer(
      preferences: await setUpTestPreferences(),
      dataSource: dataSource,
    );
    addTearDown(container.dispose);
  }

  Future<ChatState> stateOf(String id) async =>
      container.read(chatControllerProvider(id).future);

  test('starts an empty conversation without persisting it', () async {
    final fake = FakeAiDataSource();
    await setUpContainer(fake);
    container.listen(chatControllerProvider(newConversationId), (_, _) {});

    final state = await stateOf(newConversationId);

    expect(state.isEmpty, isTrue);
    expect(state.isGenerating, isFalse);
    expect(
      await container.read(chatRepositoryProvider).listConversations(),
      isEmpty,
    );
  });

  test('fails loudly for an unknown conversation id', () async {
    await setUpContainer(FakeAiDataSource());
    container.listen(chatControllerProvider('does-not-exist'), (_, _) {});

    await expectLater(
      container.read(chatControllerProvider('does-not-exist').future),
      throwsA(isA<UnknownFailure>()),
    );
  });

  test('sends a turn, streams the answer and persists it', () async {
    final fake = FakeAiDataSource(streamChunks: const ['សូម', 'ស្វាគមន៍']);
    await setUpContainer(fake);
    final provider = chatControllerProvider(newConversationId);
    container.listen(provider, (_, _) {});

    final initial = await stateOf(newConversationId);
    final notifier = container.read(provider.notifier);

    await notifier.send('សូមស្វាគមន៍');
    expect(container.read(provider).value!.isGenerating, isTrue);

    await flush();

    final state = container.read(provider).value!;
    expect(state.isGenerating, isFalse);
    expect(state.failure, isNull);
    expect(state.conversation.messages, hasLength(2));
    expect(state.conversation.messages.first.author, ChatAuthor.user);
    expect(state.conversation.messages.last.content, 'សូមស្វាគមន៍');
    expect(state.conversation.messages.last.status, ChatMessageStatus.complete);

    final stored = await container
        .read(chatRepositoryProvider)
        .getConversation(initial.conversation.id);
    expect(stored!.messages, hasLength(2));

    final history = await container.read(conversationListProvider.future);
    expect(history, hasLength(1));
  });

  test('ignores a second send while a reply is streaming', () async {
    final fake = FakeAiDataSource(streamChunks: const ['a', 'b']);
    await setUpContainer(fake);
    final provider = chatControllerProvider(newConversationId);
    container.listen(provider, (_, _) {});
    await stateOf(newConversationId);
    final notifier = container.read(provider.notifier);

    // Two taps in quick succession must not produce two user turns.
    final first = notifier.send('one');
    final second = notifier.send('two');
    await Future.wait([first, second]);
    await flush();

    final state = container.read(provider).value!;
    expect(fake.streamCalls, 1);
    expect(state.conversation.messages.where((m) => m.isUser), hasLength(1));
    expect(state.conversation.messages.first.content, 'one');
  });

  test('ignores empty input', () async {
    final fake = FakeAiDataSource();
    await setUpContainer(fake);
    final provider = chatControllerProvider(newConversationId);
    container.listen(provider, (_, _) {});
    await stateOf(newConversationId);

    await container.read(provider.notifier).send('   ');

    expect(container.read(provider).value!.isEmpty, isTrue);
    expect(fake.streamCalls, 0);
  });

  test('surfaces a failure and keeps the user turn for retry', () async {
    final fake = FakeAiDataSource(
      streamChunks: const [],
      streamFailure: const ProviderFailure(),
    );
    await setUpContainer(fake);
    final provider = chatControllerProvider(newConversationId);
    container.listen(provider, (_, _) {});
    await stateOf(newConversationId);

    await container.read(provider.notifier).send('hello');
    await flush();

    final state = container.read(provider).value!;
    expect(state.failure, isA<ProviderFailure>());
    expect(state.isGenerating, isFalse);
    expect(state.retryText, 'hello');
    expect(state.conversation.messages.first.content, 'hello');
  });

  test('retryLastTurn recovers without duplicating the user turn', () async {
    final fake = _PhaseDataSource();
    await setUpContainer(fake);
    final provider = chatControllerProvider(newConversationId);
    container.listen(provider, (_, _) {});
    await stateOf(newConversationId);
    final notifier = container.read(provider.notifier);

    await notifier.send('hello');
    await flush();
    expect(container.read(provider).value!.failure, isNotNull);

    await notifier.retryLastTurn();
    await flush();

    final state = container.read(provider).value!;
    expect(state.failure, isNull);
    expect(state.conversation.messages.where((m) => m.isUser), hasLength(1));
    expect(state.conversation.messages.last.content, 'recovered');
    expect(fake.streamCalls, 2);
  });

  test(
    'stop keeps the partial answer and clears the streaming state',
    () async {
      final fake = FakeAiDataSource(
        streamChunks: const ['partial', ' more'],
        streamDelay: const Duration(milliseconds: 20),
      );
      await setUpContainer(fake);
      final provider = chatControllerProvider(newConversationId);
      container.listen(provider, (_, _) {});
      await stateOf(newConversationId);
      final notifier = container.read(provider.notifier);

      await notifier.send('hello');
      await Future<void>.delayed(const Duration(milliseconds: 30));
      await notifier.stop();
      await flush();

      final state = container.read(provider).value!;
      expect(state.isGenerating, isFalse);
      expect(state.failure, isNull, reason: 'stopping is not an error');
      expect(state.conversation.messages.last.content, 'partial');
      expect(
        state.conversation.messages.last.status,
        ChatMessageStatus.complete,
      );
    },
  );

  test('stop on an empty placeholder removes it', () async {
    final fake = FakeAiDataSource(
      streamChunks: const ['later'],
      streamDelay: const Duration(milliseconds: 50),
    );
    await setUpContainer(fake);
    final provider = chatControllerProvider(newConversationId);
    container.listen(provider, (_, _) {});
    await stateOf(newConversationId);
    final notifier = container.read(provider.notifier);

    await notifier.send('hello');
    await notifier.stop();
    await flush();

    final state = container.read(provider).value!;
    expect(state.conversation.messages, hasLength(1));
    expect(state.conversation.messages.single.author, ChatAuthor.user);
  });

  test('isGenerating never leaks across a failed send', () async {
    final fake = FakeAiDataSource(
      streamChunks: const [],
      streamFailure: const TimeoutFailure(),
    );
    await setUpContainer(fake);
    final provider = chatControllerProvider(newConversationId);
    container.listen(provider, (_, _) {});
    await stateOf(newConversationId);

    await container.read(provider.notifier).send('hello');
    await flush();

    expect(container.read(provider).value!.isGenerating, isFalse);
  });

  test('sends only a bounded context window', () async {
    final fake = FakeAiDataSource(streamChunks: const ['ok']);
    await setUpContainer(fake);
    final provider = chatControllerProvider(newConversationId);
    container.listen(provider, (_, _) {});
    await stateOf(newConversationId);
    final notifier = container.read(provider.notifier);

    for (var i = 0; i < 14; i++) {
      await notifier.send('question $i');
      await flush();
    }

    final sent = fake.requests.last.messages;
    expect(sent.length, lessThanOrEqualTo(20));
    expect(sent.first.role, AiRole.user);
    expect(sent.last.content, 'question 13');
  });

  test('rename updates the stored title', () async {
    final fake = FakeAiDataSource();
    await setUpContainer(fake);
    final provider = chatControllerProvider(newConversationId);
    container.listen(provider, (_, _) {});
    final initial = await stateOf(newConversationId);
    final notifier = container.read(provider.notifier);

    await notifier.send('hello');
    await flush();
    await notifier.rename('Renamed');

    final stored = await container
        .read(chatRepositoryProvider)
        .getConversation(initial.conversation.id);
    expect(stored!.title, 'Renamed');
    expect(container.read(provider).value!.conversation.title, 'Renamed');
  });

  test('delete removes the conversation from storage', () async {
    final fake = FakeAiDataSource();
    await setUpContainer(fake);
    final provider = chatControllerProvider(newConversationId);
    container.listen(provider, (_, _) {});
    await stateOf(newConversationId);
    final notifier = container.read(provider.notifier);

    await notifier.send('hello');
    await flush();
    await notifier.deleteConversation();

    expect(
      await container.read(chatRepositoryProvider).listConversations(),
      isEmpty,
    );
  });
}
