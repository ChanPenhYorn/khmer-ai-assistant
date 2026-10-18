// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summarize_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the summarization screen.

@ProviderFor(SummarizeController)
final summarizeControllerProvider = SummarizeControllerProvider._();

/// Drives the summarization screen.
final class SummarizeControllerProvider
    extends $NotifierProvider<SummarizeController, SummarizeState> {
  /// Drives the summarization screen.
  SummarizeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'summarizeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$summarizeControllerHash();

  @$internal
  @override
  SummarizeController create() => SummarizeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SummarizeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SummarizeState>(value),
    );
  }
}

String _$summarizeControllerHash() =>
    r'47233e6151535c8ab71b4b9dd559e1b8835a74dc';

/// Drives the summarization screen.

abstract class _$SummarizeController extends $Notifier<SummarizeState> {
  SummarizeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SummarizeState, SummarizeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SummarizeState, SummarizeState>,
              SummarizeState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
