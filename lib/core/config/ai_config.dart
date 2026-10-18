import 'package:flutter/foundation.dart';

/// Configuration for the AI backend the client talks to.
///
/// The client never talks to an AI vendor directly: it only knows an
/// endpoint owned by the operator of the app. Vendor API keys therefore stay
/// on the server. See `backend/README.md`.
@immutable
class AiConfig {
  const AiConfig({
    required this.baseUrl,
    required this.assistantPath,
    required this.requestTimeout,
    required this.maxInputCharacters,
    required this.useMockDataSource,
    required this.streamingEnabled,
  });

  /// Backend used when `--dart-define=AI_BASE_URL` is not supplied.
  ///
  /// Baked in so a plain `flutter run` is connected instead of showing a
  /// misconfiguration. Override it for staging, a local proxy, or a different
  /// deployment:
  /// `--dart-define=AI_BASE_URL=https://example.test`.
  static const String defaultBaseUrl = 'https://api.chanpenh.store';

  /// Reads configuration from `--dart-define` values.
  factory AiConfig.fromEnvironment() {
    const baseUrl = String.fromEnvironment(
      'AI_BASE_URL',
      defaultValue: defaultBaseUrl,
    );
    const timeoutSeconds = int.fromEnvironment(
      'AI_REQUEST_TIMEOUT_SECONDS',
      defaultValue: 45,
    );
    // Demo mode must be requested explicitly. It is never enabled silently.
    const useMock = bool.fromEnvironment('AI_USE_MOCK');
    const streaming = bool.fromEnvironment(
      'AI_ENABLE_STREAMING',
      defaultValue: true,
    );
    const maxInput = int.fromEnvironment(
      'AI_MAX_INPUT_CHARS',
      defaultValue: 6000,
    );
    return const AiConfig(
      baseUrl: baseUrl,
      assistantPath: String.fromEnvironment(
        'AI_ASSISTANT_PATH',
        defaultValue: '/v1/assistant',
      ),
      requestTimeout: Duration(
        seconds: timeoutSeconds <= 0 ? 45 : timeoutSeconds,
      ),
      maxInputCharacters: maxInput,
      useMockDataSource: useMock,
      streamingEnabled: streaming,
    );
  }

  /// Base URL of the AI proxy, for example `https://api.chanpenh.store`.
  /// Defaults to [defaultBaseUrl]; empty only when a build explicitly clears it.
  final String baseUrl;

  /// Path appended to [baseUrl] for assistant requests.
  final String assistantPath;

  final Duration requestTimeout;
  final int maxInputCharacters;

  /// When `true` the app answers from a local sample data source.
  ///
  /// This is intended for development and demos only and is surfaced in the UI
  /// as "Demo mode" so it can never be mistaken for a real provider.
  final bool useMockDataSource;

  /// Whether the app should ask the backend for a streamed response.
  final bool streamingEnabled;

  /// `true` when a real backend address is configured.
  bool get hasRemoteEndpoint => baseUrl.trim().isNotEmpty;

  /// `true` when the app cannot reach a real AI provider and cannot fall back
  /// to a demo either — the UI must explain this instead of pretending.
  ///
  /// Default builds always resolve [defaultBaseUrl], so this is only reachable
  /// when a build explicitly clears `AI_BASE_URL` without enabling demo mode.
  bool get isMisconfigured => !hasRemoteEndpoint && !useMockDataSource;

  /// Full URL for assistant requests, or `null` when no backend is configured.
  Uri? get assistantUri {
    if (!hasRemoteEndpoint) return null;
    final normalizedBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final path = assistantPath.startsWith('/')
        ? assistantPath
        : '/$assistantPath';
    return Uri.tryParse('$normalizedBase$path');
  }

  /// Exposed for diagnostics and Settings. Never contains secrets.
  @override
  String toString() =>
      'AiConfig(baseUrl: ${hasRemoteEndpoint ? baseUrl : '<unset>'}, '
      'mock: $useMockDataSource, streaming: $streamingEnabled)';
}
