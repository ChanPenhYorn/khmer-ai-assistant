import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/storage/preferences_providers.dart';
import '../../../ai/presentation/providers/ai_providers.dart';
import '../../data/datasources/chat_local_data_source.dart';
import '../../data/datasources/shared_preferences_chat_local_data_source.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/regenerate_response.dart';
import '../../domain/usecases/send_chat_message.dart';

part 'chat_providers.g.dart';

/// Route parameter used to request a brand new conversation.
const String newConversationId = 'new';

@Riverpod(keepAlive: true)
ChatLocalDataSource chatLocalDataSource(Ref ref) =>
    SharedPreferencesChatLocalDataSource(ref.watch(sharedPreferencesProvider));

@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) =>
    ChatRepositoryImpl(localDataSource: ref.watch(chatLocalDataSourceProvider));

@Riverpod(keepAlive: true)
SendChatMessage sendChatMessage(Ref ref) =>
    SendChatMessage(sendMessage: ref.watch(sendMessageProvider));

@Riverpod(keepAlive: true)
RegenerateResponse regenerateResponse(Ref ref) =>
    RegenerateResponse(sendChatMessage: ref.watch(sendChatMessageProvider));

/// Conversation history, newest first. Refreshed by invalidating after any
/// write operation.
@riverpod
Future<List<ConversationSummary>> conversationList(Ref ref) =>
    ref.watch(chatRepositoryProvider).listConversations();

/// One-shot handoff of a prompt typed on the home screen to the chat screen.
///
/// Keeping it in a provider avoids stuffing prompts into the URL and keeps the
/// chat controller free of navigation concerns.
@Riverpod(keepAlive: true)
class PendingPrompt extends _$PendingPrompt {
  @override
  String? build() => null;

  void set(String prompt) => state = prompt;

  /// Returns the pending prompt and clears it, so it is sent exactly once.
  String? take() {
    final prompt = state;
    state = null;
    return prompt;
  }
}
