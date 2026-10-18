import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../ai/domain/entities/ai_language.dart';
import '../../../ai/presentation/providers/generation_status.dart';

part 'translation_state.freezed.dart';

/// State of the translation screen.
@freezed
abstract class TranslationState with _$TranslationState {
  const factory TranslationState({
    /// Source language. [AiLanguage.auto] detects from the Khmer script.
    @Default(AiLanguage.auto) AiLanguage source,

    /// Language the text is translated into.
    @Default(AiLanguage.khmer) AiLanguage target,

    @Default('') String input,
    @Default('') String output,
    @Default(GenerationStatus.idle) GenerationStatus status,
    AppFailure? failure,

    /// Language reported by the backend, when it reports one. The app does not
    /// invent a detection result.
    String? detectedLanguageCode,
  }) = _TranslationState;

  const TranslationState._();

  bool get isLoading => status.isLoading;

  bool get canTranslate => input.trim().isNotEmpty && !isLoading;

  /// Source language actually used in the request.
  AiLanguage get effectiveSource => source.resolveFrom(input);
}
