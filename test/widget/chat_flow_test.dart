import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/core/errors/app_failure.dart';
import 'package:khmer_ai_assistant/core/widgets/markdown_text.dart';
import 'package:khmer_ai_assistant/features/chat/presentation/screens/chat_screen.dart';

import '../helpers/fake_ai_data_source.dart';
import '../helpers/test_harness.dart';

void main() {
  testWidgets('empty chat explains itself and offers suggestions', (
    tester,
  ) async {
    await pumpAppWithFake(tester, location: '/chat');

    expect(find.byType(ChatScreen), findsOneWidget);
    expect(find.text('Ask your first question'), findsOneWidget);
    expect(find.text('What is compound interest?'), findsOneWidget);
  });

  testWidgets('sending a message shows the user turn and the streamed answer', (
    tester,
  ) async {
    final fake = await pumpAppWithFake(
      tester,
      location: '/chat',
      dataSource: FakeAiDataSource(
        streamChunks: const ['ជំរាប', 'សួរ'],
        streamDelay: const Duration(milliseconds: 10),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'សូមស្វាគមន៍');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
    await tester.pump();

    // The composer swaps to a stop affordance while the answer streams.
    expect(find.byIcon(Icons.stop_rounded), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.stop_rounded), findsNothing);
    expect(fake.streamCalls, 1);
    final markdown = tester.widget<MarkdownText>(find.byType(MarkdownText));
    expect(markdown.data, 'ជំរាបសួរ');
    // The user's own message is still on screen.
    expect(find.text('សូមស្វាគមន៍'), findsOneWidget);
  });

  testWidgets('a failure is shown with a retry action', (tester) async {
    await pumpAppWithFake(
      tester,
      location: '/chat',
      dataSource: FakeAiDataSource(
        streamChunks: const [],
        streamFailure: const RateLimitedFailure(),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'hello');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Too many requests right now. Please wait a moment and try again.',
      ),
      findsOneWidget,
    );
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('generation can be stopped and keeps the partial answer', (
    tester,
  ) async {
    await pumpAppWithFake(
      tester,
      location: '/chat',
      dataSource: FakeAiDataSource(
        streamChunks: const ['partial', ' rest'],
        streamDelay: const Duration(milliseconds: 40),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'hello');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.byIcon(Icons.stop_rounded));
    await tester.pumpAndSettle();

    final markdown = tester.widget<MarkdownText>(find.byType(MarkdownText));
    expect(markdown.data, 'partial');
    expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
  });

  testWidgets('a very long Khmer answer renders without overflow', (
    tester,
  ) async {
    final longKhmer = List<String>.filled(120, 'ខ្មែរ').join(' ');
    await pumpAppWithFake(
      tester,
      location: '/chat',
      dataSource: FakeAiDataSource(streamChunks: [longKhmer]),
    );

    await tester.enterText(find.byType(TextField).first, 'សូមពន្យល់');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(MarkdownText), findsOneWidget);
  });

  testWidgets('send is disabled for empty input', (tester) async {
    await pumpAppWithFake(tester, location: '/chat');

    final sendButton = tester.widget<IconButton>(
      find.ancestor(
        of: find.byIcon(Icons.arrow_upward_rounded),
        matching: find.byType(IconButton),
      ),
    );
    expect(sendButton.onPressed, isNull);
  });

  testWidgets('a stored conversation is reopened with its history', (
    tester,
  ) async {
    final fake = FakeAiDataSource(streamChunks: const ['first answer']);

    // Conversation id "new" is replaced by a real id after the first send.
    await pumpAppWithFake(tester, location: '/chat', dataSource: fake);
    await tester.enterText(find.byType(TextField).first, 'first question');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
    await tester.pumpAndSettle();

    // Open the history tab and re-open the conversation.
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('first question'), findsOneWidget);

    await tester.tap(find.text('first question'));
    await tester.pumpAndSettle();

    expect(find.byType(ChatScreen), findsOneWidget);
    final markdown = tester.widget<MarkdownText>(find.byType(MarkdownText));
    expect(markdown.data, 'first answer');
    expect(fake.streamCalls, 1, reason: 'reopening must not re-ask');
  });
}
