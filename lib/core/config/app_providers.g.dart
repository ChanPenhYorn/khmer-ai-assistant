// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Active AI backend configuration.
///
/// Overridden in tests (and could be overridden by a future remote-config
/// feature) so nothing else has to read compile-time constants directly.

@ProviderFor(aiConfig)
final aiConfigProvider = AiConfigProvider._();

/// Active AI backend configuration.
///
/// Overridden in tests (and could be overridden by a future remote-config
/// feature) so nothing else has to read compile-time constants directly.

final class AiConfigProvider
    extends $FunctionalProvider<AiConfig, AiConfig, AiConfig>
    with $Provider<AiConfig> {
  /// Active AI backend configuration.
  ///
  /// Overridden in tests (and could be overridden by a future remote-config
  /// feature) so nothing else has to read compile-time constants directly.
  AiConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiConfigHash();

  @$internal
  @override
  $ProviderElement<AiConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiConfig create(Ref ref) {
    return aiConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiConfig>(value),
    );
  }
}

String _$aiConfigHash() => r'1af2a401758e12639b9a0903ce3b6b1513c12a62';
