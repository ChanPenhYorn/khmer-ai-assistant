import '../../../../core/constants/app_constants.dart';

/// Languages supported by the assistant.
enum AiLanguage {
  khmer,
  english,

  /// Source-language sentinel resolved locally before the request is sent.
  auto;

  /// BCP-47 language code sent to the backend.
  String get code => switch (this) {
    AiLanguage.khmer => AppConstants.kmLanguageCode,
    AiLanguage.english => AppConstants.enLanguageCode,
    AiLanguage.auto => 'auto',
  };

  /// Language this enum value resolves to when it is detected locally.
  AiLanguage resolveFrom(String text) => switch (this) {
    AiLanguage.auto =>
      containsKhmer(text) ? AiLanguage.khmer : AiLanguage.english,
    _ => this,
  };

  AiLanguage get opposite => switch (this) {
    AiLanguage.khmer => AiLanguage.english,
    AiLanguage.english => AiLanguage.khmer,
    AiLanguage.auto => AiLanguage.khmer,
  };

  static bool containsKhmer(String text) {
    for (final rune in text.runes) {
      if ((rune >= 0x1780 && rune <= 0x17FF) ||
          (rune >= 0x19E0 && rune <= 0x19FF)) {
        return true;
      }
    }
    return false;
  }

  static AiLanguage fromCode(String? code) => switch (code) {
    'km' => AiLanguage.khmer,
    'en' => AiLanguage.english,
    'auto' => AiLanguage.auto,
    _ => AiLanguage.auto,
  };
}
