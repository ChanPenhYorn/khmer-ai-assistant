import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_providers.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../../core/widgets/output_card.dart';
import '../providers/english_controller.dart';

/// English learning: words, phrases and sentences explained in Khmer.
class EnglishLearningScreen extends ConsumerStatefulWidget {
  const EnglishLearningScreen({super.key});

  @override
  ConsumerState<EnglishLearningScreen> createState() =>
      _EnglishLearningScreenState();
}

class _EnglishLearningScreenState extends ConsumerState<EnglishLearningScreen> {
  late final TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(
      text: ref.read(englishControllerProvider).input,
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(englishControllerProvider);
    final controller = ref.read(englishControllerProvider.notifier);
    final l10n = context.l10n;
    final maxInput = ref.watch(aiConfigProvider).maxInputCharacters;

    if (_inputController.text != state.input) {
      _inputController.value = TextEditingValue(
        text: state.input,
        selection: TextSelection.collapsed(offset: state.input.length),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.englishTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spaceMd),
          children: [
            AppTextField(
              controller: _inputController,
              hintText: l10n.englishInputHint,
              minLines: 2,
              maxLines: 6,
              maxLength: maxInput,
              onChanged: controller.setInput,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => controller.explain(),
            ),
            const SizedBox(height: AppConstants.spaceSm),
            LanguageSelector(
              value: state.explanationLanguage,
              onChanged: controller.setExplanationLanguage,
              label: l10n.writingTargetLanguage,
            ),
            const SizedBox(height: AppConstants.spaceLg),
            AppButton(
              label: l10n.englishAction,
              icon: Icons.school_outlined,
              expand: true,
              isLoading: state.isLoading,
              onPressed: state.canExplain ? controller.explain : null,
            ),
            if (state.status.hasFailed && state.failure != null) ...[
              const SizedBox(height: AppConstants.spaceMd),
              AppErrorView(
                failure: state.failure!,
                compact: true,
                onRetry: controller.retry,
              ),
            ],
            if (state.isLoading) const AppLoadingIndicator(),
            const SizedBox(height: AppConstants.spaceLg),
            OutputCard(
              label: l10n.englishOutputLabel,
              text: state.output,
              placeholder: l10n.englishOutputPlaceholder,
              minHeight: 120,
              onClear: state.output.isEmpty ? null : controller.clearOutput,
            ),
            const SizedBox(height: AppConstants.spaceXl),
          ],
        ),
      ),
    );
  }
}
