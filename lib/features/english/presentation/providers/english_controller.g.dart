// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'english_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the English learning screen.

@ProviderFor(EnglishController)
final englishControllerProvider = EnglishControllerProvider._();

/// Drives the English learning screen.
final class EnglishControllerProvider
    extends $NotifierProvider<EnglishController, EnglishState> {
  /// Drives the English learning screen.
  EnglishControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'englishControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$englishControllerHash();

  @$internal
  @override
  EnglishController create() => EnglishController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EnglishState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EnglishState>(value),
    );
  }
}

String _$englishControllerHash() => r'7ffbd321f5c0700bd3e6fb636241fe241a2f4604';

/// Drives the English learning screen.

abstract class _$EnglishController extends $Notifier<EnglishState> {
  EnglishState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<EnglishState, EnglishState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EnglishState, EnglishState>,
              EnglishState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
