/// Task identifiers understood by the AI backend.
///
/// The wire values are part of the client/server contract documented in
/// `backend/README.md`. Chat uses [AiTask.chat], everything else sends a single
/// input string plus task parameters.
enum AiTask {
  chat('chat'),
  translate('translate'),
  improveWriting('improve_writing'),
  summarize('summarize'),
  explainEnglish('explain_english');

  const AiTask(this.wireValue);

  final String wireValue;
}
