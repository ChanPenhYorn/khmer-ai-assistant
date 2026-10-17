import 'package:flutter/foundation.dart';

import 'chat_message.dart';

/// A stored conversation between the user and the assistant.
@immutable
class Conversation {
  const Conversation({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.messages = const <ChatMessage>[],
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    final rawMessages = json['messages'];
    final messages = <ChatMessage>[];
    if (rawMessages is List) {
      for (final entry in rawMessages) {
        if (entry is Map) {
          messages.add(ChatMessage.fromJson(entry.cast<String, dynamic>()));
        }
      }
    }
    return Conversation(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      messages: List.unmodifiable(messages),
    );
  }

  final String id;

  /// User-facing name. Empty until the first message produces an auto title.
  final String title;

  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ChatMessage> messages;

  bool get isEmpty => messages.isEmpty;

  /// Last message content, used as a list preview.
  String get preview => messages.isEmpty ? '' : messages.last.content;

  Conversation copyWith({
    String? title,
    DateTime? updatedAt,
    List<ChatMessage>? messages,
  }) => Conversation(
    id: id,
    title: title ?? this.title,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    messages: messages ?? this.messages,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'messages': messages.map((m) => m.toJson()).toList(growable: false),
  };

  /// Shape used by the history list: no message bodies are loaded.
  ConversationSummary toSummary() => ConversationSummary(
    id: id,
    title: title,
    updatedAt: updatedAt,
    messageCount: messages.length,
    preview: preview,
  );

  static DateTime _parseDate(Object? value) {
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  @override
  String toString() => 'Conversation($id, ${messages.length} messages)';
}

/// Lightweight row used by the conversation history screen.
@immutable
class ConversationSummary {
  const ConversationSummary({
    required this.id,
    required this.title,
    required this.updatedAt,
    required this.messageCount,
    required this.preview,
  });

  final String id;
  final String title;
  final DateTime updatedAt;
  final int messageCount;
  final String preview;

  @override
  bool operator ==(Object other) =>
      other is ConversationSummary &&
      other.id == id &&
      other.title == title &&
      other.updatedAt == updatedAt &&
      other.messageCount == messageCount;

  @override
  int get hashCode => Object.hash(id, title, updatedAt, messageCount);
}
