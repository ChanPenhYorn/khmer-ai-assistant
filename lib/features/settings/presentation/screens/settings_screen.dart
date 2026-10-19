import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/config/ai_config.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/app_providers.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/dio_providers.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../core/widgets/content_width.dart';
import '../../../../core/widgets/info_banner.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../ai/presentation/providers/ai_usage_provider.dart';
import '../../../chat/presentation/providers/chat_providers.dart';
import '../../domain/entities/app_settings.dart';
import '../providers/settings_providers.dart';

/// Settings: language, appearance, usage, privacy, data and advanced options.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsControllerProvider);
    final settingsController = ref.read(settingsControllerProvider.notifier);
    final config = ref.watch(aiConfigProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: ContentWidth(
          padding: EdgeInsets.zero,
          child: ListView(
            padding: const EdgeInsets.all(AppConstants.spaceMd),
            children: [
              SectionHeader(title: l10n.settingsInterfaceLanguage),
              _LanguageTile(
                settings: settings,
                onChanged: settingsController.setLocaleCode,
              ),
              SectionHeader(title: l10n.settingsAppearance),
              _ThemeTile(
                settings: settings,
                onChanged: settingsController.setThemeMode,
              ),
              SectionHeader(title: l10n.settingsUsageTitle),
              const _UsageTile(),
              SectionHeader(title: l10n.settingsServerMode),
              _ServerModeTile(config: config),
              SectionHeader(title: l10n.settingsPrivacyTitle),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spaceMd),
                  child: Text(
                    l10n.settingsPrivacyBody,
                    style: context.texts.bodyMedium,
                  ),
                ),
              ),
              SectionHeader(title: l10n.settingsDataTitle),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.delete_sweep_outlined),
                  title: Text(l10n.settingsClearHistory),
                  subtitle: Text(l10n.settingsClearHistoryBody),
                  onTap: () => _clearHistory(context),
                ),
              ),
              SectionHeader(title: l10n.settingsAdvancedTitle),
              const _AccessTokenCard(),
              SectionHeader(title: l10n.settingsAboutTitle),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text(AppConfig.appName),
                      subtitle: Text(l10n.appTagline),
                    ),
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        final version = snapshot.hasData
                            ? '${snapshot.data!.version}+${snapshot.data!.buildNumber}'
                            : AppConfig.version;
                        return ListTile(
                          leading: const Icon(Icons.tag),
                          title: Text(l10n.settingsVersion(version)),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spaceXl),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _clearHistory(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsClearHistory),
        content: Text(l10n.settingsClearHistoryBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.actionDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await ref.read(chatRepositoryProvider).clearAll();
    ref.invalidate(conversationListProvider);
    if (!context.mounted) return;
    context.showSnack(l10n.settingsClearHistoryDone);
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.settings, required this.onChanged});

  final AppSettings settings;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceMd),
        child: DropdownButtonFormField<String?>(
          initialValue: settings.localeCode,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: l10n.settingsInterfaceLanguage,
          ),
          items: [
            DropdownMenuItem(child: Text(l10n.settingsLanguageSystem)),
            DropdownMenuItem(
              value: AppConstants.kmLanguageCode,
              child: Text(l10n.languageKhmer),
            ),
            DropdownMenuItem(
              value: AppConstants.enLanguageCode,
              child: Text(l10n.languageEnglish),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({required this.settings, required this.onChanged});

  final AppSettings settings;
  final ValueChanged<AppThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceMd),
        child: OptionChips<AppThemeMode>(
          options: AppThemeMode.values,
          selected: settings.themeMode,
          onSelected: onChanged,
          labelOf: (context, mode) => switch (mode) {
            AppThemeMode.system => context.l10n.settingsThemeSystem,
            AppThemeMode.light => context.l10n.settingsThemeLight,
            AppThemeMode.dark => context.l10n.settingsThemeDark,
          },
        ),
      ),
    );
  }
}

class _UsageTile extends ConsumerWidget {
  const _UsageTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final usage = ref.watch(aiUsageControllerProvider);

    final lines = <String>[
      if (usage.remainingRequests != null)
        l10n.quotaRemaining(usage.remainingRequests!),
      if (usage.inputTokens != null)
        l10n.settingsUsageInputTokens(usage.inputTokens!),
      if (usage.outputTokens != null)
        l10n.settingsUsageOutputTokens(usage.outputTokens!),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lines.isEmpty)
              Text(
                l10n.settingsUsageUnavailable,
                style: context.texts.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              )
            else
              for (final line in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppConstants.spaceXs),
                  child: Text(line, style: context.texts.bodyMedium),
                ),
          ],
        ),
      ),
    );
  }
}

class _ServerModeTile extends StatelessWidget {
  const _ServerModeTile({required this.config});

  final AiConfig config;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final (
      String text,
      InfoBannerTone tone,
      IconData icon,
    ) = config.useMockDataSource
        ? (l10n.settingsServerDemo, InfoBannerTone.info, Icons.science_outlined)
        : config.hasRemoteEndpoint
        ? (
            l10n.settingsServerLive,
            InfoBannerTone.info,
            Icons.cloud_done_outlined,
          )
        : (
            l10n.settingsServerMissing,
            InfoBannerTone.warning,
            Icons.cloud_off_outlined,
          );

    return InfoBanner(
      title: text,
      message: config.hasRemoteEndpoint
          ? config.baseUrl
          : l10n.errorMisconfigured,
      icon: icon,
      tone: tone,
    );
  }
}

class _AccessTokenCard extends ConsumerStatefulWidget {
  const _AccessTokenCard();

  @override
  ConsumerState<_AccessTokenCard> createState() => _AccessTokenCardState();
}

class _AccessTokenCardState extends ConsumerState<_AccessTokenCard> {
  final TextEditingController _controller = TextEditingController();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final token = await ref.read(authTokenStoreProvider).read();
    if (!mounted) return;
    setState(() {
      _controller.text = token ?? '';
      _loaded = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              enabled: _loaded,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: l10n.settingsAccessToken,
                hintText: l10n.settingsAccessTokenHint,
                helperText: l10n.settingsAccessTokenHelp,
                helperMaxLines: 3,
              ),
            ),
            const SizedBox(height: AppConstants.spaceSm),
            Row(
              children: [
                FilledButton(
                  onPressed: _loaded ? _save : null,
                  child: Text(l10n.actionSave),
                ),
                const SizedBox(width: AppConstants.spaceSm),
                TextButton(
                  onPressed: _loaded ? _clear : null,
                  child: Text(l10n.actionClear),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    await ref.read(authTokenStoreProvider).write(_controller.text);
    if (!mounted) return;
    context.showSnack(context.l10n.settingsAccessTokenSaved);
  }

  Future<void> _clear() async {
    await ref.read(authTokenStoreProvider).clear();
    if (!mounted) return;
    _controller.clear();
    context.showSnack(context.l10n.settingsAccessTokenCleared);
  }
}
