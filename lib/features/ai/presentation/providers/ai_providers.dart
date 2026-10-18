import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/app_providers.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/dio_providers.dart';
import '../../data/datasources/ai_mock_data_source.dart';
import '../../data/datasources/ai_remote_data_source.dart';
import '../../data/repositories/ai_repository_impl.dart';
import '../../data/repositories/usage_recording_ai_repository.dart';
import '../../domain/entities/ai_reply.dart';
import '../../domain/entities/ai_stream_event.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../domain/usecases/explain_english.dart';
import '../../domain/usecases/improve_writing.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/summarize_text.dart';
import '../../domain/usecases/translate_text.dart';
import '../../data/datasources/ai_data_source.dart';
import '../../data/dto/ai_request_dto.dart';
import 'ai_usage_provider.dart';

part 'ai_providers.g.dart';

/// The data source used for this process.
///
/// Selection happens once, from configuration. There is no runtime fallback to
/// the sample source: an unconfigured build reports a misconfiguration instead
/// of pretending to answer.
@Riverpod(keepAlive: true)
AiDataSource aiDataSource(Ref ref) {
  final config = ref.watch(aiConfigProvider);
  if (config.useMockDataSource) return MockAiDataSource();
  if (!config.hasRemoteEndpoint) return const _MisconfiguredAiDataSource();
  return RemoteAiDataSource(dio: ref.watch(dioProvider), config: config);
}

@Riverpod(keepAlive: true)
AiRepository aiRepository(Ref ref) => UsageRecordingAiRepository(
  delegate: AiRepositoryImpl(dataSource: ref.watch(aiDataSourceProvider)),
  onUsage: (usage) =>
      ref.read(aiUsageControllerProvider.notifier).record(usage),
);

@Riverpod(keepAlive: true)
SendMessage sendMessage(Ref ref) => SendMessage(
  repository: ref.watch(aiRepositoryProvider),
  maxInputCharacters: ref.watch(aiConfigProvider).maxInputCharacters,
);

@Riverpod(keepAlive: true)
TranslateText translateText(Ref ref) => TranslateText(
  repository: ref.watch(aiRepositoryProvider),
  maxInputCharacters: ref.watch(aiConfigProvider).maxInputCharacters,
);

@Riverpod(keepAlive: true)
ImproveWriting improveWriting(Ref ref) => ImproveWriting(
  repository: ref.watch(aiRepositoryProvider),
  maxInputCharacters: ref.watch(aiConfigProvider).maxInputCharacters,
);

@Riverpod(keepAlive: true)
SummarizeText summarizeText(Ref ref) => SummarizeText(
  repository: ref.watch(aiRepositoryProvider),
  maxInputCharacters: ref.watch(aiConfigProvider).maxInputCharacters,
);

@Riverpod(keepAlive: true)
ExplainEnglish explainEnglish(Ref ref) => ExplainEnglish(
  repository: ref.watch(aiRepositoryProvider),
  maxInputCharacters: ref.watch(aiConfigProvider).maxInputCharacters,
);

/// Fails every call with a configuration error.
///
/// Used when the build has neither a backend address nor demo mode enabled, so
/// the app cannot answer and says so.
class _MisconfiguredAiDataSource implements AiDataSource {
  const _MisconfiguredAiDataSource();

  @override
  Future<AiReply> complete(AiRequestDto request) async =>
      throw const MisconfiguredFailure(technicalMessage: 'no AI endpoint');

  @override
  Stream<AiStreamEvent> stream(AiRequestDto request) =>
      Stream<AiStreamEvent>.value(const AiStreamFailed(MisconfiguredFailure()));
}
