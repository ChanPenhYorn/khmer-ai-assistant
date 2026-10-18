import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/config/app_providers.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/connectivity_providers.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../core/widgets/feature_card.dart';
import '../../../../core/widgets/info_banner.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../ai/presentation/providers/ai_usage_provider.dart';
import '../../../chat/presentation/providers/chat_providers.dart';

/// Home screen: ask anything, plus shortcuts to the focused tools.
///
/// Deliberately sparse: one input, four tool cards, a few example prompts, and
/// honest status banners. No promotional filler and no fake statistics.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _askController = TextEditingController();

  @override
  void dispose() {
    _askController.dispose();
    super.dispose();
  }

  void _ask(String text) {
    final prompt = text.trim();
    if (prompt.isEmpty) {
      context.go(AppRoutes.chat);
      return;
    }
    ref.read(pendingPromptProvider.notifier).set(prompt);
    _askController.clear();
    context.go(AppRoutes.chat);
  }

  void _askSuggestion(String suggestion) {
    ref.read(pendingPromptProvider.notifier).set(suggestion);
    context.go(AppRoutes.chat);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final config = ref.watch(aiConfigProvider);
    final usage = ref.watch(aiUsageControllerProvider);
    final isOffline = ref.watch(offlineProvider).value ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.navSettings,
            onPressed: () => context.go(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spaceMd),
          children: [
            if (isOffline)
              Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.spaceMd),
                child: InfoBanner(
                  title: l10n.offlineBanner,
                  message: l10n.errorNetwork,
                  icon: Icons.wifi_off,
                  tone: InfoBannerTone.warning,
                ),
              ),
            if (config.useMockDataSource)
              Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.spaceMd),
                child: InfoBanner(
                  title: l10n.demoModeTitle,
                  message: l10n.demoModeBody,
                ),
              )
            else if (config.isMisconfigured)
              Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.spaceMd),
                child: InfoBanner(
                  title: l10n.settingsServerMissing,
                  message: l10n.errorMisconfigured,
                  icon: Icons.settings_suggest_outlined,
                  tone: InfoBannerTone.warning,
                ),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppConstants.spaceLg,
                AppConstants.spaceLg,
                AppConstants.spaceLg,
                AppConstants.spaceMd,
              ),
              decoration: BoxDecoration(
                color: context.colors.primaryContainer,
                borderRadius: BorderRadius.circular(AppConstants.radiusXl),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.homeGreeting, style: context.texts.headlineSmall),
                  const SizedBox(height: AppConstants.spaceSm),
                  Text(
                    l10n.homeSubtitle,
                    style: context.texts.bodyMedium?.copyWith(
                      color: context.colors.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceMd),
                  _AskAnythingField(
                    controller: _askController,
                    hint: l10n.homeAskHint,
                    semanticLabel: l10n.homeAskLabel,
                    onSubmitted: _ask,
                  ),
                ],
              ),
            ),
            if (usage.remainingRequests != null)
              Padding(
                padding: const EdgeInsets.only(top: AppConstants.spaceSm),
                child: Row(
                  children: [
                    Icon(
                      Icons.bolt_outlined,
                      size: 16,
                      color: context.colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppConstants.spaceXs),
                    Expanded(
                      child: Text(
                        l10n.quotaRemaining(usage.remainingRequests!),
                        style: context.texts.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SectionHeader(title: l10n.homeQuickActionsTitle),
            const SizedBox(height: AppConstants.spaceXs),
            _ToolGrid(onOpen: (route) => context.push(route)),
            SectionHeader(title: l10n.homeSuggestionsTitle),
            const SizedBox(height: AppConstants.spaceXs),
            Wrap(
              spacing: AppConstants.spaceSm,
              runSpacing: AppConstants.spaceSm,
              children: [
                for (final suggestion in <String>[
                  l10n.homeSuggestion1,
                  l10n.homeSuggestion2,
                  l10n.homeSuggestion3,
                  l10n.homeSuggestion4,
                ])
                  ActionChip(
                    avatar: const Icon(Icons.lightbulb_outline, size: 18),
                    label: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 280),
                      child: Text(
                        suggestion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    onPressed: () => _askSuggestion(suggestion),
                  ),
              ],
            ),
            const SizedBox(height: AppConstants.spaceXl),
          ],
        ),
      ),
    );
  }
}

/// Large single-line input with a send affordance.
class _AskAnythingField extends StatelessWidget {
  const _AskAnythingField({
    required this.controller,
    required this.hint,
    required this.semanticLabel,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final String semanticLabel;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final hasText = value.text.trim().isNotEmpty;
        return Semantics(
          textField: true,
          label: semanticLabel,
          child: TextField(
            controller: controller,
            minLines: 1,
            maxLines: 3,
            textInputAction: TextInputAction.go,
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: context.colors.surfaceContainerLowest,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spaceSm,
                vertical: AppConstants.spaceSm,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusXl),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusXl),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusXl),
                borderSide: BorderSide(
                  color: context.colors.primary,
                  width: 1.8,
                ),
              ),
              suffixIcon: IconButton.filled(
                tooltip: context.l10n.a11ySendButton,
                onPressed: () => onSubmitted(controller.text),
                icon: Icon(
                  hasText ? Icons.arrow_upward_rounded : Icons.forum_outlined,
                ),
              ),
            ),
            style: context.texts.bodyLarge,
          ),
        );
      },
    );
  }
}

/// Two-column grid of the focused tools; collapses to one column on narrow
/// screens and when the user has enlarged text.
class _ToolGrid extends StatelessWidget {
  const _ToolGrid({required this.onOpen});

  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cards = <Widget>[
      FeatureCard(
        icon: Icons.forum_outlined,
        title: l10n.featureChat,
        subtitle: l10n.featureChatSubtitle,
        onTap: () => context.go(AppRoutes.chat),
        semanticLabel: l10n.a11yQuickAction(l10n.featureChat),
      ),
      FeatureCard(
        icon: Icons.translate,
        title: l10n.featureTranslate,
        subtitle: l10n.featureTranslateSubtitle,
        onTap: () => onOpen(AppRoutes.translate),
        semanticLabel: l10n.a11yQuickAction(l10n.featureTranslate),
      ),
      FeatureCard(
        icon: Icons.edit_note,
        title: l10n.featureWriting,
        subtitle: l10n.featureWritingSubtitle,
        onTap: () => onOpen(AppRoutes.writing),
        semanticLabel: l10n.a11yQuickAction(l10n.featureWriting),
      ),
      FeatureCard(
        icon: Icons.summarize_outlined,
        title: l10n.featureSummarize,
        subtitle: l10n.featureSummarizeSubtitle,
        onTap: () => onOpen(AppRoutes.summarize),
        semanticLabel: l10n.a11yQuickAction(l10n.featureSummarize),
      ),
      FeatureCard(
        icon: Icons.school_outlined,
        title: l10n.featureEnglish,
        subtitle: l10n.featureEnglishSubtitle,
        onTap: () => onOpen(AppRoutes.english),
        semanticLabel: l10n.a11yQuickAction(l10n.featureEnglish),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth < 520 || context.usesLargeText)
            ? 1
            : 2;
        return GridView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: AppConstants.spaceSm,
            crossAxisSpacing: AppConstants.spaceSm,
            // Sized from the real text metrics rather than an aspect ratio,
            // so Khmer line heights and enlarged text are never clipped.
            mainAxisExtent: _cardExtent(context),
          ),
          children: cards,
        );
      },
    );
  }

  /// Fits two title lines plus two subtitle lines at the current text scale.
  static double _cardExtent(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final texts = context.texts;

    double twoLines(TextStyle? style, double fallbackSize) {
      final fontSize = scaler.scale(style?.fontSize ?? fallbackSize);
      return fontSize * (style?.height ?? 1.4) * 2;
    }

    return AppConstants.spaceMd * 2 + // card padding
        AppConstants.spaceXs * 2 + // card margin
        twoLines(texts.titleMedium, 17) +
        AppConstants.spaceXs + // gap between title and subtitle
        twoLines(texts.bodySmall, 13);
  }
}
