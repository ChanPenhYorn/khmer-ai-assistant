// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'writing_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the writing assistant screen.

@ProviderFor(WritingController)
final writingControllerProvider = WritingControllerProvider._();

/// Drives the writing assistant screen.
final class WritingControllerProvider
    extends $NotifierProvider<WritingController, WritingState> {
  /// Drives the writing assistant screen.
  WritingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'writingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$writingControllerHash();

  @$internal
  @override
  WritingController create() => WritingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WritingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WritingState>(value),
    );
  }
}

String _$writingControllerHash() => r'2760e1072d65a9febe02299df0f35a891832109d';

/// Drives the writing assistant screen.

abstract class _$WritingController extends $Notifier<WritingState> {
  WritingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<WritingState, WritingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WritingState, WritingState>,
              WritingState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
