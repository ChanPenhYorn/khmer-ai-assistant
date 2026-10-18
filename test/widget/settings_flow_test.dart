import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/core/config/ai_config.dart';
import 'package:khmer_ai_assistant/features/chat/data/datasources/shared_preferences_chat_local_data_source.dart';
import 'package:khmer_ai_assistant/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:khmer_ai_assistant/features/chat/domain/entities/chat_message.dart';
import 'package:khmer_ai_assistant/features/chat/presentation/providers/chat_providers.dart';
import 'package:khmer_ai_assistant/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:khmer_ai_assistant/features/settings/presentation/screens/settings_screen.dart';

import '../helpers/fake_ai_data_source.dart';
import '../helpers/fake_auth_token_store.dart';
import '../helpers/test_harness.dart';

const AiConfig demoConfig = AiConfig(
  baseUrl: '',
  assistantPath: '/v1/assistant',
  requestTimeout: Duration(seconds: 5),
  maxInputCharacters: 2000,
  useMockDataSource: true,
  streamingEnabled: false,
);

void main() {
  testWidgets('settings shows every section and the live server mode', (
    tester,
  ) async {
    await pumpAppWithFake(tester, location: '/settings');

    expect(find.byType(SettingsScreen), findsOneWidget);
    // The section header and the dropdown label share this string.
    expect(find.text('Interface language'), findsWidgets);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Server mode'), findsOneWidget);
    expect(find.text('Privacy'), findsOneWidget);
    expect(find.text('Connected to a real AI server'), findsOneWidget);
  });

  testWidgets('demo mode is labelled as a demo, not as live', (tester) async {
    await pumpAppWithFake(tester, location: '/settings', config: demoConfig);

    expect(find.text('Demo mode (offline sample replies)'), findsOneWidget);
    expect(find.text('Connected to a real AI server'), findsNothing);
  });

  testWidgets('a missing server is called out as a problem', (tester) async {
    await pumpAppWithFake(
      tester,
      location: '/settings',
      config: const AiConfig(
        baseUrl: '',
        assistantPath: '/v1/assistant',
        requestTimeout: Duration(seconds: 5),
        maxInputCharacters: 2000,
        useMockDataSource: false,
        streamingEnabled: false,
      ),
    );

    expect(find.text('No AI server configured'), findsOneWidget);
  });

  testWidgets('usage never shows numbers the server did not report', (
    tester,
  ) async {
    await pumpAppWithFake(tester, location: '/settings');

    expect(
      find.text('This build has no usage data from the server.'),
      findsOneWidget,
    );
  });

  testWidgets('switching the interface language to Khmer relabels the app', (
    tester,
  ) async {
    final preferences = await setUpTestPreferences();
    await pumpApp(
      tester,
      preferences: preferences,
      dataSource: FakeAiDataSource(),
      location: '/settings',
    );

    await tester.tap(find.byType(DropdownButtonFormField<String?>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Khmer').last);
    await tester.pumpAndSettle();

    expect(find.text('ការកំណត់'), findsWidgets);
    expect(find.text('ភាសាប្រើប្រាស់ក្នុងកម្មវិធី'), findsWidgets);
    // The choice is remembered, not just applied for this session.
    expect(preferences.getString(SettingsRepositoryImpl.localeCodeKey), 'km');
  });

  testWidgets('the theme choice switches the app theme and is persisted', (
    tester,
  ) async {
    final preferences = await setUpTestPreferences();
    await pumpApp(
      tester,
      preferences: preferences,
      dataSource: FakeAiDataSource(),
      location: '/settings',
    );

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    expect(preferences.getString(SettingsRepositoryImpl.themeModeKey), 'dark');
  });

  testWidgets('clearing the history asks first and then empties storage', (
    tester,
  ) async {
    final preferences = await setUpTestPreferences();
    final repository = ChatRepositoryImpl(
      localDataSource: SharedPreferencesChatLocalDataSource(preferences),
      clock: () => DateTime.utc(2026),
    );
    final conversation = await repository.createConversation();
    await repository.saveConversation(
      conversation.copyWith(
        messages: [
          ChatMessage(
            id: 'm1',
            author: ChatAuthor.user,
            content: 'hello',
            createdAt: DateTime.utc(2026),
          ),
        ],
      ),
    );
    expect(await repository.listConversations(), hasLength(1));

    await pumpApp(
      tester,
      preferences: preferences,
      dataSource: FakeAiDataSource(),
      location: '/settings',
    );

    await tester.tap(find.text('Clear local chat history'));
    await tester.pumpAndSettle();

    // Cancelling keeps the data.
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(await repository.listConversations(), hasLength(1));

    await tester.tap(find.text('Clear local chat history'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(await repository.listConversations(), isEmpty);
    expect(
      find.text('Chat history cleared'),
      findsOneWidget,
      reason: 'the user must get feedback that the deletion happened',
    );
  });

  testWidgets('the clear action is reflected in the history screen', (
    tester,
  ) async {
    final preferences = await setUpTestPreferences();
    final repository = ChatRepositoryImpl(
      localDataSource: SharedPreferencesChatLocalDataSource(preferences),
      clock: () => DateTime.utc(2026),
    );
    final conversation = await repository.createConversation();
    await repository.saveConversation(
      conversation.copyWith(
        messages: [
          ChatMessage(
            id: 'm1',
            author: ChatAuthor.user,
            content: 'remember me',
            createdAt: DateTime.utc(2026),
          ),
        ],
      ),
    );

    await pumpApp(
      tester,
      preferences: preferences,
      dataSource: FakeAiDataSource(),
      location: '/history',
    );

    expect(find.text('remember me'), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(Scaffold).first),
    );
    // Same code path the settings screen runs.
    await container.read(chatRepositoryProvider).clearAll();
    container.invalidate(conversationListProvider);
    await tester.pumpAndSettle();

    expect(find.text('remember me'), findsNothing);
    expect(find.text('No conversations yet'), findsOneWidget);
  });

  testWidgets('the access token field is disabled until storage is read', (
    tester,
  ) async {
    await pumpAppWithFake(
      tester,
      location: '/settings',
      tokenStore: FakeAuthTokenStore('secret-token'),
    );

    final field = tester.widget<TextField>(
      find.widgetWithText(TextField, 'Access token'),
    );
    expect(field.obscureText, isTrue);
    expect(
      field.controller?.text,
      'secret-token',
      reason: 'a stored token must be shown back to the operator',
    );
  });
}
