// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Khmer Central Khmer (`km`).
class AppLocalizationsKm extends AppLocalizations {
  AppLocalizationsKm([String locale = 'km']) : super(locale);

  @override
  String get appTitle => 'ជំនួយការ AI ខ្មែរ';

  @override
  String get appTagline =>
      'ជំនួយការសរសេរ និងរៀនភាសា សម្រាប់អ្នកប្រើប្រាស់នៅកម្ពុជា';

  @override
  String get assistantName => 'AI ខ្មែរ';

  @override
  String get homeSubtitle =>
      'សួរសំណួរ បកប្រែ សរសេរ ឬរៀន — ទាំងអស់ជាភាសាខ្មែរធម្មជាតិ។';

  @override
  String get navHome => 'ទំព័រដើម';

  @override
  String get navChat => 'សន្ទនា';

  @override
  String get navHistory => 'ប្រវត្តិ';

  @override
  String get navSettings => 'ការកំណត់';

  @override
  String get navBack => 'ត្រឡប់ក្រោយ';

  @override
  String get homeGreeting => 'សូមស្វាគមន៍! តើថ្ងៃនេះខ្ញុំអាចជួយអ្នកអ្វីបាន?';

  @override
  String get homeAskHint => 'សួរអ្វីក៏បាន…';

  @override
  String get homeAskLabel => 'សួរសំណួរ';

  @override
  String get homeSuggestionsTitle => 'ចាប់ផ្ដើមពីឧទាហរណ៍';

  @override
  String get homeQuickActionsTitle => 'ឧបករណ៍';

  @override
  String get homeSuggestion1 => 'ពន្យល់អំពីរុក្ខសំយោគជាភាសាខ្មែរសាមញ្ញ';

  @override
  String get homeSuggestion2 =>
      'បកប្រែ «ខ្ញុំនឹងមកដល់ព្រឹកស្អែក» ជាភាសាអង់គ្លេស';

  @override
  String get homeSuggestion3 => 'សរសេរអ៊ីមែលសុំច្បាប់សម្រាកយ៉ាងគួរសម';

  @override
  String get homeSuggestion4 => 'សង្ខេបអត្ថបទនេះជាបីចំណុច';

  @override
  String get demoModeTitle => 'របៀបសាកល្បង';

  @override
  String get demoModeBody =>
      'របៀបសាកល្បងកំពុងបើក ដូច្នេះចម្លើយមកពីគំរូក្នុងកម្មវិធី។ សូមដំណើរការដោយមិនប្រើ --dart-define=AI_USE_MOCK=true ដើម្បីភ្ជាប់ទៅម៉ាស៊ីន AI ពិតប្រាកដ។';

  @override
  String quotaRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'នៅសល់ $count សំណួរឥតគិតថ្លៃថ្ងៃនេះ',
      one: 'នៅសល់ $count សំណួរឥតគិតថ្លៃថ្ងៃនេះ',
      zero: 'អស់ចំនួនសំណួរឥតគិតថ្លៃសម្រាប់ថ្ងៃនេះ',
    );
    return '$_temp0';
  }

  @override
  String get quotaUnavailable => 'មិនមានព័ត៌មានអំពីការប្រើប្រាស់ទេ។';

  @override
  String get chatTitle => 'សន្ទនា';

  @override
  String get chatNewConversation => 'សន្ទនាថ្មី';

  @override
  String get chatInputHint => 'សរសេរសារទៅកាន់ AI ខ្មែរ…';

  @override
  String get chatSend => 'ផ្ញើ';

  @override
  String get chatStop => 'បញ្ឈប់';

  @override
  String get chatRegenerate => 'បង្កើតឡើងវិញ';

  @override
  String get chatCopyMessage => 'ចម្លងសារ';

  @override
  String get chatCopied => 'បានចម្លងទៅក្ដារតម្បាល់';

  @override
  String get chatEmptyTitle => 'សួរសំណួរដំបូងរបស់អ្នក';

  @override
  String get chatEmptyBody =>
      'AI ខ្មែរ ឆ្លើយជាភាសាខ្មែរធម្មជាតិ ហើយអាចប្ដូរទៅភាសាអង់គ្លេសតាមសំណូមពរ។';

  @override
  String get chatEmptySuggestion1 => 'អ្វីទៅជាការប្រាក់ចំណេញរួម?';

  @override
  String get chatEmptySuggestion2 => 'ជួយសរសេរសារទៅម្ចាស់ផ្ទះរបស់ខ្ញុំ';

  @override
  String get chatEmptySuggestion3 =>
      'តើខ្ញុំគួររៀបចំខ្លួនយ៉ាងដូចម្ដេចសម្រាប់សម្ភាសន៍ការងារ?';

  @override
  String get chatStreaming => 'កំពុងសរសេរចម្លើយ…';

  @override
  String get chatScrollToBottom => 'លោតទៅសារចុងក្រោយ';

  @override
  String get chatThinking => 'កំពុងគិត…';

  @override
  String get chatUntitled => 'សន្ទនាថ្មី';

  @override
  String get chatRenameTitle => 'ប្ដូរឈ្មោះសន្ទនា';

  @override
  String get chatRenameHint => 'ឈ្មោះសន្ទនា';

  @override
  String get chatRenameSave => 'រក្សាទុក';

  @override
  String get chatDeleteTitle => 'លុបសន្ទនានេះ?';

  @override
  String get chatDeleteBody =>
      'សន្ទនានេះនឹងត្រូវលុបចេញពីឧបករណ៍នេះ។ មិនអាចត្រឡប់វិញបានទេ។';

  @override
  String get chatDeleteConfirm => 'លុប';

  @override
  String get chatClearInput => 'សម្អាតប្រអប់សរសេរ';

  @override
  String get chatAssistantLabel => 'សារពីជំនួយការ';

  @override
  String get chatUserLabel => 'សាររបស់អ្នក';

  @override
  String get historyTitle => 'ប្រវត្តិសន្ទនា';

  @override
  String get historyEmptyTitle => 'មិនទាន់មានសន្ទនាទេ';

  @override
  String get historyEmptyBody =>
      'សន្ទនារបស់អ្នករក្សាទុកក្នុងឧបករណ៍នេះតែប៉ុណ្ណោះ។';

  @override
  String get historyOpen => 'បើក';

  @override
  String get historyRename => 'ប្ដូរឈ្មោះ';

  @override
  String get historyDelete => 'លុប';

  @override
  String historyMessageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count សារ',
      one: '១ សារ',
    );
    return '$_temp0';
  }

  @override
  String get historyCleared => 'បានសម្អាតប្រវត្តិសន្ទនាក្នុងឧបករណ៍';

  @override
  String get translateTitle => 'បកប្រែ';

  @override
  String get translateFrom => 'ពីភាសា';

  @override
  String get translateTo => 'ទៅភាសា';

  @override
  String get translateInputHint => 'បញ្ចូលអត្ថបទដែលត្រូវបកប្រែ';

  @override
  String get translateOutputLabel => 'ការបកប្រែ';

  @override
  String get translateSwap => 'ប្ដូរភាសា';

  @override
  String get translateAction => 'បកប្រែ';

  @override
  String get translateClear => 'សម្អាត';

  @override
  String get translateOutputEmpty => 'ការបកប្រែនឹងបង្ហាញនៅទីនេះ។';

  @override
  String get translateAutoDetect => 'រកភាសាដោយស្វ័យប្រវត្តិ';

  @override
  String translateDetected(String language) {
    return 'ភាសាដែលរកឃើញ៖ $language';
  }

  @override
  String get translateDisclaimer =>
      'ការបកប្រែដោយម៉ាស៊ីនអាចខកខានអត្ថន័យល្អិតល្អន់។ សូមពិនិត្យអត្ថបទសំខាន់ៗឡើងវិញ។';

  @override
  String get languageKhmer => 'ខ្មែរ';

  @override
  String get languageEnglish => 'អង់គ្លេស';

  @override
  String get writingTitle => 'ជំនួយការសរសេរ';

  @override
  String get writingInputHint => 'បិទភ្ជាប់ ឬសរសេរអត្ថបទរបស់អ្នក';

  @override
  String get writingOutputLabel => 'សេចក្ដីព្រាង';

  @override
  String get writingOutputPlaceholder => 'អត្ថបទដែលកែលម្អរួចនឹងបង្ហាញនៅទីនេះ។';

  @override
  String get writingGenerate => 'បង្កើត';

  @override
  String get writingOutputNotice =>
      'អត្ថបទនេះជាសេចក្ដីព្រាង។ សូមពិនិត្យមុននឹងផ្ញើទៅណាមួយ។';

  @override
  String get writingEditHint => 'អ្នកអាចកែសេចក្ដីព្រាងមុនពេលចម្លង។';

  @override
  String get writingTargetLanguage => 'ភាសាលទ្ធផល';

  @override
  String get writingTone => 'សម្លេងអត្ថបទ';

  @override
  String get writingToneNeutral => 'ធម្មតា';

  @override
  String get writingToneProfessional => 'វិជ្ជាជីវៈ';

  @override
  String get writingToneFriendly => 'រួសរាយរាក់ទង';

  @override
  String get writingToneCasual => 'សាមញ្ញ';

  @override
  String get writingTopicHint => 'តើចង់សរសេរអំពីអ្វី?';

  @override
  String get writingActionImprove => 'កែលម្អការសរសេរ';

  @override
  String get writingActionFixGrammar => 'កែវេយ្យាករណ៍ និងអក្ខរាវិរុទ្ធ';

  @override
  String get writingActionProfessional => 'ធ្វើឱ្យមានលក្ខណៈវិជ្ជាជីវៈ';

  @override
  String get writingActionFriendly => 'ធ្វើឱ្យរួសរាយរាក់ទង';

  @override
  String get writingActionShorten => 'ធ្វើឱ្យខ្លី';

  @override
  String get writingActionExpand => 'ពន្លាតបន្ថែម';

  @override
  String get writingActionDraftMessage => 'ព្រាងសារ';

  @override
  String get writingActionDraftJobApplication => 'ព្រាងអ៊ីមែលស្នើសុំការងារ';

  @override
  String get summarizeTitle => 'សង្ខេបអត្ថបទ';

  @override
  String get summarizeInputHint => 'បិទភ្ជាប់អត្ថបទដែលត្រូវសង្ខេប';

  @override
  String get summarizeAction => 'សង្ខេប';

  @override
  String get summarizeStyle => 'រចនាប័ទ្មសង្ខេប';

  @override
  String get summarizeStyleShort => 'ខ្លី';

  @override
  String get summarizeStyleDetailed => 'លម្អិត';

  @override
  String get summarizeStyleBullets => 'ចំណុចរាយ';

  @override
  String get summarizeOutputLabel => 'សេចក្ដីសង្ខេប';

  @override
  String get summarizeOutputPlaceholder => 'សេចក្ដីសង្ខេបនឹងបង្ហាញនៅទីនេះ។';

  @override
  String get summarizeInputRequired => 'សូមបញ្ចូលអត្ថបទជាមុនសិន។';

  @override
  String summarizeInputTooLong(int limit) {
    return 'អត្ថបទវែងពេក។ សូមឱ្យក្រោម $limit តួអក្សរ។';
  }

  @override
  String summarizeCounter(int used, int limit) {
    return '$used / $limit តួអក្សរ';
  }

  @override
  String get englishTitle => 'រៀនភាសាអង់គ្លេស';

  @override
  String get englishInputHint => 'បញ្ចូលពាក្យ ឃ្លា ឬប្រយោគអង់គ្លេស';

  @override
  String get englishAction => 'ពន្យល់ជាភាសាខ្មែរ';

  @override
  String get englishOutputLabel => 'ការពន្យល់';

  @override
  String get englishOutputPlaceholder =>
      'ការពន្យល់ជាភាសាខ្មែរ ព្រមទាំងឧទាហរណ៍ នឹងបង្ហាញនៅទីនេះ។';

  @override
  String get englishExamplesTitle => 'ឧទាហរណ៍';

  @override
  String get errorNetwork =>
      'គ្មានការតភ្ជាប់អ៊ីនធឺណិតទេ។ សូមពិនិត្យបណ្ដាញ រួចព្យាយាមម្ដងទៀត។';

  @override
  String get errorTimeout => 'សំណើចំណាយពេលយូរពេក។ សូមព្យាយាមម្ដងទៀត។';

  @override
  String get errorUnauthorized =>
      'គណនីមិនត្រូវបានអនុញ្ញាតទេ។ សូមពិនិត្យ access token ក្នុងការកំណត់។';

  @override
  String get errorRateLimited =>
      'មានសំណើច្រើនពេកក្នុងពេលនេះ។ សូមរង់ចាំបន្តិច រួចព្យាយាមម្ដងទៀត។';

  @override
  String get errorProvider =>
      'សេវា AI មិនអាចឆ្លើយសំណើនេះបានទេ។ សូមព្យាយាមម្ដងទៀត។';

  @override
  String get errorInvalidResponse =>
      'សេវា AI បានផ្ដល់ចម្លើយមិនត្រឹមត្រូវតាមទម្រង់។';

  @override
  String get errorInputTooLarge =>
      'អត្ថបទបញ្ចូលវែងពេក។ សូមបន្ថយ រួចព្យាយាមម្ដងទៀត។';

  @override
  String get errorQuotaExceeded =>
      'អ្នកបានប្រើអស់ចំនួនសំណួរឥតគិតថ្លៃសម្រាប់ពេលនេះ។ សូមព្យាយាមម្ដងទៀតនៅពេលក្រោយ។';

  @override
  String get errorServer =>
      'សេវាមិនអាចប្រើប្រាស់ជាបណ្ដោះអាសន្ន។ សូមព្យាយាមម្ដងទៀតនៅពេលក្រោយ។';

  @override
  String get errorUnknown => 'មានបញ្ហាកើតឡើង។ សូមព្យាយាមម្ដងទៀត។';

  @override
  String get errorMisconfigured =>
      'កម្មវិធីមិនទាន់កំណត់អាសយដ្ឋានម៉ាស៊ីន AI ទេ។';

  @override
  String get errorCancelled => 'សំណើត្រូវបានបោះបង់។';

  @override
  String get errorInvalidInput => 'សូមបញ្ចូលអត្ថបទជាមុនសិន។';

  @override
  String get actionRetry => 'ព្យាយាមម្ដងទៀត';

  @override
  String get actionCopy => 'ចម្លង';

  @override
  String get actionCopied => 'បានចម្លង';

  @override
  String get actionClear => 'សម្អាត';

  @override
  String get actionCancel => 'បោះបង់';

  @override
  String get actionSave => 'រក្សាទុក';

  @override
  String get actionDelete => 'លុប';

  @override
  String get actionClose => 'បិទ';

  @override
  String get actionTryAgain => 'ព្យាយាមម្ដងទៀត';

  @override
  String get settingsTitle => 'ការកំណត់';

  @override
  String get settingsInterfaceLanguage => 'ភាសាប្រើប្រាស់ក្នុងកម្មវិធី';

  @override
  String get settingsLanguageSystem => 'តាមប្រព័ន្ធ';

  @override
  String get settingsAppearance => 'រូបរាង';

  @override
  String get settingsThemeSystem => 'តាមប្រព័ន្ធ';

  @override
  String get settingsThemeLight => 'ភ្លឺ';

  @override
  String get settingsThemeDark => 'ងងឹត';

  @override
  String get settingsUsageTitle => 'ការប្រើប្រាស់ AI';

  @override
  String get settingsUsageUnavailable =>
      'កំណែនេះមិនមានទិន្នន័យប្រើប្រាស់ពីម៉ាស៊ីនមេទេ។';

  @override
  String settingsUsageInputTokens(int count) {
    return 'ថូខឹនបញ្ចូល៖ $count';
  }

  @override
  String settingsUsageOutputTokens(int count) {
    return 'ថូខឹនបញ្ចេញ៖ $count';
  }

  @override
  String get settingsServerMode => 'របៀបភ្ជាប់ម៉ាស៊ីនមេ';

  @override
  String get settingsServerLive => 'បានភ្ជាប់ទៅម៉ាស៊ីនមេ AI ពិតប្រាកដ';

  @override
  String get settingsServerDemo => 'របៀបសាកល្បង (ចម្លើយគំរូក្នុងកម្មវិធី)';

  @override
  String get settingsServerMissing => 'មិនទាន់កំណត់ម៉ាស៊ីនមេ AI ទេ';

  @override
  String get settingsPrivacyTitle => 'ភាពឯកជន';

  @override
  String get settingsPrivacyBody =>
      'សន្ទនារក្សាទុកក្នុងឧបករណ៍នេះតែប៉ុណ្ណោះ។ អត្ថបទដែលអ្នកផ្ញើ ត្រូវបញ្ជូនទៅម៉ាស៊ីនមេ AI ដែលអ្នកកំណត់ ដើម្បីបង្កើតចម្លើយ។ សូមមិនបញ្ចូលព័ត៌មានសម្ងាត់ ឬទិន្នន័យផ្ទាល់ខ្លួនរសើប។';

  @override
  String get settingsDataTitle => 'ទិន្នន័យ';

  @override
  String get settingsClearHistory => 'សម្អាតប្រវត្តិសន្ទនាក្នុងឧបករណ៍';

  @override
  String get settingsClearHistoryBody =>
      'សន្ទនាទាំងអស់ដែលរក្សាទុកក្នុងឧបករណ៍នេះនឹងត្រូវលុប។ មិនអាចត្រឡប់វិញបានទេ។';

  @override
  String get settingsAdvancedTitle => 'កម្រិតខ្ពស់';

  @override
  String get settingsAccessToken => 'Access token';

  @override
  String get settingsAccessTokenHint =>
      'Token ស្រេចចិត្ត សម្រាប់ផ្ញើទៅម៉ាស៊ីនមេ AI ផ្ទាល់ខ្លួន';

  @override
  String get settingsAccessTokenHelp =>
      'រក្សាទុកក្នុង secure storage របស់ឧបករណ៍។ ទុកទទេ បើម៉ាស៊ីនមេមិនត្រូវការ។';

  @override
  String get settingsAccessTokenSaved => 'បានរក្សាទុក access token';

  @override
  String get settingsAccessTokenCleared => 'បានលុប access token';

  @override
  String get settingsAboutTitle => 'អំពីកម្មវិធី';

  @override
  String settingsVersion(String version) {
    return 'កំណែ $version';
  }

  @override
  String get settingsClearHistoryDone => 'បានសម្អាតប្រវត្តិសន្ទនា';

  @override
  String get offlineBanner =>
      'អ្នកកំពុងនៅក្រៅបណ្ដាញ។ មុខងារខ្លះនឹងមិនដំណើរការទេ។';

  @override
  String a11yQuickAction(String feature) {
    return 'បើក $feature';
  }

  @override
  String get a11ySendButton => 'ផ្ញើសារ';

  @override
  String get a11yStopButton => 'បញ្ឈប់ការបង្កើតអត្ថបទ';

  @override
  String get a11yCopyButton => 'ចម្លងទៅក្ដារតម្បាល់';

  @override
  String a11yDeleteConversation(String title) {
    return 'លុបសន្ទនា $title';
  }

  @override
  String get a11ySwapLanguages => 'ប្ដូរភាសាដើម និងភាសាគោលដៅ';

  @override
  String a11yThemeOption(String theme) {
    return 'រូបរាង $theme';
  }

  @override
  String a11yLanguageOption(String language) {
    return 'ភាសាប្រើប្រាស់ក្នុងកម្មវិធី $language';
  }

  @override
  String get featureChat => 'សន្ទនា';

  @override
  String get featureChatSubtitle => 'សួរអ្វីក៏បាន ទទួលចម្លើយជាភាសាខ្មែរ';

  @override
  String get featureTranslate => 'បកប្រែ';

  @override
  String get featureTranslateSubtitle => 'ខ្មែរ និងអង់គ្លេស ទាំងពីរទិស';

  @override
  String get featureWriting => 'ការសរសេរ';

  @override
  String get featureWritingSubtitle => 'កែលម្អ សរសេរឡើងវិញ ព្រាងសារ';

  @override
  String get featureSummarize => 'សង្ខេប';

  @override
  String get featureSummarizeSubtitle => 'បំប្លែងអត្ថបទវែងជាចំណុចសំខាន់';

  @override
  String get featureEnglish => 'រៀនអង់គ្លេស';

  @override
  String get featureEnglishSubtitle => 'ពាក្យអង់គ្លេស ពន្យល់ជាខ្មែរ';
}
