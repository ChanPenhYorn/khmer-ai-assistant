import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/context_extensions.dart';
import '../../features/ai/domain/entities/ai_language.dart';

/// Dropdown for choosing one of the supported languages.
///
/// The labels come from the localization files, and the control grows with
/// text scaling instead of clipping long Khmer labels.
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.includeAuto = false,
    this.label,
    this.autoLabel,
    this.semanticLabel,
  });

  final AiLanguage value;
  final ValueChanged<AiLanguage> onChanged;
  final bool includeAuto;
  final String? label;
  final String? autoLabel;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final options = <AiLanguage>[
      if (includeAuto) AiLanguage.auto,
      AiLanguage.khmer,
      AiLanguage.english,
    ];

    return Semantics(
      label: semanticLabel ?? label,
      child: DropdownButtonFormField<AiLanguage>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: [
          for (final option in options)
            DropdownMenuItem(
              value: option,
              child: Text(
                languageLabel(context, option, autoLabel: autoLabel),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
        onChanged: (selected) {
          if (selected != null) onChanged(selected);
        },
      ),
    );
  }

  /// Localized name of [language].
  static String languageLabel(
    BuildContext context,
    AiLanguage language, {
    String? autoLabel,
  }) => switch (language) {
    AiLanguage.khmer => context.l10n.languageKhmer,
    AiLanguage.english => context.l10n.languageEnglish,
    AiLanguage.auto => autoLabel ?? context.l10n.translateAutoDetect,
  };
}

/// Row of selectable chips, used for tones and summary styles.
class OptionChips<T> extends StatelessWidget {
  const OptionChips({
    super.key,
    required this.options,
    required this.labelOf,
    required this.selected,
    required this.onSelected,
    this.title,
  });

  final List<T> options;
  final String Function(BuildContext context, T option) labelOf;
  final T selected;
  final ValueChanged<T> onSelected;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title, style: context.texts.labelMedium),
          const SizedBox(height: AppConstants.spaceSm),
        ],
        Wrap(
          spacing: AppConstants.spaceSm,
          runSpacing: AppConstants.spaceSm,
          children: [
            for (final option in options)
              ChoiceChip(
                label: Text(labelOf(context, option)),
                selected: option == selected,
                onSelected: (_) => onSelected(option),
              ),
          ],
        ),
      ],
    );
  }
}
