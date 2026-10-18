// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Emits `true` while the device reports no active network interface.
///
/// This reports link state, not reachability: a connected network can still
/// fail to reach the AI server, which the app surfaces as a network failure
/// from the request itself. The banner is therefore worded as a warning.

@ProviderFor(offline)
final offlineProvider = OfflineProvider._();

/// Emits `true` while the device reports no active network interface.
///
/// This reports link state, not reachability: a connected network can still
/// fail to reach the AI server, which the app surfaces as a network failure
/// from the request itself. The banner is therefore worded as a warning.

final class OfflineProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Emits `true` while the device reports no active network interface.
  ///
  /// This reports link state, not reachability: a connected network can still
  /// fail to reach the AI server, which the app surfaces as a network failure
  /// from the request itself. The banner is therefore worded as a warning.
  OfflineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offlineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offlineHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return offline(ref);
  }
}

String _$offlineHash() => r'931568760652f89a0c4fb119b284784bbb23a932';
