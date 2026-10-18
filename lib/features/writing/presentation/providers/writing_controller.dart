import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../ai/domain/entities/ai_language.dart';
import '../../../ai/domain/entities/ai_task_options.dart';
import '../../../ai/presentation/providers/ai_providers.dart';
import '../../../ai/presentation/providers/generation_status.dart';
import 'writing_state.dart';

part 'writing_controller.g.dart';

/// Drives the writing assistant screen.
@riverpod
class WritingController extends _$WritingController {
  @override
  WritingState build() => const WritingState();

  void setAction(WritingAction action) {
    // A new action invalidates the previous draft but keeps the input, so the
    // user can apply several actions to the same text in a row.
    state = state.copyWith(
      action: action,
      failure: null,
      status: state.output.isEmpty
          ? GenerationStatus.idle
          : GenerationStatus.success,
    );
  }

  void setTone(WritingTone tone) => state = state.copyWith(tone: tone);

  void setTargetLanguage(AiLanguage language) =>
      state = state.copyWith(targetLanguage: language);

  void setInput(String value) => state = state.copyWith(input: value);

  /// Updates the draft in place, so the user can edit before copying.
  void setOutput(String value) => state = state.copyWith(output: value);

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

  Future<void> generate() async {
    if (!state.canGenerate) return;
    state = state.copyWith(status: GenerationStatus.loading, failure: null);

    try {
      final reply = await ref.read(improveWritingProvider)(
        text: state.input,
        action: state.action,
        tone: state.tone,
        targetLanguage: state.targetLanguage,
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

  Future<void> retry() => generate();
}
