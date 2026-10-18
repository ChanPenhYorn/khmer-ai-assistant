import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_km.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('km'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Khmer AI Assistant'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Your Khmer-first writing and learning helper'**
  String get appTagline;

  /// No description provided for @assistantName.
  ///
  /// In en, this message translates to:
  /// **'Khmer AI'**
  String get assistantName;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask a question, translate, write or learn — all in natural Khmer.'**
  String get homeSubtitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get navBack;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome. What can I help you with today?'**
  String get homeGreeting;

  /// No description provided for @homeAskHint.
  ///
  /// In en, this message translates to:
  /// **'Ask anything…'**
  String get homeAskHint;

  /// No description provided for @homeAskLabel.
  ///
  /// In en, this message translates to:
  /// **'Ask a question'**
  String get homeAskLabel;

  /// No description provided for @homeSuggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Start with an example'**
  String get homeSuggestionsTitle;

  /// No description provided for @homeQuickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get homeQuickActionsTitle;

  /// No description provided for @homeSuggestion1.
  ///
  /// In en, this message translates to:
  /// **'Explain photosynthesis in simple Khmer'**
  String get homeSuggestion1;

  /// No description provided for @homeSuggestion2.
  ///
  /// In en, this message translates to:
  /// **'Translate “I will arrive tomorrow morning” into Khmer'**
  String get homeSuggestion2;

  /// No description provided for @homeSuggestion3.
  ///
  /// In en, this message translates to:
  /// **'Write a polite leave request email'**
  String get homeSuggestion3;

  /// No description provided for @homeSuggestion4.
  ///
  /// In en, this message translates to:
  /// **'Summarize this text in three bullet points'**
  String get homeSuggestion4;

  /// No description provided for @demoModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo mode'**
  String get demoModeTitle;

  /// No description provided for @demoModeBody.
  ///
  /// In en, this message translates to:
  /// **'Sample mode is switched on, so replies come from a built-in offline sample. Run without --dart-define=AI_USE_MOCK=true to connect to the real AI server.'**
  String get demoModeBody;

  /// No description provided for @quotaRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No free requests left today} =1{1 free request left today} other{{count} free requests left today}}'**
  String quotaRemaining(int count);

  /// No description provided for @quotaUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Usage information is not available.'**
  String get quotaUnavailable;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatTitle;

  /// No description provided for @chatNewConversation.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get chatNewConversation;

  /// No description provided for @chatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Message Khmer AI…'**
  String get chatInputHint;

  /// No description provided for @chatSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chatSend;

  /// No description provided for @chatStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get chatStop;

  /// No description provided for @chatRegenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get chatRegenerate;

  /// No description provided for @chatCopyMessage.
  ///
  /// In en, this message translates to:
  /// **'Copy message'**
  String get chatCopyMessage;

  /// No description provided for @chatCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get chatCopied;

  /// No description provided for @chatEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask your first question'**
  String get chatEmptyTitle;

  /// No description provided for @chatEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Khmer AI answers in natural Khmer and can switch to English on request.'**
  String get chatEmptyBody;

  /// No description provided for @chatEmptySuggestion1.
  ///
  /// In en, this message translates to:
  /// **'What is compound interest?'**
  String get chatEmptySuggestion1;

  /// No description provided for @chatEmptySuggestion2.
  ///
  /// In en, this message translates to:
  /// **'Help me write a message to my landlord'**
  String get chatEmptySuggestion2;

  /// No description provided for @chatEmptySuggestion3.
  ///
  /// In en, this message translates to:
  /// **'How do I prepare for a job interview?'**
  String get chatEmptySuggestion3;

  /// No description provided for @chatStreaming.
  ///
  /// In en, this message translates to:
  /// **'Writing a reply…'**
  String get chatStreaming;

  /// No description provided for @chatScrollToBottom.
  ///
  /// In en, this message translates to:
  /// **'Jump to latest'**
  String get chatScrollToBottom;

  /// No description provided for @chatThinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking…'**
  String get chatThinking;

  /// No description provided for @chatUntitled.
  ///
  /// In en, this message translates to:
  /// **'New conversation'**
  String get chatUntitled;

  /// No description provided for @chatRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename conversation'**
  String get chatRenameTitle;

  /// No description provided for @chatRenameHint.
  ///
  /// In en, this message translates to:
  /// **'Conversation name'**
  String get chatRenameHint;

  /// No description provided for @chatRenameSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get chatRenameSave;

  /// No description provided for @chatDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete conversation?'**
  String get chatDeleteTitle;

  /// No description provided for @chatDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This conversation will be removed from this device. This cannot be undone.'**
  String get chatDeleteBody;

  /// No description provided for @chatDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get chatDeleteConfirm;

  /// No description provided for @chatClearInput.
  ///
  /// In en, this message translates to:
  /// **'Clear input'**
  String get chatClearInput;

  /// No description provided for @chatAssistantLabel.
  ///
  /// In en, this message translates to:
  /// **'Assistant message'**
  String get chatAssistantLabel;

  /// No description provided for @chatUserLabel.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get chatUserLabel;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your conversations are saved on this device only.'**
  String get historyEmptyBody;

  /// No description provided for @historyOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get historyOpen;

  /// No description provided for @historyRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get historyRename;

  /// No description provided for @historyDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get historyDelete;

  /// No description provided for @historyMessageCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 message} other{{count} messages}}'**
  String historyMessageCount(int count);

  /// No description provided for @historyCleared.
  ///
  /// In en, this message translates to:
  /// **'Local chat history cleared'**
  String get historyCleared;

  /// No description provided for @translateTitle.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translateTitle;

  /// No description provided for @translateFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get translateFrom;

  /// No description provided for @translateTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get translateTo;

  /// No description provided for @translateInputHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the text to translate'**
  String get translateInputHint;

  /// No description provided for @translateOutputLabel.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translateOutputLabel;

  /// No description provided for @translateSwap.
  ///
  /// In en, this message translates to:
  /// **'Swap languages'**
  String get translateSwap;

  /// No description provided for @translateAction.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translateAction;

  /// No description provided for @translateClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get translateClear;

  /// No description provided for @translateOutputEmpty.
  ///
  /// In en, this message translates to:
  /// **'The translation appears here.'**
  String get translateOutputEmpty;

  /// No description provided for @translateAutoDetect.
  ///
  /// In en, this message translates to:
  /// **'Detect automatically'**
  String get translateAutoDetect;

  /// No description provided for @translateDetected.
  ///
  /// In en, this message translates to:
  /// **'Detected language: {language}'**
  String translateDetected(String language);

  /// No description provided for @translateDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Machine translation can miss nuance. Please check important text.'**
  String get translateDisclaimer;

  /// No description provided for @languageKhmer.
  ///
  /// In en, this message translates to:
  /// **'Khmer'**
  String get languageKhmer;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @writingTitle.
  ///
  /// In en, this message translates to:
  /// **'Writing assistant'**
  String get writingTitle;

  /// No description provided for @writingInputHint.
  ///
  /// In en, this message translates to:
  /// **'Paste or type your text'**
  String get writingInputHint;

  /// No description provided for @writingOutputLabel.
  ///
  /// In en, this message translates to:
  /// **'Generated draft'**
  String get writingOutputLabel;

  /// No description provided for @writingOutputPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'The improved text appears here.'**
  String get writingOutputPlaceholder;

  /// No description provided for @writingGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get writingGenerate;

  /// No description provided for @writingOutputNotice.
  ///
  /// In en, this message translates to:
  /// **'Generated text is a draft. Review it before you send it anywhere.'**
  String get writingOutputNotice;

  /// No description provided for @writingEditHint.
  ///
  /// In en, this message translates to:
  /// **'You can edit the draft before copying it.'**
  String get writingEditHint;

  /// No description provided for @writingTargetLanguage.
  ///
  /// In en, this message translates to:
  /// **'Output language'**
  String get writingTargetLanguage;

  /// No description provided for @writingTone.
  ///
  /// In en, this message translates to:
  /// **'Tone'**
  String get writingTone;

  /// No description provided for @writingToneNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get writingToneNeutral;

  /// No description provided for @writingToneProfessional.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get writingToneProfessional;

  /// No description provided for @writingToneFriendly.
  ///
  /// In en, this message translates to:
  /// **'Friendly'**
  String get writingToneFriendly;

  /// No description provided for @writingToneCasual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get writingToneCasual;

  /// No description provided for @writingTopicHint.
  ///
  /// In en, this message translates to:
  /// **'What should the draft be about?'**
  String get writingTopicHint;

  /// No description provided for @writingActionImprove.
  ///
  /// In en, this message translates to:
  /// **'Improve writing'**
  String get writingActionImprove;

  /// No description provided for @writingActionFixGrammar.
  ///
  /// In en, this message translates to:
  /// **'Fix grammar and spelling'**
  String get writingActionFixGrammar;

  /// No description provided for @writingActionProfessional.
  ///
  /// In en, this message translates to:
  /// **'Make it professional'**
  String get writingActionProfessional;

  /// No description provided for @writingActionFriendly.
  ///
  /// In en, this message translates to:
  /// **'Make it friendly'**
  String get writingActionFriendly;

  /// No description provided for @writingActionShorten.
  ///
  /// In en, this message translates to:
  /// **'Shorten'**
  String get writingActionShorten;

  /// No description provided for @writingActionExpand.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get writingActionExpand;

  /// No description provided for @writingActionDraftMessage.
  ///
  /// In en, this message translates to:
  /// **'Draft a message'**
  String get writingActionDraftMessage;

  /// No description provided for @writingActionDraftJobApplication.
  ///
  /// In en, this message translates to:
  /// **'Draft a job application email'**
  String get writingActionDraftJobApplication;

  /// No description provided for @summarizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Summarize'**
  String get summarizeTitle;

  /// No description provided for @summarizeInputHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the text you want to summarize'**
  String get summarizeInputHint;

  /// No description provided for @summarizeAction.
  ///
  /// In en, this message translates to:
  /// **'Summarize'**
  String get summarizeAction;

  /// No description provided for @summarizeStyle.
  ///
  /// In en, this message translates to:
  /// **'Summary style'**
  String get summarizeStyle;

  /// No description provided for @summarizeStyleShort.
  ///
  /// In en, this message translates to:
  /// **'Short'**
  String get summarizeStyleShort;

  /// No description provided for @summarizeStyleDetailed.
  ///
  /// In en, this message translates to:
  /// **'Detailed'**
  String get summarizeStyleDetailed;

  /// No description provided for @summarizeStyleBullets.
  ///
  /// In en, this message translates to:
  /// **'Bullet points'**
  String get summarizeStyleBullets;

  /// No description provided for @summarizeOutputLabel.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summarizeOutputLabel;

  /// No description provided for @summarizeOutputPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'The summary appears here.'**
  String get summarizeOutputPlaceholder;

  /// No description provided for @summarizeInputRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter some text first.'**
  String get summarizeInputRequired;

  /// No description provided for @summarizeInputTooLong.
  ///
  /// In en, this message translates to:
  /// **'This text is too long. Keep it under {limit} characters.'**
  String summarizeInputTooLong(int limit);

  /// No description provided for @summarizeCounter.
  ///
  /// In en, this message translates to:
  /// **'{used} / {limit} characters'**
  String summarizeCounter(int used, int limit);

  /// No description provided for @englishTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn English'**
  String get englishTitle;

  /// No description provided for @englishInputHint.
  ///
  /// In en, this message translates to:
  /// **'Enter an English word, phrase, or sentence'**
  String get englishInputHint;

  /// No description provided for @englishAction.
  ///
  /// In en, this message translates to:
  /// **'Explain in Khmer'**
  String get englishAction;

  /// No description provided for @englishOutputLabel.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get englishOutputLabel;

  /// No description provided for @englishOutputPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'A Khmer explanation with examples appears here.'**
  String get englishOutputPlaceholder;

  /// No description provided for @englishExamplesTitle.
  ///
  /// In en, this message translates to:
  /// **'Examples'**
  String get englishExamplesTitle;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request took too long. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session is not authorised. Check your access token in Settings.'**
  String get errorUnauthorized;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many requests right now. Please wait a moment and try again.'**
  String get errorRateLimited;

  /// No description provided for @errorProvider.
  ///
  /// In en, this message translates to:
  /// **'The AI service could not answer this request. Please try again.'**
  String get errorProvider;

  /// No description provided for @errorInvalidResponse.
  ///
  /// In en, this message translates to:
  /// **'The AI service returned an unexpected response.'**
  String get errorInvalidResponse;

  /// No description provided for @errorInputTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Your input is too long. Shorten it and try again.'**
  String get errorInputTooLarge;

  /// No description provided for @errorQuotaExceeded.
  ///
  /// In en, this message translates to:
  /// **'You have used your free requests for now. Please try again later.'**
  String get errorQuotaExceeded;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'The service is temporarily unavailable. Please try again later.'**
  String get errorServer;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnknown;

  /// No description provided for @errorMisconfigured.
  ///
  /// In en, this message translates to:
  /// **'The app is not configured with an AI server address.'**
  String get errorMisconfigured;

  /// No description provided for @errorCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled.'**
  String get errorCancelled;

  /// No description provided for @errorInvalidInput.
  ///
  /// In en, this message translates to:
  /// **'Please enter some text first.'**
  String get errorInvalidInput;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get actionCopy;

  /// No description provided for @actionCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get actionCopied;

  /// No description provided for @actionClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get actionClear;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionTryAgain;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsInterfaceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Interface language'**
  String get settingsInterfaceLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'AI usage'**
  String get settingsUsageTitle;

  /// No description provided for @settingsUsageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This build has no usage data from the server.'**
  String get settingsUsageUnavailable;

  /// No description provided for @settingsServerMode.
  ///
  /// In en, this message translates to:
  /// **'Server mode'**
  String get settingsServerMode;

  /// No description provided for @settingsServerLive.
  ///
  /// In en, this message translates to:
  /// **'Connected to a real AI server'**
  String get settingsServerLive;

  /// No description provided for @settingsServerDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo mode (offline sample replies)'**
  String get settingsServerDemo;

  /// No description provided for @settingsServerMissing.
  ///
  /// In en, this message translates to:
  /// **'No AI server configured'**
  String get settingsServerMissing;

  /// No description provided for @settingsPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacyTitle;

  /// No description provided for @settingsPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Conversations are stored on this device only. Text you send is transmitted to the AI server you configured so it can generate a reply. Do not share secrets or sensitive personal data.'**
  String get settingsPrivacyBody;

  /// No description provided for @settingsDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsDataTitle;

  /// No description provided for @settingsClearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear local chat history'**
  String get settingsClearHistory;

  /// No description provided for @settingsClearHistoryBody.
  ///
  /// In en, this message translates to:
  /// **'All conversations stored on this device will be deleted. This cannot be undone.'**
  String get settingsClearHistoryBody;

  /// No description provided for @settingsAdvancedTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get settingsAdvancedTitle;

  /// No description provided for @settingsAccessToken.
  ///
  /// In en, this message translates to:
  /// **'Access token'**
  String get settingsAccessToken;

  /// No description provided for @settingsAccessTokenHint.
  ///
  /// In en, this message translates to:
  /// **'Optional token sent to your own AI server'**
  String get settingsAccessTokenHint;

  /// No description provided for @settingsAccessTokenHelp.
  ///
  /// In en, this message translates to:
  /// **'Stored in the device secure storage. Leave empty if your server does not require one.'**
  String get settingsAccessTokenHelp;

  /// No description provided for @settingsAccessTokenSaved.
  ///
  /// In en, this message translates to:
  /// **'Access token saved'**
  String get settingsAccessTokenSaved;

  /// No description provided for @settingsAccessTokenCleared.
  ///
  /// In en, this message translates to:
  /// **'Access token removed'**
  String get settingsAccessTokenCleared;

  /// No description provided for @settingsAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutTitle;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @settingsClearHistoryDone.
  ///
  /// In en, this message translates to:
  /// **'Chat history cleared'**
  String get settingsClearHistoryDone;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Some features will not work.'**
  String get offlineBanner;

  /// No description provided for @a11yQuickAction.
  ///
  /// In en, this message translates to:
  /// **'Open {feature}'**
  String a11yQuickAction(String feature);

  /// No description provided for @a11ySendButton.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get a11ySendButton;

  /// No description provided for @a11yStopButton.
  ///
  /// In en, this message translates to:
  /// **'Stop generating'**
  String get a11yStopButton;

  /// No description provided for @a11yCopyButton.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get a11yCopyButton;

  /// No description provided for @a11yDeleteConversation.
  ///
  /// In en, this message translates to:
  /// **'Delete conversation {title}'**
  String a11yDeleteConversation(String title);

  /// No description provided for @a11ySwapLanguages.
  ///
  /// In en, this message translates to:
  /// **'Swap source and target languages'**
  String get a11ySwapLanguages;

  /// No description provided for @a11yThemeOption.
  ///
  /// In en, this message translates to:
  /// **'{theme} theme'**
  String a11yThemeOption(String theme);

  /// No description provided for @a11yLanguageOption.
  ///
  /// In en, this message translates to:
  /// **'{language} interface'**
  String a11yLanguageOption(String language);

  /// No description provided for @featureChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get featureChat;

  /// No description provided for @featureChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask anything, get answers in Khmer'**
  String get featureChatSubtitle;

  /// No description provided for @featureTranslate.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get featureTranslate;

  /// No description provided for @featureTranslateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Khmer and English, both directions'**
  String get featureTranslateSubtitle;

  /// No description provided for @featureWriting.
  ///
  /// In en, this message translates to:
  /// **'Writing'**
  String get featureWriting;

  /// No description provided for @featureWritingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Improve, rewrite, draft messages'**
  String get featureWritingSubtitle;

  /// No description provided for @featureSummarize.
  ///
  /// In en, this message translates to:
  /// **'Summarize'**
  String get featureSummarize;

  /// No description provided for @featureSummarizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Turn long text into key points'**
  String get featureSummarizeSubtitle;

  /// No description provided for @featureEnglish.
  ///
  /// In en, this message translates to:
  /// **'Learn English'**
  String get featureEnglish;

  /// No description provided for @featureEnglishSubtitle.
  ///
  /// In en, this message translates to:
  /// **'English words explained in Khmer'**
  String get featureEnglishSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'km'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'km':
      return AppLocalizationsKm();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
