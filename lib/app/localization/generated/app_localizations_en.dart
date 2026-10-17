// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Khmer AI Assistant';

  @override
  String get appTagline => 'Your Khmer-first writing and learning helper';

  @override
  String get navHome => 'Home';

  @override
  String get navChat => 'Chat';

  @override
  String get navHistory => 'History';

  @override
  String get navSettings => 'Settings';

  @override
  String get navBack => 'Back';

  @override
  String get homeGreeting => 'Welcome. What can I help you with today?';

  @override
  String get homeAskHint => 'Ask anything…';

  @override
  String get homeAskLabel => 'Ask a question';

  @override
  String get homeSuggestionsTitle => 'Start with an example';

  @override
  String get homeQuickActionsTitle => 'Tools';

  @override
  String get homeSuggestion1 => 'Explain photosynthesis in simple Khmer';

  @override
  String get homeSuggestion2 =>
      'Translate “I will arrive tomorrow morning” into Khmer';

  @override
  String get homeSuggestion3 => 'Write a polite leave request email';

  @override
  String get homeSuggestion4 => 'Summarize this text in three bullet points';

  @override
  String get demoModeTitle => 'Demo mode';

  @override
  String get demoModeBody =>
      'No AI server is configured, so replies come from a built-in offline sample. Set the AI_BASE_URL build option to connect a real provider.';

  @override
  String quotaRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count free requests left today',
      one: '1 free request left today',
      zero: 'No free requests left today',
    );
    return '$_temp0';
  }

  @override
  String get quotaUnavailable => 'Usage information is not available.';

  @override
  String get chatTitle => 'Chat';

  @override
  String get chatNewConversation => 'New chat';

  @override
  String get chatInputHint => 'Message Khmer AI…';

  @override
  String get chatSend => 'Send';

  @override
  String get chatStop => 'Stop';

  @override
  String get chatRegenerate => 'Regenerate';

  @override
  String get chatCopyMessage => 'Copy message';

  @override
  String get chatCopied => 'Copied to clipboard';

  @override
  String get chatEmptyTitle => 'Ask your first question';

  @override
  String get chatEmptyBody =>
      'Khmer AI answers in natural Khmer and can switch to English on request.';

  @override
  String get chatEmptySuggestion1 => 'What is compound interest?';

  @override
  String get chatEmptySuggestion2 => 'Help me write a message to my landlord';

  @override
  String get chatEmptySuggestion3 => 'How do I prepare for a job interview?';

  @override
  String get chatStreaming => 'Writing a reply…';

  @override
  String get chatThinking => 'Thinking…';

  @override
  String get chatUntitled => 'New conversation';

  @override
  String get chatRenameTitle => 'Rename conversation';

  @override
  String get chatRenameHint => 'Conversation name';

  @override
  String get chatRenameSave => 'Save';

  @override
  String get chatDeleteTitle => 'Delete conversation?';

  @override
  String get chatDeleteBody =>
      'This conversation will be removed from this device. This cannot be undone.';

  @override
  String get chatDeleteConfirm => 'Delete';

  @override
  String get chatClearInput => 'Clear input';

  @override
  String get chatAssistantLabel => 'Assistant message';

  @override
  String get chatUserLabel => 'Your message';

  @override
  String get historyTitle => 'History';

  @override
  String get historyEmptyTitle => 'No conversations yet';

  @override
  String get historyEmptyBody =>
      'Your conversations are saved on this device only.';

  @override
  String get historyOpen => 'Open';

  @override
  String get historyRename => 'Rename';

  @override
  String get historyDelete => 'Delete';

  @override
  String historyMessageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count messages',
      one: '1 message',
    );
    return '$_temp0';
  }

  @override
  String get historyCleared => 'Local chat history cleared';

  @override
  String get translateTitle => 'Translate';

  @override
  String get translateFrom => 'From';

  @override
  String get translateTo => 'To';

  @override
  String get translateInputHint => 'Enter the text to translate';

  @override
  String get translateOutputLabel => 'Translation';

  @override
  String get translateSwap => 'Swap languages';

  @override
  String get translateAction => 'Translate';

  @override
  String get translateClear => 'Clear';

  @override
  String get translateOutputEmpty => 'The translation appears here.';

  @override
  String get translateAutoDetect => 'Detect automatically';

  @override
  String translateDetected(String language) {
    return 'Detected language: $language';
  }

  @override
  String get translateDisclaimer =>
      'Machine translation can miss nuance. Please check important text.';

  @override
  String get languageKhmer => 'Khmer';

  @override
  String get languageEnglish => 'English';

  @override
  String get writingTitle => 'Writing assistant';

  @override
  String get writingInputHint => 'Paste or type your text';

  @override
  String get writingOutputLabel => 'Generated draft';

  @override
  String get writingOutputPlaceholder => 'The improved text appears here.';

  @override
  String get writingGenerate => 'Generate';

  @override
  String get writingOutputNotice =>
      'Generated text is a draft. Review it before you send it anywhere.';

  @override
  String get writingEditHint => 'You can edit the draft before copying it.';

  @override
  String get writingTargetLanguage => 'Output language';

  @override
  String get writingTone => 'Tone';

  @override
  String get writingToneNeutral => 'Neutral';

  @override
  String get writingToneProfessional => 'Professional';

  @override
  String get writingToneFriendly => 'Friendly';

  @override
  String get writingToneCasual => 'Casual';

  @override
  String get writingTopicHint => 'What should the draft be about?';

  @override
  String get writingActionImprove => 'Improve writing';

  @override
  String get writingActionFixGrammar => 'Fix grammar and spelling';

  @override
  String get writingActionProfessional => 'Make it professional';

  @override
  String get writingActionFriendly => 'Make it friendly';

  @override
  String get writingActionShorten => 'Shorten';

  @override
  String get writingActionExpand => 'Expand';

  @override
  String get writingActionDraftMessage => 'Draft a message';

  @override
  String get writingActionDraftJobApplication =>
      'Draft a job application email';

  @override
  String get summarizeTitle => 'Summarize';

  @override
  String get summarizeInputHint => 'Paste the text you want to summarize';

  @override
  String get summarizeAction => 'Summarize';

  @override
  String get summarizeStyle => 'Summary style';

  @override
  String get summarizeStyleShort => 'Short';

  @override
  String get summarizeStyleDetailed => 'Detailed';

  @override
  String get summarizeStyleBullets => 'Bullet points';

  @override
  String get summarizeOutputLabel => 'Summary';

  @override
  String get summarizeOutputPlaceholder => 'The summary appears here.';

  @override
  String get summarizeInputRequired => 'Enter some text first.';

  @override
  String summarizeInputTooLong(int limit) {
    return 'This text is too long. Keep it under $limit characters.';
  }

  @override
  String summarizeCounter(int used, int limit) {
    return '$used / $limit characters';
  }

  @override
  String get englishTitle => 'Learn English';

  @override
  String get englishInputHint => 'Enter an English word, phrase, or sentence';

  @override
  String get englishAction => 'Explain in Khmer';

  @override
  String get englishOutputLabel => 'Explanation';

  @override
  String get englishOutputPlaceholder =>
      'A Khmer explanation with examples appears here.';

  @override
  String get englishExamplesTitle => 'Examples';

  @override
  String get errorNetwork =>
      'No internet connection. Check your network and try again.';

  @override
  String get errorTimeout => 'The request took too long. Please try again.';

  @override
  String get errorUnauthorized =>
      'Your session is not authorised. Check your access token in Settings.';

  @override
  String get errorRateLimited =>
      'Too many requests right now. Please wait a moment and try again.';

  @override
  String get errorProvider =>
      'The AI service could not answer this request. Please try again.';

  @override
  String get errorInvalidResponse =>
      'The AI service returned an unexpected response.';

  @override
  String get errorInputTooLarge =>
      'Your input is too long. Shorten it and try again.';

  @override
  String get errorQuotaExceeded =>
      'You have used your free requests for now. Please try again later.';

  @override
  String get errorServer =>
      'The service is temporarily unavailable. Please try again later.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';

  @override
  String get errorMisconfigured =>
      'The app is not configured with an AI server address.';

  @override
  String get errorCancelled => 'Request cancelled.';

  @override
  String get errorInvalidInput => 'Please enter some text first.';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionCopy => 'Copy';

  @override
  String get actionCopied => 'Copied';

  @override
  String get actionClear => 'Clear';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionSave => 'Save';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionClose => 'Close';

  @override
  String get actionTryAgain => 'Try again';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsInterfaceLanguage => 'Interface language';

  @override
  String get settingsLanguageSystem => 'System default';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsThemeSystem => 'System default';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsUsageTitle => 'AI usage';

  @override
  String get settingsUsageUnavailable =>
      'This build has no usage data from the server.';

  @override
  String get settingsServerMode => 'Server mode';

  @override
  String get settingsServerLive => 'Connected to a real AI server';

  @override
  String get settingsServerDemo => 'Demo mode (offline sample replies)';

  @override
  String get settingsServerMissing => 'No AI server configured';

  @override
  String get settingsPrivacyTitle => 'Privacy';

  @override
  String get settingsPrivacyBody =>
      'Conversations are stored on this device only. Text you send is transmitted to the AI server you configured so it can generate a reply. Do not share secrets or sensitive personal data.';

  @override
  String get settingsDataTitle => 'Data';

  @override
  String get settingsClearHistory => 'Clear local chat history';

  @override
  String get settingsClearHistoryBody =>
      'All conversations stored on this device will be deleted. This cannot be undone.';

  @override
  String get settingsAdvancedTitle => 'Advanced';

  @override
  String get settingsAccessToken => 'Access token';

  @override
  String get settingsAccessTokenHint =>
      'Optional token sent to your own AI server';

  @override
  String get settingsAccessTokenHelp =>
      'Stored in the device secure storage. Leave empty if your server does not require one.';

  @override
  String get settingsAccessTokenSaved => 'Access token saved';

  @override
  String get settingsAccessTokenCleared => 'Access token removed';

  @override
  String get settingsAboutTitle => 'About';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsClearHistoryDone => 'Chat history cleared';

  @override
  String get offlineBanner => 'You are offline. Some features will not work.';

  @override
  String a11yQuickAction(String feature) {
    return 'Open $feature';
  }

  @override
  String get a11ySendButton => 'Send message';

  @override
  String get a11yStopButton => 'Stop generating';

  @override
  String get a11yCopyButton => 'Copy to clipboard';

  @override
  String a11yDeleteConversation(String title) {
    return 'Delete conversation $title';
  }

  @override
  String get a11ySwapLanguages => 'Swap source and target languages';

  @override
  String a11yThemeOption(String theme) {
    return '$theme theme';
  }

  @override
  String a11yLanguageOption(String language) {
    return '$language interface';
  }

  @override
  String get featureChat => 'Chat';

  @override
  String get featureChatSubtitle => 'Ask anything, get answers in Khmer';

  @override
  String get featureTranslate => 'Translate';

  @override
  String get featureTranslateSubtitle => 'Khmer and English, both directions';

  @override
  String get featureWriting => 'Writing';

  @override
  String get featureWritingSubtitle => 'Improve, rewrite, draft messages';

  @override
  String get featureSummarize => 'Summarize';

  @override
  String get featureSummarizeSubtitle => 'Turn long text into key points';

  @override
  String get featureEnglish => 'Learn English';

  @override
  String get featureEnglishSubtitle => 'English words explained in Khmer';
}
