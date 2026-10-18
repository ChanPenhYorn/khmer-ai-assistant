/// Values shared across features that are not user-facing text.
class AppConstants {
  const AppConstants._();

  /// Spacing scale (logical pixels). Khmer glyphs carry tall ascenders and
  /// descenders, so spacing here is deliberately generous.
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;
  static const double spaceXxl = 48;

  /// Corner radii.
  static const double radiusSm = 10;
  static const double radiusMd = 16;
  static const double radiusLg = 24;
  static const double radiusXl = 28;

  /// Minimum tap target, aligned with Material accessibility guidance.
  static const double minTapTarget = 48;

  /// Motion durations kept short so interactions feel responsive without
  /// becoming decorative.
  static const Duration motionFast = Duration(milliseconds: 120);
  static const Duration motionNormal = Duration(milliseconds: 200);
  static const Duration motionSlow = Duration(milliseconds: 320);

  /// Line height used for Khmer text. Khmer needs more vertical room than
  /// Latin scripts to avoid clipping joined glyphs.
  static const double khmerLineHeight = 1.7;
  static const double latinLineHeight = 1.4;

  /// Longest conversation title kept before it is shortened.
  static const int maxConversationTitleLength = 48;

  /// Number of characters used to build an automatic conversation title.
  static const int autoTitleLength = 40;

  static const String kmLanguageCode = 'km';
  static const String enLanguageCode = 'en';
}
