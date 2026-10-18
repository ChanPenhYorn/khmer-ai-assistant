import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ai/domain/entities/ai_language.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/config/app_providers.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/output_card.dart';
import '../../../../core/widgets/language_selector.dart';
import '../providers/translation_controller.dart';

/// Khmer ↔ English translation screen.
class TranslationScreen extends ConsumerStatefulWidget {
  const TranslationScreen({super.key});

  @override
  ConsumerState<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends ConsumerState<TranslationScreen> {
  late final TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(
      text: ref.read(translationControllerProvider).input,
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(translationControllerProvider);
    final controller = ref.read(translationControllerProvider.notifier);
    final l10n = context.l10n;
    final maxInput = ref.watch(aiConfigProvider).maxInputCharacters;

    // Keep the field in sync when the controller clears or swaps input.
    if (_inputController.text != state.input) {
      _inputController.value = TextEditingValue(
        text: state.input,
        selection: TextSelection.collapsed(offset: state.input.length),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.translateTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spaceMd),
          children: [
            _LanguageBar(
              source: state.source,
              target: state.target,
              onSourceChanged: controller.setSource,
              onTargetChanged: controller.setTarget,
              onSwap: controller.swap,
            ),
            const SizedBox(height: AppConstants.spaceMd),
            AppTextField(
              controller: _inputController,
              hintText: l10n.translateInputHint,
              minLines: 4,
              maxLines: 8,
              maxLength: maxInput,
              onChanged: controller.setInput,
              trailing: _inputController.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: l10n.translateClear,
                      onPressed: () {
                        controller.clearInput();
                        _inputController.clear();
                      },
                      icon: const Icon(Icons.close),
                    ),
            ),
            const SizedBox(height: AppConstants.spaceSm),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: l10n.translateAction,
                    icon: Icons.translate,
                    isLoading: state.isLoading,
                    onPressed: state.canTranslate ? controller.translate : null,
                  ),
                ),
              ],
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
            if (state.detectedLanguageCode != null) ...[
              const SizedBox(height: AppConstants.spaceMd),
              Text(
                l10n.translateDetected(
                  LanguageSelector.languageLabel(
                    context,
                    AiLanguage.fromCode(state.detectedLanguageCode),
                  ),
                ),
                style: context.texts.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppConstants.spaceLg),
            OutputCard(
              label: l10n.translateOutputLabel,
              text: state.output,
              placeholder: l10n.translateOutputEmpty,
              onClear: state.output.isEmpty ? null : controller.clearOutput,
            ),
            const SizedBox(height: AppConstants.spaceMd),
            Text(
              l10n.translateDisclaimer,
              style: context.texts.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppConstants.spaceXl),
          ],
        ),
      ),
    );
  }
}

class _LanguageBar extends StatelessWidget {
  const _LanguageBar({
    required this.source,
    required this.target,
    required this.onSourceChanged,
    required this.onTargetChanged,
    required this.onSwap,
  });

  final AiLanguage source;
  final AiLanguage target;
  final ValueChanged<AiLanguage> onSourceChanged;
  final ValueChanged<AiLanguage> onTargetChanged;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sourceSelector = LanguageSelector(
      value: source,
      onChanged: onSourceChanged,
      includeAuto: true,
      label: l10n.translateFrom,
      semanticLabel:
          '${l10n.translateFrom} ${l10n.languageKhmer}/${l10n.languageEnglish}',
    );
    final targetSelector = LanguageSelector(
      value: target,
      onChanged: onTargetChanged,
      label: l10n.translateTo,
      semanticLabel:
          '${l10n.translateTo} ${l10n.languageKhmer}/${l10n.languageEnglish}',
    );
    final swapButton = Tooltip(
      message: l10n.translateSwap,
      child: IconButton.filledTonal(
        onPressed: onSwap,
        icon: const Icon(Icons.swap_horiz),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 380) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              sourceSelector,
              const SizedBox(height: AppConstants.spaceSm),
              Align(child: swapButton),
              const SizedBox(height: AppConstants.spaceSm),
              targetSelector,
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: sourceSelector),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spaceSm,
                vertical: AppConstants.spaceLg,
              ),
              child: swapButton,
            ),
            Expanded(child: targetSelector),
          ],
        );
      },
    );
  }
}
