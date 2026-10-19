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
import '../../../../core/widgets/copy_action.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../../core/widgets/tool_panes.dart';
import '../providers/writing_controller.dart';

/// Writing assistant: improve, rewrite, reformat and draft text.
class WritingScreen extends ConsumerStatefulWidget {
  const WritingScreen({super.key});

  @override
  ConsumerState<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends ConsumerState<WritingScreen> {
  late final TextEditingController _inputController;
  late final TextEditingController _outputController;
  bool _syncingOutput = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(writingControllerProvider);
    _inputController = TextEditingController(text: state.input);
    _outputController = TextEditingController(text: state.output);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(writingControllerProvider);
    final controller = ref.read(writingControllerProvider.notifier);
    final l10n = context.l10n;
    final maxInput = ref.watch(aiConfigProvider).maxInputCharacters;

    if (_inputController.text != state.input) {
      _inputController.value = TextEditingValue(
        text: state.input,
        selection: TextSelection.collapsed(offset: state.input.length),
      );
    }
    if (!_syncingOutput && _outputController.text != state.output) {
      _syncingOutput = true;
      _outputController.value = TextEditingValue(
        text: state.output,
        selection: TextSelection.collapsed(offset: state.output.length),
      );
      _syncingOutput = false;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.writingTitle)),
      body: SafeArea(
        child: ToolPanes(
          inputPane: [
            OptionChips<WritingAction>(
              options: WritingAction.values,
              selected: state.action,
              onSelected: controller.setAction,
              labelOf: _actionLabel,
            ),
            const SizedBox(height: AppConstants.spaceLg),
            AppTextField(
              controller: _inputController,
              hintText: state.requiresTopic
                  ? l10n.writingTopicHint
                  : l10n.writingInputHint,
              label: state.requiresTopic ? l10n.writingTopicHint : null,
              minLines: 4,
              maxLines: 10,
              maxLength: maxInput,
              onChanged: controller.setInput,
            ),
            const SizedBox(height: AppConstants.spaceSm),
            LanguageSelector(
              value: state.targetLanguage,
              onChanged: controller.setTargetLanguage,
              label: l10n.writingTargetLanguage,
            ),
            const SizedBox(height: AppConstants.spaceMd),
            OptionChips<WritingTone>(
              options: WritingTone.values,
              selected: state.tone,
              onSelected: controller.setTone,
              title: l10n.writingTone,
              labelOf: _toneLabel,
            ),
            const SizedBox(height: AppConstants.spaceLg),
            AppButton(
              label: l10n.writingGenerate,
              icon: Icons.auto_fix_high,
              expand: true,
              isLoading: state.isLoading,
              onPressed: state.canGenerate ? controller.generate : null,
            ),
            if (state.status.hasFailed && state.failure != null) ...[
              const SizedBox(height: AppConstants.spaceMd),
              AppErrorView(
                failure: state.failure!,
                compact: true,
                onRetry: controller.retry,
              ),
            ],
          ],
          outputPane: [
            if (state.isLoading) ...[
              const AppLoadingIndicator(),
              const SizedBox(height: AppConstants.spaceLg),
            ],
            _EditableDraft(
              controller: _outputController,
              label: l10n.writingOutputLabel,
              placeholder: l10n.writingOutputPlaceholder,
              notice: l10n.writingOutputNotice,
              hint: l10n.writingEditHint,
              onChanged: controller.setOutput,
              onClear: state.output.isEmpty ? null : controller.clearOutput,
            ),
          ],
        ),
      ),
    );
  }

  String _actionLabel(BuildContext context, WritingAction action) =>
      switch (action) {
        WritingAction.improve => context.l10n.writingActionImprove,
        WritingAction.fixGrammar => context.l10n.writingActionFixGrammar,
        WritingAction.professional => context.l10n.writingActionProfessional,
        WritingAction.friendly => context.l10n.writingActionFriendly,
        WritingAction.shorten => context.l10n.writingActionShorten,
        WritingAction.expand => context.l10n.writingActionExpand,
        WritingAction.draftMessage => context.l10n.writingActionDraftMessage,
        WritingAction.draftJobApplication =>
          context.l10n.writingActionDraftJobApplication,
      };

  String _toneLabel(BuildContext context, WritingTone tone) => switch (tone) {
    WritingTone.neutral => context.l10n.writingToneNeutral,
    WritingTone.professional => context.l10n.writingToneProfessional,
    WritingTone.friendly => context.l10n.writingToneFriendly,
    WritingTone.casual => context.l10n.writingToneCasual,
  };
}

/// Draft area that can be edited before copying.
class _EditableDraft extends StatelessWidget {
  const _EditableDraft({
    required this.controller,
    required this.label,
    required this.placeholder,
    required this.notice,
    required this.hint,
    required this.onChanged,
    this.onClear,
  });

  final TextEditingController controller;
  final String label;
  final String placeholder;
  final String notice;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final hasText = controller.text.trim().isNotEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(label, style: context.texts.titleMedium)),
                if (onClear != null && hasText)
                  IconButton(
                    tooltip: context.l10n.actionClear,
                    onPressed: onClear,
                    icon: const Icon(Icons.backspace_outlined, size: 18),
                  ),
                CopyAction(text: controller.text),
              ],
            ),
            const SizedBox(height: AppConstants.spaceSm),
            AppTextField(
              controller: controller,
              hintText: placeholder,
              minLines: 5,
              maxLines: 14,
              onChanged: onChanged,
            ),
            const SizedBox(height: AppConstants.spaceSm),
            Text(
              hasText ? '$notice $hint' : hint,
              style: context.texts.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        );
      },
    );
  }
}
