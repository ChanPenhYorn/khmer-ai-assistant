import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../ai/domain/entities/ai_language.dart';
import '../../../ai/presentation/providers/ai_providers.dart';
import '../../../ai/presentation/providers/generation_status.dart';
import 'translation_state.dart';

part 'translation_controller.g.dart';

/// Drives the Khmer↔English translation screen.
@riverpod
class TranslationController extends _$TranslationController {
  @override
  TranslationState build() => const TranslationState();

  void setSource(AiLanguage source) {
    // Picking the same language on both sides swaps the target so the user
    // never ends up with a no-op request.
    final target = state.target == source
        ? state.source.opposite
        : state.target;
    state = state.copyWith(source: source, target: target, failure: null);
  }

  void setTarget(AiLanguage target) {
    state = state.copyWith(target: target, failure: null);
  }

  void swap() {
    final resolvedSource = state.effectiveSource;
    state = state.copyWith(
      source: state.target,
      target: resolvedSource == AiLanguage.auto
          ? AiLanguage.khmer
          : resolvedSource,
      output: state.output,
      failure: null,
    );
  }

  void setInput(String value) {
    state = state.copyWith(input: value);
  }

  void clearInput() {
    state = state.copyWith(
      input: '',
      output: '',
      status: GenerationStatus.idle,
      detectedLanguageCode: null,
      failure: null,
    );
  }

  void clearOutput() {
    state = state.copyWith(
      output: '',
      status: GenerationStatus.idle,
      failure: null,
    );
  }

  Future<void> translate() async {
    if (!state.canTranslate) return;
    state = state.copyWith(status: GenerationStatus.loading, failure: null);

    try {
      final reply = await ref.read(translateTextProvider)(
        text: state.input,
        source: state.source,
        target: state.target,
      );
      state = state.copyWith(
        output: reply.text,
        status: GenerationStatus.success,
        detectedLanguageCode: reply.detectedLanguage,
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

  Future<void> retry() => translate();
}
