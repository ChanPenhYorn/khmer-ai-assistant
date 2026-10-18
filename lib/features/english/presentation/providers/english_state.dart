import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../ai/domain/entities/ai_language.dart';
import '../../../ai/presentation/providers/generation_status.dart';

part 'english_state.freezed.dart';

/// State of the English learning screen.
@freezed
abstract class EnglishState with _$EnglishState {
  const factory EnglishState({
    @Default(AiLanguage.khmer) AiLanguage explanationLanguage,
    @Default('') String input,
    @Default('') String output,
    @Default(GenerationStatus.idle) GenerationStatus status,
    AppFailure? failure,
  }) = _EnglishState;

  const EnglishState._();

  bool get isLoading => status.isLoading;

  bool get canExplain => input.trim().isNotEmpty && !isLoading;
}
