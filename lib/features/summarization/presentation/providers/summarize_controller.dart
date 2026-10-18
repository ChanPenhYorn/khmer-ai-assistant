import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../core/utils/text_utils.dart';
import '../../../ai/domain/entities/ai_language.dart';
import '../../../ai/domain/entities/ai_task_options.dart';
import '../../../ai/presentation/providers/ai_providers.dart';
import '../../../ai/presentation/providers/generation_status.dart';
import 'summarize_state.dart';

part 'summarize_controller.g.dart';

/// Drives the summarization screen.
@riverpod
class SummarizeController extends _$SummarizeController {
  @override
  SummarizeState build() => const SummarizeState();

  void setStyle(SummaryStyle style) => state = state.copyWith(style: style);

  void setOutputLanguage(AiLanguage language) =>
      state = state.copyWith(outputLanguage: language);

  void setInput(String value) => state = state.copyWith(input: value);

  void clearInput() => state = state.copyWith(
    input: '',
    output: '',
    status: GenerationStatus.idle,
    failure: null,
  );

  void clearOutput() => state = state.copyWith(
    output: '',
    status: GenerationStatus.idle,
    failure: null,
  );

  /// Character count of the current input, after trimming.
  int get inputLength => TextUtils.characterCount(state.input);

  Future<void> summarize() async {
    if (!state.canSummarize) return;
    state = state.copyWith(status: GenerationStatus.loading, failure: null);

    try {
      final reply = await ref.read(summarizeTextProvider)(
        text: state.input,
        style: state.style,
        outputLanguage: state.outputLanguage,
      );
      state = state.copyWith(
        output: reply.text,
        status: GenerationStatus.success,
        failure: null,
      );
    } on AppFailure catch (failure) {
      state = state.copyWith(
        status: GenerationStatus.failure,
        failure: failure,
      );
    } catch (error) {
      state = state.copyWith(
        status: GenerationStatus.failure,
        failure: toAppFailure(error),
      );
    }
  }

  Future<void> retry() => summarize();
}
