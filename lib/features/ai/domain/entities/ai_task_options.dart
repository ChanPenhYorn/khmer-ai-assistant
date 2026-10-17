/// Preset writing operations offered on the writing screen.
enum WritingAction {
  improve('improve'),
  fixGrammar('fix_grammar'),
  professional('professional'),
  friendly('friendly'),
  shorten('shorten'),
  expand('expand'),
  draftMessage('draft_message'),
  draftJobApplication('draft_job_application');

  const WritingAction(this.wireValue);

  /// Value sent to the backend in `params.action`.
  final String wireValue;

  /// `true` when the user must supply a topic instead of source text.
  bool get requiresTopic => switch (this) {
    WritingAction.draftMessage => true,
    WritingAction.draftJobApplication => true,
    _ => false,
  };
}

/// Tone hints passed to the model.
enum WritingTone {
  neutral('neutral'),
  professional('professional'),
  friendly('friendly'),
  casual('casual');

  const WritingTone(this.wireValue);

  final String wireValue;
}

/// Summary styles offered on the summarization screen.
enum SummaryStyle {
  short('short'),
  detailed('detailed'),
  bullets('bullets');

  const SummaryStyle(this.wireValue);

  final String wireValue;
}
