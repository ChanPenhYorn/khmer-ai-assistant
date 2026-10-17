import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/input_validator.dart';
import '../entities/ai_language.dart';
import '../entities/ai_reply.dart';
import '../repositories/ai_repository.dart';

/// Validates and performs an English-learning explanation request.
class ExplainEnglish {
  const ExplainEnglish({
    required AiRepository repository,
    required int maxInputCharacters,
  }) : _repository = repository,
       _maxInputCharacters = maxInputCharacters;

  final AiRepository _repository;
  final int _maxInputCharacters;

  Future<AiReply> call({
    required String text,
    required AiLanguage explanationLanguage,
  }) async {
    final validation = InputValidator.validate(
      text: text,
      maxCharacters: _maxInputCharacters,
    );
    if (validation != null) throw validation;

    return _repository.explainEnglish(
      text: text,
      explanationLanguage: explanationLanguage,
    );
  }
}
