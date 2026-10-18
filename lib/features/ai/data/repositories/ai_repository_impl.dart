import 'dart:async';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/dio_failure_mapper.dart';
import '../../domain/entities/ai_language.dart';
import '../../domain/entities/ai_message.dart';
import '../../domain/entities/ai_reply.dart';
import '../../domain/entities/ai_stream_event.dart';
import '../../domain/entities/ai_task.dart';
import '../../domain/entities/ai_task_options.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/ai_data_source.dart';
import '../dto/ai_request_dto.dart';

/// Implements [AiRepository] on top of an [AiDataSource].
///
/// Responsibilities:
/// * map domain calls to the wire contract,
/// * resolve [AiLanguage.auto] locally (no extra round trip),
/// * convert transport errors into [AppFailure],
/// * retry only failures that are safe to retry.
class AiRepositoryImpl implements AiRepository {
  AiRepositoryImpl({
    required AiDataSource dataSource,
    this.maxRetries = 1,
    this.retryBackoff = const Duration(milliseconds: 400),
  }) : _dataSource = dataSource;

  final AiDataSource _dataSource;

  /// Extra attempts for failures that occurred before the request reached the
  /// server. Applied to non-streaming calls only.
  final int maxRetries;
  final Duration retryBackoff;

  @override
  Stream<AiStreamEvent> streamMessage({
    required List<AiMessage> conversation,
    required String locale,
  }) {
    final request = AiRequestDto(
      task: AiTask.chat,
      locale: locale,
      messages: conversation,
    );
    // No automatic retry: a streamed generation may already have started.
    return _dataSource.stream(request);
  }

  @override
  Future<AiReply> translate({
    required String text,
    required AiLanguage source,
    required AiLanguage target,
  }) {
    final resolvedSource = source.resolveFrom(text);
    return _sendWithRetry(
      AiRequestDto(
        task: AiTask.translate,
        locale: target.code,
        input: text.trim(),
        params: {'source': resolvedSource.code, 'target': target.code},
      ),
    );
  }

  @override
  Future<AiReply> improveWriting({
    required String text,
    required WritingAction action,
    required WritingTone tone,
    required AiLanguage targetLanguage,
  }) => _sendWithRetry(
    AiRequestDto(
      task: AiTask.improveWriting,
      locale: targetLanguage.code,
      input: text.trim(),
      params: {
        'action': action.wireValue,
        'tone': tone.wireValue,
        'target_language': targetLanguage.code,
      },
    ),
  );

  @override
  Future<AiReply> summarize({
    required String text,
    required SummaryStyle style,
    required AiLanguage outputLanguage,
  }) => _sendWithRetry(
    AiRequestDto(
      task: AiTask.summarize,
      locale: outputLanguage.code,
      input: text.trim(),
      params: {
        'style': style.wireValue,
        'target_language': outputLanguage.code,
      },
    ),
  );

  @override
  Future<AiReply> explainEnglish({
    required String text,
    required AiLanguage explanationLanguage,
  }) => _sendWithRetry(
    AiRequestDto(
      task: AiTask.explainEnglish,
      locale: explanationLanguage.code,
      input: text.trim(),
      params: {'target_language': explanationLanguage.code},
    ),
  );

  Future<AiReply> _sendWithRetry(AiRequestDto request) async {
    var attempt = 0;
    while (true) {
      try {
        return await _dataSource.complete(request);
      } on AppFailure catch (failure) {
        logFailureInDebug(failure);
        final canRetry = failure.isSafeToRetry && attempt < maxRetries;
        if (!canRetry) rethrow;
        attempt++;
        await Future<void>.delayed(retryBackoff * attempt);
      }
    }
  }
}
