import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/app/app.dart';
import 'package:khmer_ai_assistant/core/config/ai_config.dart';
import 'package:khmer_ai_assistant/core/config/app_providers.dart';
import 'package:khmer_ai_assistant/core/network/dio_providers.dart';
import 'package:khmer_ai_assistant/core/storage/preferences_providers.dart';
import 'package:khmer_ai_assistant/features/ai/data/datasources/ai_data_source.dart';
import 'package:khmer_ai_assistant/features/ai/presentation/providers/ai_providers.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_ai_data_source.dart';
import 'fake_auth_token_store.dart';

/// Configuration used by tests: no network, no streaming delays.
const AiConfig _testAiConfig = AiConfig(
  baseUrl: 'https://example.test/functions/v1',
  assistantPath: '/v1/assistant',
  requestTimeout: Duration(seconds: 5),
  maxInputCharacters: 2000,
  useMockDataSource: false,
  streamingEnabled: false,
);

/// Provider overrides shared by widget and container tests.
///
/// This is a closure variable rather than a function because `Override` is not
/// exported by `flutter_riverpod`, so the list type cannot be named in a
/// signature.
// ignore: always_declare_return_types, prefer_function_declarations_over_variables
final _overrides =
    ({
      required SharedPreferences preferences,
      required AiDataSource dataSource,
      required AiConfig config,
      FakeAuthTokenStore? tokenStore,
    }) => [
      sharedPreferencesProvider.overrideWithValue(preferences),
      aiConfigProvider.overrideWithValue(config),
      aiDataSourceProvider.overrideWithValue(dataSource),
      authTokenStoreProvider.overrideWithValue(
        tokenStore ?? FakeAuthTokenStore(),
      ),
    ];

/// Builds real shared preferences backed by an in-memory store.
Future<SharedPreferences> setUpTestPreferences([
  Map<String, Object> initialValues = const <String, Object>{},
]) async {
  SharedPreferences.setMockInitialValues(initialValues);
  return SharedPreferences.getInstance();
}

/// Wraps [child] in a scope with every plugin replaced by a test double.
ProviderScope _testScope({
  required Widget child,
  required SharedPreferences preferences,
  required AiDataSource dataSource,
  AiConfig config = _testAiConfig,
  FakeAuthTokenStore? tokenStore,
}) => ProviderScope(
  overrides: _overrides(
    preferences: preferences,
    dataSource: dataSource,
    config: config,
    tokenStore: tokenStore,
  ),
  child: child,
);

/// A container with the same environment as [_testScope].
///
/// Provider build failures are never retried, so a test that asserts a failure
/// fails immediately instead of waiting on Riverpod's backoff.
ProviderContainer testContainer({
  required SharedPreferences preferences,
  required AiDataSource dataSource,
  AiConfig config = _testAiConfig,
  FakeAuthTokenStore? tokenStore,
}) => ProviderContainer(
  retry: (retryCount, error) => null,
  overrides: _overrides(
    preferences: preferences,
    dataSource: dataSource,
    config: config,
    tokenStore: tokenStore,
  ),
);

/// Pumps the whole app, including routing and localization, at [location].
Future<void> pumpApp(
  WidgetTester tester, {
  required SharedPreferences preferences,
  required AiDataSource dataSource,
  String location = '/',
  AiConfig config = _testAiConfig,
  FakeAuthTokenStore? tokenStore,
}) async {
  _setUpPluginMocks();
  // A tall surface keeps lazily built list content (examples, output panels,
  // error views) in the widget tree, so tests do not fight the viewport.
  tester.view.physicalSize = const Size(420, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    _testScope(
      preferences: preferences,
      dataSource: dataSource,
      config: config,
      tokenStore: tokenStore,
      child: KhmerAiApp(initialLocation: location),
    ),
  );
  await tester.pump();
}

/// Convenience wrapper that also creates a fake data source.
Future<FakeAiDataSource> pumpAppWithFake(
  WidgetTester tester, {
  String location = '/',
  Map<String, Object> preferenceValues = const <String, Object>{},
  FakeAiDataSource? dataSource,
  AiConfig config = _testAiConfig,
  FakeAuthTokenStore? tokenStore,
}) async {
  final fake = dataSource ?? FakeAiDataSource();
  final preferences = await setUpTestPreferences(preferenceValues);
  await pumpApp(
    tester,
    preferences: preferences,
    dataSource: fake,
    location: location,
    config: config,
    tokenStore: tokenStore,
  );
  return fake;
}

/// Stubs the plugin channels that have no implementation under `flutter test`.
void _setUpPluginMocks() {
  PackageInfo.setMockInitialValues(
    appName: 'Khmer AI Assistant',
    packageName: 'com.khmerai.khmer_ai_assistant',
    version: '0.1.0',
    buildNumber: '1',
    buildSignature: '',
  );
}
