import 'dart:async';

import '../../domain/entities/ai_reply.dart';
import '../../domain/entities/ai_language.dart';
import '../../domain/entities/ai_message.dart';
import '../../domain/entities/ai_stream_event.dart';
import '../../domain/entities/ai_task_options.dart';
import '../../domain/repositories/ai_repository.dart';

/// Decorates an [AiRepository] and reports the usage metadata the backend
/// returned, so the UI can show remaining allowance without inventing numbers.
///
/// The callback keeps this class free of any dependency on presentation code.
class UsageRecordingAiRepository implements AiRepository {
  UsageRecordingAiRepository({
    required AiRepository delegate,
    required void Function(AiUsage usage) onUsage,
  }) : _delegate = delegate,
       _onUsage = onUsage;

  final AiRepository _delegate;
  final void Function(AiUsage usage) _onUsage;

  void _record(AiReply reply) {
    if (reply.usage.isEmpty) return;
    _onUsage(reply.usage);
  }

  @override
  Stream<AiStreamEvent> streamMessage({
    required List<AiMessage> conversation,
    required String locale,
  }) => _delegate.streamMessage(conversation: conversation, locale: locale).map(
    (event) {
      if (event is AiStreamCompleted) _record(event.reply);
      return event;
    },
  );

  @override
  Future<AiReply> translate({
    required String text,
    required AiLanguage source,
    required AiLanguage target,
  }) async {
    final reply = await _delegate.translate(
      text: text,
      source: source,
      target: target,
    );
    _record(reply);
    return reply;
  }

  @override
  Future<AiReply> improveWriting({
    required String text,
    required WritingAction action,
    required WritingTone tone,
    required AiLanguage targetLanguage,
  }) async {
    final reply = await _delegate.improveWriting(
      text: text,
      action: action,
      tone: tone,
      targetLanguage: targetLanguage,
    );
    _record(reply);
    return reply;
  }

  @override
  Future<AiReply> summarize({
    required String text,
    required SummaryStyle style,
    required AiLanguage outputLanguage,
  }) async {
    final reply = await _delegate.summarize(
      text: text,
      style: style,
      outputLanguage: outputLanguage,
    );
    _record(reply);
    return reply;
  }

  @override
  Future<AiReply> explainEnglish({
    required String text,
    required AiLanguage explanationLanguage,
  }) async {
    final reply = await _delegate.explainEnglish(
      text: text,
      explanationLanguage: explanationLanguage,
    );
    _record(reply);
    return reply;
  }
}
