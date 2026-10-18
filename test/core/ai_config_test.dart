import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/core/config/ai_config.dart';

void main() {
  group('AiConfig.fromEnvironment', () {
    test('defaults to the deployed backend when no define is passed', () {
      final config = AiConfig.fromEnvironment();
      // The deployed backend is baked in, so a plain `flutter run` connects
      // instead of reporting a misconfiguration.
      expect(config.hasRemoteEndpoint, isTrue);
      expect(config.isMisconfigured, isFalse);
      expect(config.assistantUri, isNotNull);
    });

    test('a build that explicitly clears the base url is misconfigured', () {
      const config = AiConfig(
        baseUrl: '',
        assistantPath: '/v1/assistant',
        requestTimeout: Duration(seconds: 30),
        maxInputCharacters: 100,
        useMockDataSource: false,
        streamingEnabled: false,
      );
      expect(config.hasRemoteEndpoint, isFalse);
      expect(config.isMisconfigured, isTrue);
      expect(config.assistantUri, isNull);
    });
  });

  group('AiConfig.assistantUri', () {
    test('joins base url and path', () {
      const config = AiConfig(
        baseUrl: 'https://example.test/functions/v1',
        assistantPath: '/v1/assistant',
        requestTimeout: Duration(seconds: 30),
        maxInputCharacters: 100,
        useMockDataSource: false,
        streamingEnabled: true,
      );
      expect(
        config.assistantUri.toString(),
        'https://example.test/functions/v1/v1/assistant',
      );
    });

    test('tolerates a trailing slash on the base url', () {
      const config = AiConfig(
        baseUrl: 'https://example.test/api/',
        assistantPath: 'assistant',
        requestTimeout: Duration(seconds: 30),
        maxInputCharacters: 100,
        useMockDataSource: false,
        streamingEnabled: false,
      );
      expect(
        config.assistantUri.toString(),
        'https://example.test/api/assistant',
      );
    });

    test('is null without a base url', () {
      const config = AiConfig(
        baseUrl: '',
        assistantPath: '/v1/assistant',
        requestTimeout: Duration(seconds: 30),
        maxInputCharacters: 100,
        useMockDataSource: true,
        streamingEnabled: true,
      );
      expect(config.assistantUri, isNull);
      expect(config.hasRemoteEndpoint, isFalse);
      // Demo mode is an explicit choice, not a misconfiguration.
      expect(config.isMisconfigured, isFalse);
      expect(config.useMockDataSource, isTrue);
    });

    test('never prints the base url as a secret inside toString', () {
      const config = AiConfig(
        baseUrl: '',
        assistantPath: '/v1/assistant',
        requestTimeout: Duration(seconds: 30),
        maxInputCharacters: 100,
        useMockDataSource: false,
        streamingEnabled: false,
      );
      expect(config.toString(), contains('<unset>'));
    });
  });
}
