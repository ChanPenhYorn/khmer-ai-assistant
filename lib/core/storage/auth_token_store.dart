/// Secure storage for values that must not sit in plain preferences.
///
/// The only value stored here today is an optional access token for the
/// operator's own AI endpoint. AI vendor API keys must never reach the client;
/// see `README.md` ("Security model").
abstract interface class AuthTokenStore {
  /// Returns the stored token, or `null` when none is configured.
  Future<String?> read();

  /// Persists [token]. Passing `null` or an empty string clears it.
  Future<void> write(String? token);

  Future<void> clear();
}
