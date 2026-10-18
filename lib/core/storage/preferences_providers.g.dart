// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The shared preferences instance, created once in `main()`.
///
/// Reading it is synchronous after startup, which keeps settings and chat
/// persistence free of loading flicker. Tests override this provider with
/// `SharedPreferences.setMockInitialValues` output.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// The shared preferences instance, created once in `main()`.
///
/// Reading it is synchronous after startup, which keeps settings and chat
/// persistence free of loading flicker. Tests override this provider with
/// `SharedPreferences.setMockInitialValues` output.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  /// The shared preferences instance, created once in `main()`.
  ///
  /// Reading it is synchronous after startup, which keeps settings and chat
  /// persistence free of loading flicker. Tests override this provider with
  /// `SharedPreferences.setMockInitialValues` output.
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'81d3d8618b07e864cee9c277a7398b6a0f0e48eb';
