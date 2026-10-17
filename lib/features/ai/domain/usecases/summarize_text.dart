import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/input_validator.dart';
import '../entities/ai_language.dart';
import '../entities/ai_reply.dart';
import '../entities/ai_task_options.dart';
import '../repositories/ai_repository.dart';

/// Validates and performs a summarization request.
class SummarizeText {
  const SummarizeText({
    required AiRepository repository,
    required int maxInputCharacters,
  }) : _repository = repository,
       _maxInputCharacters = maxInputCharacters;

  final AiRepository _repository;
  final int _maxInputCharacters;

  /// Minimum number of characters that makes summarization meaningful.
  static const int minimumCharacters = 40;

  Future<AiReply> call({
    required String text,
    required SummaryStyle style,
    required AiLanguage outputLanguage,
  }) async {
    final validation = InputValidator.validate(
      text: text,
      maxCharacters: _maxInputCharacters,
    );
    if (validation != null) throw validation;

    if (text.trim().length < minimumCharacters) {
      throw const InvalidInputFailure(
        technicalMessage: 'text too short to summarize',
      );
    }

    return _repository.summarize(
      text: text,
      style: style,
      outputLanguage: outputLanguage,
    );
  }
}
