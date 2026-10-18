import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/config/ai_config.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/dio_failure_mapper.dart';
import '../../domain/entities/ai_reply.dart';
import '../../domain/entities/ai_stream_event.dart';
import '../dto/ai_request_dto.dart';
import '../dto/ai_response_dto.dart';
import 'ai_data_source.dart';
import 'sse_parser.dart';

/// Talks to the operator's AI proxy over HTTPS.
///
/// Two response modes are supported:
/// * a single JSON envelope for plain request/response, and
/// * Server-Sent Events (`data: {...}` lines, terminated by `data: [DONE]`)
///   when streaming is enabled and the backend supports it.
///
/// The client never addresses an AI vendor directly, so no vendor API key is
/// present in the binary.
class RemoteAiDataSource implements AiDataSource {
  RemoteAiDataSource({required Dio dio, required AiConfig config})
    : _dio = dio,
      _config = config;

  final Dio _dio;
  final AiConfig _config;

  @override
  Future<AiReply> complete(AiRequestDto request) async {
    final uri = _requireUri();
    try {
      final response = await _dio.postUri<Object?>(
        uri,
        data: request.toJson(),
        options: Options(
          headers: const {'Accept': 'application/json'},
          contentType: Headers.jsonContentType,
        ),
      );
      return AiResponseDto.parse(response.data);
    } on DioException catch (error) {
      throw mapDioException(error);
    } on AppFailure {
      rethrow;
    } catch (error) {
      throw InvalidResponseFailure(
        technicalMessage: error.toString(),
        cause: error,
      );
    }
  }

  @override
  Stream<AiStreamEvent> stream(AiRequestDto request) {
    if (!_config.streamingEnabled) {
      return _singleShot(request);
    }
    return _sseStream(request);
  }

  /// Emits the full reply as one delta. Used when streaming is disabled so the
  /// UI has a single code path.
  Stream<AiStreamEvent> _singleShot(AiRequestDto request) async* {
    try {
      final reply = await complete(request);
      yield AiStreamDelta(reply.text);
      yield AiStreamCompleted(reply);
    } on AppFailure catch (failure) {
      yield AiStreamFailed(failure);
    }
  }

  Stream<AiStreamEvent> _sseStream(AiRequestDto request) {
    final controller = StreamController<AiStreamEvent>();
    final cancelToken = CancelToken();

    // Propagate cancellation to the socket so stopping generation does not
    // leave a request running (and billing) in the background.
    controller.onCancel = () {
      if (!cancelToken.isCancelled) {
        cancelToken.cancel('client stopped generation');
      }
    };

    unawaited(_pumpSse(request, controller, cancelToken));
    return controller.stream;
  }

  Future<void> _pumpSse(
    AiRequestDto request,
    StreamController<AiStreamEvent> controller,
    CancelToken cancelToken,
  ) async {
    final partial = StringBuffer();
    var completed = false;
    final parser = AiSseParser();

    try {
      final response = await _dio.postUri<ResponseBody>(
        _requireUri(),
        data: request.toJson(),
        cancelToken: cancelToken,
        options: Options(
          responseType: ResponseType.stream,
          headers: const {'Accept': 'text/event-stream'},
          contentType: Headers.jsonContentType,
        ),
      );

      final body = response.data;
      if (body == null) {
        throw const InvalidResponseFailure(
          technicalMessage: 'empty streaming response',
        );
      }

      await for (final line
          in body.stream
              .cast<List<int>>()
              .transform(const Utf8Decoder(allowMalformed: true))
              .transform(const LineSplitter())) {
        if (controller.isClosed) return;
        final payload = parser.readDataLine(line);
        if (payload == null) continue;
        if (payload == '[DONE]') {
          completed = true;
          break;
        }

        final event = parser.parsePayload(payload);
        if (event == null) continue;

        if (event is AiStreamDelta) {
          partial.write(event.text);
          controller.add(event);
        } else if (event is AiStreamCompleted) {
          completed = true;
          partial
            ..clear()
            ..write(event.reply.text);
          controller.add(AiStreamCompleted(event.reply));
          break;
        } else if (event is AiStreamFailed) {
          completed = true;
          controller.add(event);
          break;
        }
      }

      if (!completed && !controller.isClosed) {
        // The connection ended without a terminator: treat the accumulated
        // text as the reply, or report a malformed stream if there is none.
        final text = partial.toString();
        if (text.trim().isEmpty) {
          controller.add(
            const AiStreamFailed(
              InvalidResponseFailure(technicalMessage: 'stream ended early'),
            ),
          );
        } else {
          controller.add(AiStreamCompleted(AiReply(text: text)));
        }
      }
    } on DioException catch (error) {
      if (controller.isClosed) return;
      final failure = mapDioException(error);
      if (failure.kind == FailureKind.cancelled) return;
      controller.add(AiStreamFailed(failure));
    } on AppFailure catch (failure) {
      if (controller.isClosed) return;
      controller.add(AiStreamFailed(failure));
    } catch (error, stackTrace) {
      if (kDebugMode) debugPrint('[ai] stream error: $stackTrace');
      if (controller.isClosed) return;
      controller.add(
        AiStreamFailed(
          UnknownFailure(technicalMessage: error.toString(), cause: error),
        ),
      );
    } finally {
      if (!controller.isClosed) await controller.close();
    }
  }

  Uri _requireUri() {
    final uri = _config.assistantUri;
    if (uri == null) {
      throw const MisconfiguredFailure(
        technicalMessage: 'AI_BASE_URL is not configured',
      );
    }
    return uri;
  }
}
