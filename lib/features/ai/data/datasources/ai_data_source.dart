import '../../domain/entities/ai_reply.dart';
import '../../domain/entities/ai_stream_event.dart';
import '../dto/ai_request_dto.dart';

/// Transport contract for the AI backend.
///
/// Two implementations exist: [RemoteAiDataSource] for a real backend and
/// [MockAiDataSource] for local development. The active one is chosen once, at
/// startup, from configuration — there is no silent fallback at runtime.
abstract interface class AiDataSource {
  /// Streams a reply for [request].
  Stream<AiStreamEvent> stream(AiRequestDto request);

  /// Sends [request] and resolves with the complete reply.
  Future<AiReply> complete(AiRequestDto request);
}
