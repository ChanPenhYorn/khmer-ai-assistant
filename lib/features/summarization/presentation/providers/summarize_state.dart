import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../ai/domain/entities/ai_language.dart';
import '../../../ai/domain/entities/ai_task_options.dart';
import '../../../ai/presentation/providers/generation_status.dart';

part 'summarize_state.freezed.dart';

/// State of the summarization screen.
@freezed
abstract class SummarizeState with _$SummarizeState {
  const factory SummarizeState({
    @Default(SummaryStyle.bullets) SummaryStyle style,
    @Default(AiLanguage.khmer) AiLanguage outputLanguage,
    @Default('') String input,
    @Default('') String output,
    @Default(GenerationStatus.idle) GenerationStatus status,
    AppFailure? failure,
  }) = _SummarizeState;

  const SummarizeState._();

  bool get isLoading => status.isLoading;

  bool get canSummarize =>
      input.trim().length >= minimumCharacters && !isLoading;

  /// Feedback shown under the input before a request is attempted.
  bool get isTooShort =>
      input.trim().isNotEmpty && input.trim().length < minimumCharacters;

  static const int minimumCharacters = 40;
}
