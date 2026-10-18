import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/features/chat/data/datasources/shared_preferences_chat_local_data_source.dart';
import 'package:khmer_ai_assistant/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:khmer_ai_assistant/features/chat/domain/entities/chat_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences preferences;
  late ChatRepositoryImpl repository;
  var now = DateTime.utc(2026, 1, 1, 8);

  setUp(() async {
    now = DateTime.utc(2026, 1, 1, 8);
    SharedPreferences.setMockInitialValues(<String, Object>{});
    preferences = await SharedPreferences.getInstance();
    repository = ChatRepositoryImpl(
      localDataSource: SharedPreferencesChatLocalDataSource(preferences),
      clock: () => now,
    );
  });

  ChatMessage message(
    String text, {
    ChatAuthor author = ChatAuthor.user,
    String? id,
    ChatMessageStatus status = ChatMessageStatus.complete,
  }) => ChatMessage(
    id: id ?? 'm_${text.hashCode}_${author.name}',
    author: author,
    content: text,
    createdAt: now,
    status: status,
  );

  group('createConversation', () {
    test('does not store an unused conversation', () async {
      final created = await repository.createConversation();
      expect(created.id, isNotEmpty);
      expect(created.messages, isEmpty);
      expect(await repository.listConversations(), isEmpty);
    });

    test('generates a unique id per conversation', () async {
      final a = await repository.createConversation();
      final b = await repository.createConversation();
      expect(a.id, isNot(b.id));
    });
  });

  group('saveConversation', () {
    test('persists and lists the conversation', () async {
      final conversation = await repository.createConversation();
      await repository.saveConversation(
        conversation.copyWith(messages: [message('hello')]),
      );

      final summaries = await repository.listConversations();
      expect(summaries, hasLength(1));
      expect(summaries.single.id, conversation.id);
      expect(summaries.single.messageCount, 1);
    });

    test('derives a title from the first user message', () async {
      final conversation = await repository.createConversation();
      await repository.saveConversation(
        conversation.copyWith(
          messages: [
            message('Write a leave request for tomorrow'),
            message('Sure, here is a draft', author: ChatAuthor.assistant),
          ],
        ),
      );

      final stored = await repository.getConversation(conversation.id);
      expect(stored!.title, 'Write a leave request for tomorrow');
    });

    test('keeps a user-provided title', () async {
      final conversation = await repository.createConversation(
        title: 'My title',
      );
      await repository.saveConversation(
        conversation.copyWith(messages: [message('hello')]),
      );

      final stored = await repository.getConversation(conversation.id);
      expect(stored!.title, 'My title');
    });

    test('caps stored messages per conversation', () async {
      final conversation = await repository.createConversation();
      final many = <ChatMessage>[
        for (
          var i = 0;
          i < ChatRepositoryImpl.maxMessagesPerConversation + 25;
          i++
        )
          message('m$i', id: 'm_$i'),
      ];

      await repository.saveConversation(conversation.copyWith(messages: many));

      final stored = await repository.getConversation(conversation.id);
      expect(
        stored!.messages.length,
        ChatRepositoryImpl.maxMessagesPerConversation,
      );
      // The newest messages are the ones that survive.
      expect(stored.messages.last.content, 'm224');
    });

    test('drops empty messages when reloading', () async {
      final conversation = await repository.createConversation();
      await repository.saveConversation(
        conversation.copyWith(
          messages: [
            message('hello'),
            ChatMessage(
              id: 'm_empty',
              author: ChatAuthor.assistant,
              content: '   ',
              createdAt: now,
            ),
          ],
        ),
      );

      final stored = await repository.getConversation(conversation.id);
      expect(stored!.messages, hasLength(1));
    });

    test('overwrites instead of duplicating on repeated saves', () async {
      final conversation = await repository.createConversation();
      await repository.saveConversation(
        conversation.copyWith(messages: [message('one')]),
      );
      now = now.add(const Duration(minutes: 5));
      await repository.saveConversation(
        conversation.copyWith(messages: [message('one'), message('two')]),
      );

      final summaries = await repository.listConversations();
      expect(summaries, hasLength(1));
      expect(summaries.single.messageCount, 2);
    });
  });

  group('listConversations', () {
    test('returns the most recently updated first', () async {
      final older = await repository.createConversation();
      await repository.saveConversation(
        older.copyWith(messages: [message('old')]),
      );

      now = now.add(const Duration(hours: 1));
      final newer = await repository.createConversation();
      await repository.saveConversation(
        newer.copyWith(messages: [message('new')]),
      );

      final summaries = await repository.listConversations();
      expect(summaries.map((s) => s.id).toList(), [newer.id, older.id]);
    });
  });

  group('rename and delete', () {
    test('renames a stored conversation', () async {
      final conversation = await repository.createConversation();
      await repository.saveConversation(
        conversation.copyWith(messages: [message('hello')]),
      );

      await repository.renameConversation(conversation.id, 'Renamed');

      final stored = await repository.getConversation(conversation.id);
      expect(stored!.title, 'Renamed');
    });

    test('truncates an over-long title', () async {
      final conversation = await repository.createConversation();
      await repository.saveConversation(conversation);
      await repository.renameConversation(conversation.id, 'x' * 200);

      final stored = await repository.getConversation(conversation.id);
      expect(stored!.title.length, lessThanOrEqualTo(48));
    });

    test('deletes a conversation', () async {
      final conversation = await repository.createConversation();
      await repository.saveConversation(
        conversation.copyWith(messages: [message('hello')]),
      );

      await repository.deleteConversation(conversation.id);

      expect(await repository.getConversation(conversation.id), isNull);
      expect(await repository.listConversations(), isEmpty);
    });

    test('ignores renames of unknown conversations', () async {
      await repository.renameConversation('missing', 'title');
      expect(await repository.listConversations(), isEmpty);
    });

    test('clearAll removes everything', () async {
      final conversation = await repository.createConversation();
      await repository.saveConversation(
        conversation.copyWith(messages: [message('hello')]),
      );

      await repository.clearAll();

      expect(await repository.listConversations(), isEmpty);
    });
  });

  group('resilience', () {
    test('ignores a corrupted storage document', () async {
      await preferences.setString(
        SharedPreferencesChatLocalDataSource.storageKey,
        '{not json',
      );

      expect(await repository.listConversations(), isEmpty);
    });

    test('skips entries without an id', () async {
      await preferences.setString(
        SharedPreferencesChatLocalDataSource.storageKey,
        '[{"title":"no id","created_at":"2026-01-01T00:00:00.000Z",'
        '"updated_at":"2026-01-01T00:00:00.000Z","messages":[]}]',
      );

      expect(await repository.listConversations(), isEmpty);
    });

    test('returns null for an unknown or empty id', () async {
      expect(await repository.getConversation('nope'), isNull);
      expect(await repository.getConversation(''), isNull);
    });
  });
}
