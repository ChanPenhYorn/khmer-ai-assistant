import 'package:flutter/foundation.dart';

import '../../../../core/errors/app_failure.dart';
import 'ai_reply.dart';

/// Events emitted while the assistant is producing a response.
///
/// Using an explicit event type keeps the UI independent of any single
/// vendor's streaming format: the data layer translates whatever the backend
/// sends into these three cases.
@immutable
sealed class AiStreamEvent {
  const AiStreamEvent();
}

/// A piece of generated text. Deltas are additive and must be appended.
final class AiStreamDelta extends AiStreamEvent {
  const AiStreamDelta(this.text);

  final String text;
}

/// The response finished successfully.
final class AiStreamCompleted extends AiStreamEvent {
  const AiStreamCompleted(this.reply);

  final AiReply reply;
}

/// The response failed. Partial text already emitted stays on screen.
final class AiStreamFailed extends AiStreamEvent {
  const AiStreamFailed(this.failure);

  final AppFailure failure;
}
