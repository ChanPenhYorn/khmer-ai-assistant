// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_usage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Last usage metadata reported by the backend.
///
/// Starts empty and stays empty until the server actually reports something:
/// the app never estimates or fabricates quota numbers.

@ProviderFor(AiUsageController)
final aiUsageControllerProvider = AiUsageControllerProvider._();

/// Last usage metadata reported by the backend.
///
/// Starts empty and stays empty until the server actually reports something:
/// the app never estimates or fabricates quota numbers.
final class AiUsageControllerProvider
    extends $NotifierProvider<AiUsageController, AiUsage> {
  /// Last usage metadata reported by the backend.
  ///
  /// Starts empty and stays empty until the server actually reports something:
  /// the app never estimates or fabricates quota numbers.
  AiUsageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiUsageControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiUsageControllerHash();

  @$internal
  @override
  AiUsageController create() => AiUsageController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiUsage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiUsage>(value),
    );
  }
}

String _$aiUsageControllerHash() => r'48000f8921dda93d06eae1e7d6681ba27dfe5ea9';

/// Last usage metadata reported by the backend.
///
/// Starts empty and stays empty until the server actually reports something:
/// the app never estimates or fabricates quota numbers.

abstract class _$AiUsageController extends $Notifier<AiUsage> {
  AiUsage build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AiUsage, AiUsage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AiUsage, AiUsage>,
              AiUsage,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
