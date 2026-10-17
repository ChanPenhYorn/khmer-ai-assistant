import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/input_validator.dart';
import '../entities/ai_language.dart';
import '../entities/ai_reply.dart';
import '../repositories/ai_repository.dart';

/// Validates and performs a translation request.
class TranslateText {
  const TranslateText({
    required AiRepository repository,
    required int maxInputCharacters,
  }) : _repository = repository,
       _maxInputCharacters = maxInputCharacters;

  final AiRepository _repository;
  final int _maxInputCharacters;

  Future<AiReply> call({
    required String text,
    required AiLanguage source,
    required AiLanguage target,
  }) async {
    final validation = InputValidator.validate(
      text: text,
      maxCharacters: _maxInputCharacters,
    );
    if (validation != null) throw validation;

    if (source != AiLanguage.auto && source == target) {
      throw const InvalidInputFailure(
        technicalMessage: 'source and target languages are identical',
      );
    }

    return _repository.translate(text: text, source: source, target: target);
  }
}
