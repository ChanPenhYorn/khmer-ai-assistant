import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../ai/domain/entities/ai_language.dart';
import '../../../ai/domain/entities/ai_task_options.dart';
import '../../../ai/presentation/providers/generation_status.dart';

part 'writing_state.freezed.dart';

/// State of the writing assistant screen.
@freezed
abstract class WritingState with _$WritingState {
  const factory WritingState({
    @Default(WritingAction.improve) WritingAction action,
    @Default(WritingTone.neutral) WritingTone tone,
    @Default(AiLanguage.khmer) AiLanguage targetLanguage,
    @Default('') String input,
    @Default('') String output,
    @Default(GenerationStatus.idle) GenerationStatus status,
    AppFailure? failure,
  }) = _WritingState;

  const WritingState._();

  bool get isLoading => status.isLoading;

  /// Drafting actions take a topic instead of source text; the label and hint
  /// of the input field change accordingly.
  bool get requiresTopic => action.requiresTopic;

  bool get canGenerate => input.trim().isNotEmpty && !isLoading;
}
