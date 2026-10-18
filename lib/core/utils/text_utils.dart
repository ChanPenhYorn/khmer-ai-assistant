/// Small pure helpers for text handling. Kept free of Flutter imports so they
/// can be unit-tested without a test binding.
abstract final class TextUtils {
  /// First Unicode range of the Khmer block.
  static const int khmerBlockStart = 0x1780;
  static const int khmerBlockEnd = 0x17FF;
  static const int khmerSymbolsStart = 0x19E0;
  static const int khmerSymbolsEnd = 0x19FF;

  /// `true` when [text] contains at least one Khmer character.
  static bool containsKhmer(String text) {
    for (final rune in text.runes) {
      final isKhmer =
          (rune >= khmerBlockStart && rune <= khmerBlockEnd) ||
          (rune >= khmerSymbolsStart && rune <= khmerSymbolsEnd);
      if (isKhmer) return true;
    }
    return false;
  }

  /// Best-effort source-language detection for the two languages the app
  /// supports. Khmer script is unambiguous, so this is reliable for the
  /// Khmer-vs-English decision and needs no network round trip.
  static String detectLanguageCode(String text) =>
      containsKhmer(text) ? 'km' : 'en';

  /// Collapses whitespace and trims, which is what the backend expects.
  static String normalize(String text) =>
      text.trim().replaceAll(RegExp(r'[ \t]+'), ' ');

  /// Builds a short conversation title from the first user message.
  static String titleFromMessage(String message, {int maxLength = 40}) {
    final normalized = message.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (normalized.isEmpty) return '';
    if (normalized.length <= maxLength) return normalized;
    // Avoid cutting a Khmer cluster in half more often than necessary; a word
    // boundary is preferred, a hard cut is the fallback.
    final slice = normalized.substring(0, maxLength);
    final lastSpace = slice.lastIndexOf(' ');
    final cut = lastSpace >= maxLength ~/ 2
        ? slice.substring(0, lastSpace)
        : slice;
    return '$cut…';
  }

  /// Character count used by counters and validation messages.
  static int characterCount(String text) => text.trim().length;
}
