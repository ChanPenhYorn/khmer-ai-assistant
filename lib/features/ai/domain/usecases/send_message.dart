import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/input_validator.dart';
import '../entities/ai_message.dart';
import '../entities/ai_stream_event.dart';
import '../repositories/ai_repository.dart';

/// Validates a chat turn and streams the assistant reply.
///
/// Validation failures are reported as [AiStreamFailed] so the caller can
/// handle every outcome through the same channel.
class SendMessage {
  const SendMessage({
    required AiRepository repository,
    required int maxInputCharacters,
  }) : _repository = repository,
       _maxInputCharacters = maxInputCharacters;

  final AiRepository _repository;
  final int _maxInputCharacters;

  Stream<AiStreamEvent> call({
    required List<AiMessage> conversation,
    required String locale,
  }) {
    if (conversation.isEmpty) {
      return Stream.value(
        const AiStreamFailed(InvalidInputFailure(technicalMessage: 'no messages')),
      );
    }

    final lastUserMessage = conversation.lastWhere(
      (m) => m.role == AiRole.user,
      orElse: () => conversation.last,
    );
    final validation = InputValidator.validate(
      text: lastUserMessage.content,
      maxCharacters: _maxInputCharacters,
    );
    if (validation != null) {
      return Stream.value(AiStreamFailed(validation));
    }

    final totalCharacters = conversation.fold<int>(
      0,
      (sum, message) => sum + message.content.length,
    );
    if (totalCharacters > _maxInputCharacters * 4) {
      return Stream.value(
        const AiStreamFailed(
          InputTooLargeFailure(technicalMessage: 'conversation too long'),
        ),
      );
    }

    return _repository.streamMessage(conversation: conversation, locale: locale);
  }
}
