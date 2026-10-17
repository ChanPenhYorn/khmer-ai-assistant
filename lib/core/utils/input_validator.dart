import '../errors/app_failure.dart';

/// Local input validation performed before any network request.
///
/// Returns a typed [AppFailure] describing the problem, or `null` when the
/// input is acceptable. Keeping this pure makes it directly unit-testable.
abstract final class InputValidator {
  static AppFailure? validate({
    required String text,
    required int maxCharacters,
    bool requireNonEmpty = true,
  }) {
    final trimmed = text.trim();
    if (requireNonEmpty && trimmed.isEmpty) {
      return const InvalidInputFailure(technicalMessage: 'empty input');
    }
    if (trimmed.length > maxCharacters) {
      return InputTooLargeFailure(
        technicalMessage: 'input length ${trimmed.length} > $maxCharacters',
      );
    }
    return null;
  }
}
