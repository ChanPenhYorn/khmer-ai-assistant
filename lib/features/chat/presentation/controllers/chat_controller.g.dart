// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives one conversation: loading it, sending turns, streaming the answer,
/// stopping generation, retrying and renaming.
///
/// Called with [newConversationId] to start a fresh conversation.

@ProviderFor(ChatController)
final chatControllerProvider = ChatControllerFamily._();

/// Drives one conversation: loading it, sending turns, streaming the answer,
/// stopping generation, retrying and renaming.
///
/// Called with [newConversationId] to start a fresh conversation.
final class ChatControllerProvider
    extends $AsyncNotifierProvider<ChatController, ChatState> {
  /// Drives one conversation: loading it, sending turns, streaming the answer,
  /// stopping generation, retrying and renaming.
  ///
  /// Called with [newConversationId] to start a fresh conversation.
  ChatControllerProvider._({
    required ChatControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatControllerHash();

  @override
  String toString() {
    return r'chatControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatController create() => ChatController();

  @override
  bool operator ==(Object other) {
    return other is ChatControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatControllerHash() => r'7665060cb408694875785f416442fb911bfd6529';

/// Drives one conversation: loading it, sending turns, streaming the answer,
/// stopping generation, retrying and renaming.
///
/// Called with [newConversationId] to start a fresh conversation.

final class ChatControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatController,
          AsyncValue<ChatState>,
          ChatState,
          FutureOr<ChatState>,
          String
        > {
  ChatControllerFamily._()
    : super(
        retry: null,
        name: r'chatControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Drives one conversation: loading it, sending turns, streaming the answer,
  /// stopping generation, retrying and renaming.
  ///
  /// Called with [newConversationId] to start a fresh conversation.

  ChatControllerProvider call(String conversationId) =>
      ChatControllerProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'chatControllerProvider';
}

/// Drives one conversation: loading it, sending turns, streaming the answer,
/// stopping generation, retrying and renaming.
///
/// Called with [newConversationId] to start a fresh conversation.

abstract class _$ChatController extends $AsyncNotifier<ChatState> {
  late final _$args = ref.$arg as String;
  String get conversationId => _$args;

  FutureOr<ChatState> build(String conversationId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ChatState>, ChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ChatState>, ChatState>,
              AsyncValue<ChatState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
