import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_local_data_source.dart';

/// Stores conversations as a single JSON document in shared preferences.
///
/// This is adequate for the MVP data volume (bounded by
/// [_maxStoredConversations] conversations with bounded message counts). If
/// conversations grow beyond that, replace this class with a database-backed
/// implementation of the same interface — no other layer needs to change.
class SharedPreferencesChatLocalDataSource implements ChatLocalDataSource {
  SharedPreferencesChatLocalDataSource(this._preferences);

  static const String storageKey = 'chat_conversations_v1';

  /// Upper bound on stored conversations; oldest are dropped first.
  static const int _maxStoredConversations = 100;

  final SharedPreferences _preferences;

  @override
  Future<List<Map<String, dynamic>>> readAll() async {
    final raw = _preferences.getString(storageKey);
    if (raw == null || raw.isEmpty) return <Map<String, dynamic>>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return <Map<String, dynamic>>[];
      final result = <Map<String, dynamic>>[];
      for (final entry in decoded) {
        if (entry is Map) result.add(entry.cast<String, dynamic>());
      }
      return result;
    } on FormatException catch (error) {
      // A corrupted document must not crash the app; the data is dropped and
      // the failure is visible in debug logs only.
      if (kDebugMode) debugPrint('[chat] ignoring corrupted storage: $error');
      return <Map<String, dynamic>>[];
    }
  }

  @override
  Future<void> writeAll(List<Map<String, dynamic>> conversations) async {
    final bounded = conversations.length > _maxStoredConversations
        ? conversations.sublist(0, _maxStoredConversations)
        : conversations;
    await _preferences.setString(storageKey, jsonEncode(bounded));
  }
}
