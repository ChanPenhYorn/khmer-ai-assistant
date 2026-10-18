import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ai/domain/entities/ai_task_options.dart';
import '../../../../core/config/app_providers.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../../core/widgets/output_card.dart';
import '../providers/summarize_controller.dart';

/// Summarization screen: paste text, choose a style, get key points.
class SummarizeScreen extends ConsumerStatefulWidget {
  const SummarizeScreen({super.key});

  @override
  ConsumerState<SummarizeScreen> createState() => _SummarizeScreenState();
}

class _SummarizeScreenState extends ConsumerState<SummarizeScreen> {
  late final TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(
      text: ref.read(summarizeControllerProvider).input,
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(summarizeControllerProvider);
    final controller = ref.read(summarizeControllerProvider.notifier);
    final l10n = context.l10n;
    final maxInput = ref.watch(aiConfigProvider).maxInputCharacters;

    if (_inputController.text != state.input) {
      _inputController.value = TextEditingValue(
        text: state.input,
        selection: TextSelection.collapsed(offset: state.input.length),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.summarizeTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spaceMd),
          children: [
            OptionChips<SummaryStyle>(
              options: SummaryStyle.values,
              selected: state.style,
              onSelected: controller.setStyle,
              title: l10n.summarizeStyle,
              labelOf: (context, style) => switch (style) {
                SummaryStyle.short => context.l10n.summarizeStyleShort,
                SummaryStyle.detailed => context.l10n.summarizeStyleDetailed,
                SummaryStyle.bullets => context.l10n.summarizeStyleBullets,
              },
            ),
            const SizedBox(height: AppConstants.spaceLg),
            AppTextField(
              controller: _inputController,
              hintText: l10n.summarizeInputHint,
              minLines: 6,
              maxLines: 16,
              maxLength: maxInput,
              onChanged: controller.setInput,
              helperText: l10n.summarizeCounter(
                state.input.trim().length,
                maxInput,
              ),
              errorText: state.isTooShort ? l10n.summarizeInputRequired : null,
            ),
            const SizedBox(height: AppConstants.spaceSm),
            LanguageSelector(
              value: state.outputLanguage,
              onChanged: controller.setOutputLanguage,
              label: l10n.writingTargetLanguage,
            ),
            const SizedBox(height: AppConstants.spaceLg),
            AppButton(
              label: l10n.summarizeAction,
              icon: Icons.summarize_outlined,
              expand: true,
              isLoading: state.isLoading,
              onPressed: state.canSummarize ? controller.summarize : null,
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
              label: l10n.summarizeOutputLabel,
              text: state.output,
              placeholder: l10n.summarizeOutputPlaceholder,
              draftNotice: l10n.writingOutputNotice,
              onClear: state.output.isEmpty ? null : controller.clearOutput,
            ),
            const SizedBox(height: AppConstants.spaceXl),
          ],
        ),
      ),
    );
  }
}
