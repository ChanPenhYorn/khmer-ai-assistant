import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_token_store.dart';

/// [AuthTokenStore] backed by the platform keystore / keychain.
class SecureAuthTokenStore implements AuthTokenStore {
  SecureAuthTokenStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'ai_access_token';

  final FlutterSecureStorage _storage;
  String? _cached;
  bool _loaded = false;

  @override
  Future<String?> read() async {
    if (_loaded) return _cached;
    try {
      final value = await _storage.read(key: _tokenKey);
      _cached = (value == null || value.isEmpty) ? null : value;
    } catch (_) {
      // A keystore read can fail on a wiped keychain; treat as "no token".
      _cached = null;
    }
    _loaded = true;
    return _cached;
  }

  @override
  Future<void> write(String? token) async {
    final normalized = (token == null || token.trim().isEmpty)
        ? null
        : token.trim();
    if (normalized == null) {
      await clear();
      return;
    }
    await _storage.write(key: _tokenKey, value: normalized);
    _cached = normalized;
    _loaded = true;
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    _cached = null;
    _loaded = true;
  }

  /// Drops the in-memory copy so the next [read] hits the keystore again.
  void invalidateCache() {
    _loaded = false;
    _cached = null;
  }
}
