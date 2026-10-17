import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../core/utils/text_utils.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_data_source.dart';

/// Device-local implementation of [ChatRepository].
///
/// Limitations are documented in `README.md`: conversations are not synced to
/// any server, and clearing app data removes them permanently.
class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required ChatLocalDataSource localDataSource,
    DateTime Function()? clock,
  }) : _local = localDataSource,
       _clock = clock ?? DateTime.now;

  /// Messages kept per conversation. Older messages are dropped so a single
  /// conversation cannot grow without bound.
  static const int maxMessagesPerConversation = 200;

  final ChatLocalDataSource _local;
  final DateTime Function() _clock;

  @override
  Future<List<ConversationSummary>> listConversations() async {
    final stored = await _readConversations();
    final summaries = stored.map((c) => c.toSummary()).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return List.unmodifiable(summaries);
  }

  @override
  Future<Conversation?> getConversation(String conversationId) async {
    if (conversationId.isEmpty) return null;
    final stored = await _readConversations();
    for (final conversation in stored) {
      if (conversation.id == conversationId) return conversation;
    }
    return null;
  }

  @override
  Future<Conversation> createConversation({String? title}) async {
    final now = _clock();
    return Conversation(
      id: IdGenerator.nextId('c_'),
      title: _clampTitle((title ?? '').trim()),
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<void> saveConversation(Conversation conversation) async {
    final stored = await _readConversations();
    final bounded = conversation.messages.length > maxMessagesPerConversation
        ? conversation.copyWith(
            messages: conversation.messages.sublist(
              conversation.messages.length - maxMessagesPerConversation,
            ),
          )
        : conversation;

    final index = stored.indexWhere((c) => c.id == bounded.id);
    final withTitle = _normalizeTitle(
      bounded.title,
      fallback: _autoTitle(bounded),
      existing: bounded,
    );
    if (index == -1) {
      stored.insert(0, withTitle);
    } else {
      stored[index] = withTitle;
    }
    await _writeConversations(stored);
  }

  @override
  Future<void> renameConversation(String conversationId, String title) async {
    final stored = await _readConversations();
    final index = stored.indexWhere((c) => c.id == conversationId);
    if (index == -1) return;
    stored[index] = stored[index].copyWith(
      title: _normalizeTitle(title, fallback: ''),
      updatedAt: _clock(),
    );
    await _writeConversations(stored);
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    final stored = await _readConversations();
    stored.removeWhere((c) => c.id == conversationId);
    await _writeConversations(stored);
  }

  @override
  Future<void> clearAll() async {
    await _local.writeAll(const <Map<String, dynamic>>[]);
  }

  Future<List<Conversation>> _readConversations() async {
    final raw = await _local.readAll();
    final conversations = <Conversation>[];
    for (final entry in raw) {
      final conversation = Conversation.fromJson(entry);
      if (conversation.id.isEmpty) continue;
      conversations.add(
        conversation.copyWith(
          messages: conversation.messages
              .where((m) => !m.isEmpty)
              .toList(growable: false),
        ),
      );
    }
    conversations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return conversations;
  }

  Future<void> _writeConversations(List<Conversation> conversations) async {
    await _local.writeAll(
      conversations.map((c) => c.toJson()).toList(growable: false),
    );
  }

  /// Keeps a user-provided title, otherwise derives one from the first user
  /// message. An empty result means the conversation is still untitled.
  String _normalizeTitle(
    String? title, {
    required String fallback,
    Conversation? existing,
  }) {
    final candidate = (title ?? '').trim();
    if (candidate.isNotEmpty) {
      return _clampTitle(candidate);
    }
    if (existing != null) {
      final auto = _autoTitle(existing);
      if (auto.isNotEmpty) return auto;
      if (existing.title.isNotEmpty) return existing.title;
    }
    return _clampTitle(fallback);
  }

  String _autoTitle(Conversation conversation) {
    for (final message in conversation.messages) {
      if (!message.isUser) continue;
      final title = TextUtils.titleFromMessage(
        message.content,
        maxLength: AppConstants.autoTitleLength,
      );
      if (title.isNotEmpty) return title;
    }
    return '';
  }

  String _clampTitle(String title) {
    if (title.length <= AppConstants.maxConversationTitleLength) return title;
    return title.substring(0, AppConstants.maxConversationTitleLength);
  }
}
