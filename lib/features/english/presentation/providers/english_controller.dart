import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../ai/domain/entities/ai_language.dart';
import '../../../ai/presentation/providers/ai_providers.dart';
import '../../../ai/presentation/providers/generation_status.dart';
import 'english_state.dart';

part 'english_controller.g.dart';

/// Drives the English learning screen.
@riverpod
class EnglishController extends _$EnglishController {
  @override
  EnglishState build() => const EnglishState();

  void setExplanationLanguage(AiLanguage language) =>
      state = state.copyWith(explanationLanguage: language);

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

  Future<void> explain() async {
    if (!state.canExplain) return;
    state = state.copyWith(status: GenerationStatus.loading, failure: null);

    try {
      final reply = await ref.read(explainEnglishProvider)(
        text: state.input,
        explanationLanguage: state.explanationLanguage,
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

  Future<void> retry() => explain();
}
