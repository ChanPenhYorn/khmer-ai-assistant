// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the Khmer↔English translation screen.

@ProviderFor(TranslationController)
final translationControllerProvider = TranslationControllerProvider._();

/// Drives the Khmer↔English translation screen.
final class TranslationControllerProvider
    extends $NotifierProvider<TranslationController, TranslationState> {
  /// Drives the Khmer↔English translation screen.
  TranslationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'translationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$translationControllerHash();

  @$internal
  @override
  TranslationController create() => TranslationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TranslationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TranslationState>(value),
    );
  }
}

String _$translationControllerHash() =>
    r'0b2414ba75de254a56337fb279e1e0b11d2fbdf4';

/// Drives the Khmer↔English translation screen.

abstract class _$TranslationController extends $Notifier<TranslationState> {
  TranslationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TranslationState, TranslationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TranslationState, TranslationState>,
              TranslationState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
