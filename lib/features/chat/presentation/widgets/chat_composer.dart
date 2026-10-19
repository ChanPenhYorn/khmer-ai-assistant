import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/context_extensions.dart';

/// Message input row for the chat screen.
///
/// The field grows with content up to a cap, `Enter` submits on desktop and web
/// while a newline keeps working on mobile, and the send button turns into a
/// stop button while the assistant is generating.
class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onStop,
    required this.isGenerating,
    required this.enabled,
    this.maxLength,
    this.hintText,
    this.focusNode,
    this.maxWidth,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onStop;
  final bool isGenerating;
  final bool enabled;
  final int? maxLength;
  final String? hintText;
  final FocusNode? focusNode;

  /// Caps the input row width while the surface behind it stays full-bleed.
  final double? maxWidth;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  late final FocusNode _focusNode;
  bool _ownsFocusNode = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    } else {
      _focusNode = widget.focusNode!;
    }
  }

  @override
  void dispose() {
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  bool get _canSend =>
      widget.enabled &&
      !widget.isGenerating &&
      widget.controller.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Material(
      color: colors.surface,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: widget.maxWidth ?? double.infinity,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.spaceMd,
                AppConstants.spaceSm,
                AppConstants.spaceMd,
                AppConstants.spaceSm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusXl,
                        ),
                        border: Border.all(color: colors.outlineVariant),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: widget.controller,
                              focusNode: _focusNode,
                              enabled: widget.enabled,
                              minLines: 1,
                              maxLines: 6,
                              maxLength: widget.maxLength,
                              textInputAction: TextInputAction.send,
                              keyboardType: TextInputType.multiline,
                              textCapitalization: TextCapitalization.sentences,
                              onSubmitted: (_) {
                                if (_canSend) widget.onSend();
                              },
                              buildCounter:
                                  (
                                    context, {
                                    required currentLength,
                                    required isFocused,
                                    maxLength,
                                  }) => null,
                              decoration: InputDecoration(
                                hintText: widget.hintText ?? l10n.chatInputHint,
                                counterText: '',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.spaceMd,
                                  vertical: AppConstants.spaceMd,
                                ),
                              ),
                              style: context.texts.bodyLarge,
                            ),
                          ),
                          const SizedBox(width: AppConstants.spaceSm),
                          if (widget.isGenerating)
                            Tooltip(
                              message: l10n.chatStop,
                              child: IconButton.filledTonal(
                                onPressed: widget.onStop,
                                icon: const Icon(Icons.stop_rounded),
                                tooltip: l10n.chatStop,
                                style: IconButton.styleFrom(
                                  minimumSize: const Size(
                                    AppConstants.minTapTarget,
                                    AppConstants.minTapTarget,
                                  ),
                                ),
                              ),
                            )
                          else
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: widget.controller,
                              builder: (context, value, _) {
                                final canSend = _canSend;
                                return Tooltip(
                                  message: l10n.chatSend,
                                  child: IconButton.filled(
                                    onPressed: canSend ? widget.onSend : null,
                                    icon: const Icon(
                                      Icons.arrow_upward_rounded,
                                    ),
                                    tooltip: l10n.chatSend,
                                    style: IconButton.styleFrom(
                                      minimumSize: const Size(
                                        AppConstants.minTapTarget,
                                        AppConstants.minTapTarget,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
