import 'package:flutter/foundation.dart';

import '../../../ai/domain/entities/ai_message.dart';

/// Who wrote a chat message.
enum ChatAuthor {
  user,
  assistant;

  AiRole get aiRole => switch (this) {
    ChatAuthor.user => AiRole.user,
    ChatAuthor.assistant => AiRole.assistant,
  };
}

/// Delivery state of a message inside the current session.
///
/// Only [complete] messages are persisted; streaming or failed messages are
/// resolved (or dropped) before the conversation is written to storage.
enum ChatMessageStatus { complete, streaming, failed }

/// One message in a conversation.
@immutable
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
    this.status = ChatMessageStatus.complete,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final author = json['author'] == 'user' ? ChatAuthor.user : ChatAuthor.assistant;
    return ChatMessage(
      id: json['id'] as String? ?? '',
      author: author,
      content: json['content'] as String? ?? '',
      createdAt: _parseDate(json['created_at']),
      status: ChatMessageStatus.complete,
    );
  }

  final String id;
  final ChatAuthor author;
  final String content;
  final DateTime createdAt;
  final ChatMessageStatus status;

  bool get isUser => author == ChatAuthor.user;

  bool get isStreaming => status == ChatMessageStatus.streaming;

  bool get isFailed => status == ChatMessageStatus.failed;

  bool get isEmpty => content.trim().isEmpty;

  ChatMessage copyWith({
    String? content,
    ChatMessageStatus? status,
  }) => ChatMessage(
    id: id,
    author: author,
    content: content ?? this.content,
    createdAt: createdAt,
    status: status ?? this.status,
  );

  /// Wire format for local persistence. [status] is intentionally not stored:
  /// a reloaded conversation only contains finished messages.
  Map<String, dynamic> toJson() => {
    'id': id,
    'author': author.name,
    'content': content,
    'created_at': createdAt.toIso8601String(),
  };

  AiMessage toAiMessage() => AiMessage(role: author.aiRole, content: content);

  static DateTime _parseDate(Object? value) {
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  @override
  bool operator ==(Object other) =>
      other is ChatMessage &&
      other.id == id &&
      other.content == content &&
      other.status == status;

  @override
  int get hashCode => Object.hash(id, content, status);

  @override
  String toString() =>
      'ChatMessage(${author.name}, ${content.length} chars, ${status.name})';
}
