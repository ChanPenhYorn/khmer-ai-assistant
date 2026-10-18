import 'dart:async';

import 'package:khmer_ai_assistant/features/ai/data/datasources/ai_data_source.dart';
import 'package:khmer_ai_assistant/features/ai/data/dto/ai_request_dto.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_reply.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_stream_event.dart';
import 'package:khmer_ai_assistant/core/errors/app_failure.dart';

/// Test double for [AiDataSource].
///
/// Tests drive it explicitly, so no test ever reaches a real provider and no
/// paid credits are consumed.
class FakeAiDataSource implements AiDataSource {
  FakeAiDataSource({
    this.replyText = 'sample reply',
    this.model = 'test-model',
    this.detectedLanguage,
    this.usage = AiUsage.empty,
    List<String>? streamChunks,
    this.streamFailure,
    this.completeFailure,
    this.streamDelay = Duration.zero,
    this.hang = false,
  }) : streamChunks = streamChunks ?? [replyText];

  final String replyText;
  final String? model;
  final String? detectedLanguage;
  final AiUsage usage;

  /// Chunks emitted before the completion event.
  final List<String> streamChunks;

  /// When set, the stream ends with [AiStreamFailed].
  final AppFailure? streamFailure;

  /// When set, [complete] throws it.
  final AppFailure? completeFailure;

  final Duration streamDelay;

  /// When true the stream never completes, which lets a test exercise
  /// cancellation.
  final bool hang;

  /// Every request received, in order.
  final List<AiRequestDto> requests = <AiRequestDto>[];

  int completeCalls = 0;
  int streamCalls = 0;

  /// Completes only when the test allows it, for `hang` scenarios.
  final Completer<void> _release = Completer<void>();

  void release() {
    if (!_release.isCompleted) _release.complete();
  }

  @override
  Future<AiReply> complete(AiRequestDto request) async {
    completeCalls++;
    requests.add(request);
    final failure = completeFailure;
    if (failure != null) throw failure;
    return AiReply(
      text: replyText,
      model: model,
      usage: usage,
      detectedLanguage: detectedLanguage,
    );
  }

  @override
  Stream<AiStreamEvent> stream(AiRequestDto request) async* {
    streamCalls++;
    requests.add(request);

    for (final chunk in streamChunks) {
      if (streamDelay > Duration.zero) {
        await Future<void>.delayed(streamDelay);
      } else {
        await Future<void>.delayed(Duration.zero);
      }
      yield AiStreamDelta(chunk);
    }

    if (hang) await _release.future;

    final failure = streamFailure;
    if (failure != null) {
      yield AiStreamFailed(failure);
      return;
    }
    yield AiStreamCompleted(
      AiReply(
        text: streamChunks.join(),
        model: model,
        usage: usage,
        detectedLanguage: detectedLanguage,
      ),
    );
  }
}
