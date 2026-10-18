import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/storage/preferences_providers.dart';

/// Application entry point.
///
/// `SharedPreferences` is resolved before the first frame so settings and
/// conversation history are available synchronously and the UI never flashes a
/// wrong theme or language.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: const KhmerAiApp(),
    ),
  );
}
