import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:khmer_ai_assistant/core/config/ai_config.dart';
import 'package:khmer_ai_assistant/core/widgets/markdown_text.dart';
import 'package:khmer_ai_assistant/features/home/presentation/screens/home_screen.dart';

import '../helpers/fake_ai_data_source.dart';
import '../helpers/test_harness.dart';

/// Configuration that puts the UI in explicit demo mode.
const AiConfig demoConfig = AiConfig(
  baseUrl: '',
  assistantPath: '/v1/assistant',
  requestTimeout: Duration(seconds: 5),
  maxInputCharacters: 2000,
  useMockDataSource: true,
  streamingEnabled: false,
);

/// Configuration with neither a backend nor demo mode: the app must say so.
const AiConfig misconfiguredConfig = AiConfig(
  baseUrl: '',
  assistantPath: '/v1/assistant',
  requestTimeout: Duration(seconds: 5),
  maxInputCharacters: 2000,
  useMockDataSource: false,
  streamingEnabled: false,
);

void main() {
  testWidgets('home shows the greeting, tools and example prompts', (
    tester,
  ) async {
    await pumpAppWithFake(tester);

    expect(find.text('Khmer AI Assistant'), findsWidgets);
    expect(find.text('Translate'), findsWidgets);
    expect(find.text('Summarize'), findsWidgets);
    expect(find.text('Learn English'), findsWidgets);
    expect(find.text('Start with an example'), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('demo mode is stated plainly, never hidden', (tester) async {
    await pumpAppWithFake(tester, config: demoConfig);

    expect(find.text('Demo mode'), findsOneWidget);
    expect(
      find.textContaining('offline sample'),
      findsOneWidget,
      reason: 'the banner must explain what demo mode means',
    );
  });

  testWidgets('a missing backend is reported instead of faked', (tester) async {
    await pumpAppWithFake(tester, config: misconfiguredConfig);

    expect(find.text('No AI server configured'), findsOneWidget);
    expect(find.text('Demo mode'), findsNothing);
  });

  testWidgets('interface language can be Khmer', (tester) async {
    await pumpAppWithFake(
      tester,
      preferenceValues: const {'settings_locale_code': 'km'},
    );

    expect(find.text('ជំនួយការ AI ខ្មែរ'), findsWidgets);
    expect(find.text('សួរអ្វីក៏បាន…'), findsOneWidget);
  });

  testWidgets('a prompt typed on home opens the chat and is sent', (
    tester,
  ) async {
    final fake = await pumpAppWithFake(
      tester,
      dataSource: FakeAiDataSource(streamChunks: const ['Here ', 'you go']),
    );

    await tester.enterText(find.byType(TextField).first, 'What is interest?');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
    await tester.pumpAndSettle();

    expect(fake.streamCalls, 1);
    expect(fake.requests.single.messages.last.content, 'What is interest?');
    // Assistant output is Markdown-rendered, so assert on the rendered source.
    final markdown = tester.widget<MarkdownText>(find.byType(MarkdownText));
    expect(markdown.data, 'Here you go');
  });

  testWidgets('an empty prompt just opens the chat', (tester) async {
    final fake = await pumpAppWithFake(tester);

    // The empty-state send affordance on the home input.
    await tester.tap(find.byIcon(Icons.forum_outlined).first);
    await tester.pumpAndSettle();

    expect(fake.streamCalls, 0);
    expect(find.text('Ask your first question'), findsOneWidget);
  });

  testWidgets('tapping an example prompt starts a conversation', (
    tester,
  ) async {
    final fake = await pumpAppWithFake(tester);

    await tester.tap(find.text('Explain photosynthesis in simple Khmer'));
    await tester.pumpAndSettle();

    expect(fake.streamCalls, 1);
    expect(
      fake.requests.single.messages.single.content,
      'Explain photosynthesis in simple Khmer',
    );
  });
}
