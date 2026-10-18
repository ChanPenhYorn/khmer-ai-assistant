import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_constants.dart';

/// Text field styled for the app, with Khmer-friendly line heights and
/// non-clipping multiline behaviour.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.label,
    this.helperText,
    this.errorText,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.showCounter = false,
    this.textInputAction = TextInputAction.newline,
    this.keyboardType = TextInputType.multiline,
    this.onSubmitted,
    this.onChanged,
    this.autofocus = false,
    this.readOnly = false,
    this.enabled = true,
    this.inputFormatters,
    this.trailing,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? label;
  final String? helperText;
  final String? errorText;
  final int maxLines;
  final int? minLines;
  final int? maxLength;

  /// Shows a `used / max` counter. Off by default to keep the UI calm.
  final bool showCounter;

  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final bool readOnly;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      readOnly: readOnly,
      enabled: enabled,
      autofocus: autofocus,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      // The app supplies its own counter when needed, so error text never
      // fights with a Material counter.
      buildCounter: showCounter && maxLength != null
          ? null
          : (
              context, {
              required currentLength,
              required isFocused,
              maxLength,
            }) => null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        helperText: helperText,
        helperMaxLines: 3,
        errorText: errorText,
        errorMaxLines: 3,
        counterText: showCounter ? null : '',
        suffixIcon: trailing,
        suffixIconConstraints: const BoxConstraints(
          minHeight: AppConstants.minTapTarget,
          minWidth: AppConstants.minTapTarget,
        ),
      ),
      style: Theme.of(context).textTheme.bodyLarge,
      cursorColor: Theme.of(context).colorScheme.primary,
    );
  }
}
