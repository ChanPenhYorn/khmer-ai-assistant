import '../entities/conversation.dart';

/// Persistence contract for conversations.
///
/// Today the only implementation stores conversations on the device. The
/// interface is deliberately backend-shaped (async, id-based, no UI concerns)
/// so a cloud-synchronised implementation can be dropped in later without
/// touching presentation code. See `README.md` ("Persistence").
abstract interface class ChatRepository {
  /// Newest first.
  Future<List<ConversationSummary>> listConversations();

  /// Returns `null` when [conversationId] is unknown.
  Future<Conversation?> getConversation(String conversationId);

  /// Creates a new conversation *in memory*. It is stored the first time
  /// [saveConversation] is called, so abandoned empty conversations never
  /// appear in the history list.
  Future<Conversation> createConversation({String? title});

  /// Persists [conversation], replacing any stored conversation with the same id.
  Future<void> saveConversation(Conversation conversation);

  Future<void> renameConversation(String conversationId, String title);

  Future<void> deleteConversation(String conversationId);

  /// Removes every stored conversation.
  Future<void> clearAll();
}
