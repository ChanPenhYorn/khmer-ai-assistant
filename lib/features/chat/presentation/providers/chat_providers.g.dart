// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatLocalDataSource)
final chatLocalDataSourceProvider = ChatLocalDataSourceProvider._();

final class ChatLocalDataSourceProvider
    extends
        $FunctionalProvider<
          ChatLocalDataSource,
          ChatLocalDataSource,
          ChatLocalDataSource
        >
    with $Provider<ChatLocalDataSource> {
  ChatLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ChatLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatLocalDataSource create(Ref ref) {
    return chatLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatLocalDataSource>(value),
    );
  }
}

String _$chatLocalDataSourceHash() =>
    r'c8166e78ab14b45672980a2da77f49573b9262c3';

@ProviderFor(chatRepository)
final chatRepositoryProvider = ChatRepositoryProvider._();

final class ChatRepositoryProvider
    extends $FunctionalProvider<ChatRepository, ChatRepository, ChatRepository>
    with $Provider<ChatRepository> {
  ChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepository create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepository>(value),
    );
  }
}

String _$chatRepositoryHash() => r'2775b9e6e360ed698eaa51ca83c2da7e706257c9';

@ProviderFor(sendChatMessage)
final sendChatMessageProvider = SendChatMessageProvider._();

final class SendChatMessageProvider
    extends
        $FunctionalProvider<SendChatMessage, SendChatMessage, SendChatMessage>
    with $Provider<SendChatMessage> {
  SendChatMessageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendChatMessageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendChatMessageHash();

  @$internal
  @override
  $ProviderElement<SendChatMessage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SendChatMessage create(Ref ref) {
    return sendChatMessage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SendChatMessage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SendChatMessage>(value),
    );
  }
}

String _$sendChatMessageHash() => r'0c2118e32a51dd0688ea306bf1bcd94a1e1cd55f';

@ProviderFor(regenerateResponse)
final regenerateResponseProvider = RegenerateResponseProvider._();

final class RegenerateResponseProvider
    extends
        $FunctionalProvider<
          RegenerateResponse,
          RegenerateResponse,
          RegenerateResponse
        >
    with $Provider<RegenerateResponse> {
  RegenerateResponseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'regenerateResponseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$regenerateResponseHash();

  @$internal
  @override
  $ProviderElement<RegenerateResponse> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RegenerateResponse create(Ref ref) {
    return regenerateResponse(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegenerateResponse value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegenerateResponse>(value),
    );
  }
}

String _$regenerateResponseHash() =>
    r'99ba5e9fa02a0879f14fbebbe3b8781804a14d76';

/// Conversation history, newest first. Refreshed by invalidating after any
/// write operation.

@ProviderFor(conversationList)
final conversationListProvider = ConversationListProvider._();

/// Conversation history, newest first. Refreshed by invalidating after any
/// write operation.

final class ConversationListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ConversationSummary>>,
          List<ConversationSummary>,
          FutureOr<List<ConversationSummary>>
        >
    with
        $FutureModifier<List<ConversationSummary>>,
        $FutureProvider<List<ConversationSummary>> {
  /// Conversation history, newest first. Refreshed by invalidating after any
  /// write operation.
  ConversationListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationListHash();

  @$internal
  @override
  $FutureProviderElement<List<ConversationSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ConversationSummary>> create(Ref ref) {
    return conversationList(ref);
  }
}

String _$conversationListHash() => r'd0454bb55bac710a115ed719017447fef8dcf7c8';

/// One-shot handoff of a prompt typed on the home screen to the chat screen.
///
/// Keeping it in a provider avoids stuffing prompts into the URL and keeps the
/// chat controller free of navigation concerns.

@ProviderFor(PendingPrompt)
final pendingPromptProvider = PendingPromptProvider._();

/// One-shot handoff of a prompt typed on the home screen to the chat screen.
///
/// Keeping it in a provider avoids stuffing prompts into the URL and keeps the
/// chat controller free of navigation concerns.
final class PendingPromptProvider
    extends $NotifierProvider<PendingPrompt, String?> {
  /// One-shot handoff of a prompt typed on the home screen to the chat screen.
  ///
  /// Keeping it in a provider avoids stuffing prompts into the URL and keeps the
  /// chat controller free of navigation concerns.
  PendingPromptProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingPromptProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingPromptHash();

  @$internal
  @override
  PendingPrompt create() => PendingPrompt();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$pendingPromptHash() => r'a9f231480e8bea262beecb9b82d1d5a6374d45c8';

/// One-shot handoff of a prompt typed on the home screen to the chat screen.
///
/// Keeping it in a provider avoids stuffing prompts into the URL and keeps the
/// chat controller free of navigation concerns.

abstract class _$PendingPrompt extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
