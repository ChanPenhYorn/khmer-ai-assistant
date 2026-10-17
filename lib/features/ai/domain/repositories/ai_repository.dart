import '../entities/ai_language.dart';
import '../entities/ai_message.dart';
import '../entities/ai_reply.dart';
import '../entities/ai_stream_event.dart';
import '../entities/ai_task_options.dart';

/// The single contract every assistant capability goes through.
///
/// Chat, translation, writing, summarization and English learning all use this
/// interface, so swapping the backend or the AI vendor never touches UI code.
/// Implementations live in the data layer and are responsible for translating
/// vendor payloads into the entities above.
abstract interface class AiRepository {
  /// Streams an assistant reply for a conversation.
  ///
  /// The stream emits [AiStreamDelta] chunks, then exactly one
  /// [AiStreamCompleted] or [AiStreamFailed] event.
  Stream<AiStreamEvent> streamMessage({
    required List<AiMessage> conversation,
    required String locale,
  });

  /// Translates [text] from [source] to [target].
  ///
  /// When [source] is [AiLanguage.auto] the data layer resolves it locally.
  Future<AiReply> translate({
    required String text,
    required AiLanguage source,
    required AiLanguage target,
  });

  /// Rewrites [text] according to a preset [action], [tone] and output language.
  Future<AiReply> improveWriting({
    required String text,
    required WritingAction action,
    required WritingTone tone,
    required AiLanguage targetLanguage,
  });

  /// Produces a summary of [text] in the requested [style].
  Future<AiReply> summarize({
    required String text,
    required SummaryStyle style,
    required AiLanguage outputLanguage,
  });

  /// Explains an English word or phrase in [explanationLanguage].
  Future<AiReply> explainEnglish({
    required String text,
    required AiLanguage explanationLanguage,
  });
}
