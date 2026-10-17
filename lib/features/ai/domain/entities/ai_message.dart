import 'package:flutter/foundation.dart';

/// Role of a message in a conversation sent to the assistant.
enum AiRole {
  user,
  assistant,
  system;

  String get wireValue => name;
}

/// A single turn of context sent to the AI backend.
@immutable
class AiMessage {
  const AiMessage({required this.role, required this.content});

  const AiMessage.user(String content) : this(role: AiRole.user, content: content);

  const AiMessage.assistant(String content)
    : this(role: AiRole.assistant, content: content);

  final AiRole role;
  final String content;

  Map<String, dynamic> toJson() => {'role': role.wireValue, 'content': content};

  @override
  bool operator ==(Object other) =>
      other is AiMessage && other.role == role && other.content == content;

  @override
  int get hashCode => Object.hash(role, content);

  @override
  String toString() => 'AiMessage(${role.name}, ${content.length} chars)';
}
