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

  /// Width breakpoints.
  ///
  /// Below [breakpointMedium] the app is compact: bottom navigation, single
  /// column. At or above it there is room for a navigation rail and for
  /// side-by-side panes, so both the shell and the tool screens switch layout.
  static const double breakpointMedium = 840;

  /// Width at which the navigation rail shows its labels.
  static const double breakpointExpanded = 1200;

  /// Maximum measure for a readable single column of text.
  static const double contentMaxWidth = 720;

  /// Maximum width of the conversation column on wide screens. Wider than
  /// [contentMaxWidth] because assistant answers carry code blocks and tables.
  static const double chatMaxWidth = 880;

  /// Maximum width of the two-pane tool layout.
  static const double toolMaxWidth = 1160;

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
