import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_providers.g.dart';

/// The shared preferences instance, created once in `main()`.
///
/// Reading it is synchronous after startup, which keeps settings and chat
/// persistence free of loading flicker. Tests override this provider with
/// `SharedPreferences.setMockInitialValues` output.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError(
  'sharedPreferencesProvider must be overridden in ProviderScope',
);
