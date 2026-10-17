/// Route paths used by `go_router`.
///
/// Kept in one place so screens never hardcode strings and tests can reference
/// them by name.
abstract final class AppRoutes {
  static const String home = '/';
  static const String chat = '/chat';
  static const String history = '/history';
  static const String settings = '/settings';

  static const String translate = '/translate';
  static const String writing = '/writing';
  static const String summarize = '/summarize';
  static const String english = '/english';

  /// Chat for a specific conversation. [conversationId] may be
  /// `newConversationId` to start a fresh one.
  static String chatFor(String conversationId) => '$chat/$conversationId';
}
