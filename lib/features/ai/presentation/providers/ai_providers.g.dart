// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The data source used for this process.
///
/// Selection happens once, from configuration. There is no runtime fallback to
/// the sample source: an unconfigured build reports a misconfiguration instead
/// of pretending to answer.

@ProviderFor(aiDataSource)
final aiDataSourceProvider = AiDataSourceProvider._();

/// The data source used for this process.
///
/// Selection happens once, from configuration. There is no runtime fallback to
/// the sample source: an unconfigured build reports a misconfiguration instead
/// of pretending to answer.

final class AiDataSourceProvider
    extends $FunctionalProvider<AiDataSource, AiDataSource, AiDataSource>
    with $Provider<AiDataSource> {
  /// The data source used for this process.
  ///
  /// Selection happens once, from configuration. There is no runtime fallback to
  /// the sample source: an unconfigured build reports a misconfiguration instead
  /// of pretending to answer.
  AiDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiDataSourceHash();

  @$internal
  @override
  $ProviderElement<AiDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiDataSource create(Ref ref) {
    return aiDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiDataSource>(value),
    );
  }
}

String _$aiDataSourceHash() => r'f3413a502224074cd0625558cb43cfc2b62fcdb5';

@ProviderFor(aiRepository)
final aiRepositoryProvider = AiRepositoryProvider._();

final class AiRepositoryProvider
    extends $FunctionalProvider<AiRepository, AiRepository, AiRepository>
    with $Provider<AiRepository> {
  AiRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiRepositoryHash();

  @$internal
  @override
  $ProviderElement<AiRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiRepository create(Ref ref) {
    return aiRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiRepository>(value),
    );
  }
}

String _$aiRepositoryHash() => r'a251b175190d415f8694123500aaa5e387669659';

@ProviderFor(sendMessage)
final sendMessageProvider = SendMessageProvider._();

final class SendMessageProvider
    extends $FunctionalProvider<SendMessage, SendMessage, SendMessage>
    with $Provider<SendMessage> {
  SendMessageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendMessageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendMessageHash();

  @$internal
  @override
  $ProviderElement<SendMessage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SendMessage create(Ref ref) {
    return sendMessage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SendMessage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SendMessage>(value),
    );
  }
}

String _$sendMessageHash() => r'6010feba0088471d5b68c2bf39b0d961259722b2';

@ProviderFor(translateText)
final translateTextProvider = TranslateTextProvider._();

final class TranslateTextProvider
    extends $FunctionalProvider<TranslateText, TranslateText, TranslateText>
    with $Provider<TranslateText> {
  TranslateTextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'translateTextProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$translateTextHash();

  @$internal
  @override
  $ProviderElement<TranslateText> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TranslateText create(Ref ref) {
    return translateText(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TranslateText value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TranslateText>(value),
    );
  }
}

String _$translateTextHash() => r'0b441efc5b2fb328363cb146de249cc42132a96d';

@ProviderFor(improveWriting)
final improveWritingProvider = ImproveWritingProvider._();

final class ImproveWritingProvider
    extends $FunctionalProvider<ImproveWriting, ImproveWriting, ImproveWriting>
    with $Provider<ImproveWriting> {
  ImproveWritingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'improveWritingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$improveWritingHash();

  @$internal
  @override
  $ProviderElement<ImproveWriting> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ImproveWriting create(Ref ref) {
    return improveWriting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImproveWriting value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImproveWriting>(value),
    );
  }
}

String _$improveWritingHash() => r'ebb856988885b410749485abd1d3e2c094698d5b';

@ProviderFor(summarizeText)
final summarizeTextProvider = SummarizeTextProvider._();

final class SummarizeTextProvider
    extends $FunctionalProvider<SummarizeText, SummarizeText, SummarizeText>
    with $Provider<SummarizeText> {
  SummarizeTextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'summarizeTextProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$summarizeTextHash();

  @$internal
  @override
  $ProviderElement<SummarizeText> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SummarizeText create(Ref ref) {
    return summarizeText(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SummarizeText value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SummarizeText>(value),
    );
  }
}

String _$summarizeTextHash() => r'7a78a34fa43aea684c4200f0e8771e5f31055ef0';

@ProviderFor(explainEnglish)
final explainEnglishProvider = ExplainEnglishProvider._();

final class ExplainEnglishProvider
    extends $FunctionalProvider<ExplainEnglish, ExplainEnglish, ExplainEnglish>
    with $Provider<ExplainEnglish> {
  ExplainEnglishProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'explainEnglishProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$explainEnglishHash();

  @$internal
  @override
  $ProviderElement<ExplainEnglish> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ExplainEnglish create(Ref ref) {
    return explainEnglish(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExplainEnglish value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExplainEnglish>(value),
    );
  }
}

String _$explainEnglishHash() => r'8b90e40a1cd3e0e0ecb6c15eeb82f152b4f2788d';
