import 'package:khmer_ai_assistant/core/storage/auth_token_store.dart';

/// In-memory stand-in for the platform secure storage.
///
/// The real store talks to a platform channel that is unavailable under
/// `flutter test`, and an unhandled `MissingPluginException` there would fail
/// unrelated tests.
class FakeAuthTokenStore implements AuthTokenStore {
  FakeAuthTokenStore([this._token]);

  String? _token;

  /// Number of times the store was read, so tests can assert lazy loading.
  int readCalls = 0;

  @override
  Future<String?> read() async {
    readCalls++;
    return _token;
  }

  @override
  Future<void> write(String? token) async {
    _token = (token == null || token.isEmpty) ? null : token;
  }

  @override
  Future<void> clear() async {
    _token = null;
  }
}
