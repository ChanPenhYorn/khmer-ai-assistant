import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/context_extensions.dart';
import '../localization/generated/app_localizations.dart';
import '../router/app_routes.dart';

/// Navigation shell for the four primary destinations.
///
/// Phones and narrow windows use the bottom navigation bar. From
/// [AppConstants.breakpointMedium] the bar becomes a side rail so the content
/// column keeps its full height, and from [AppConstants.breakpointExpanded] the
/// rail shows labels next to the icons.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppConstants.breakpointMedium) {
          return _RailShell(
            navigationShell: navigationShell,
            extended: constraints.maxWidth >= AppConstants.breakpointExpanded,
          );
        }
        return _BarShell(navigationShell: navigationShell);
      },
    );
  }

  /// Convenience used by screens that need to select the chat tab directly.
  static void openChat(BuildContext context) => context.go(AppRoutes.chat);
}

/// Index of the chat destination, which the new-conversation action targets.
const int _chatIndex = 1;

/// Destinations shared by the bar and the rail.
List<NavigationDestination> _destinations(AppLocalizations l10n) => [
  NavigationDestination(
    icon: const Icon(Icons.home_outlined),
    selectedIcon: const Icon(Icons.home),
    label: l10n.navHome,
  ),
  NavigationDestination(
    icon: const Icon(Icons.forum_outlined),
    selectedIcon: const Icon(Icons.forum),
    label: l10n.navChat,
  ),
  NavigationDestination(
    icon: const Icon(Icons.history_outlined),
    selectedIcon: const Icon(Icons.history),
    label: l10n.navHistory,
  ),
  NavigationDestination(
    icon: const Icon(Icons.settings_outlined),
    selectedIcon: const Icon(Icons.settings),
    label: l10n.navSettings,
  ),
];

class _BarShell extends StatelessWidget {
  const _BarShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final index = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      floatingActionButton: index == 0 || index == 2
          ? FloatingActionButton.extended(
              onPressed: () => navigationShell.goBranch(_chatIndex),
              icon: const Icon(Icons.add_comment_outlined),
              label: Text(l10n.chatNewConversation),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          // Tapping the active tab returns to its root.
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: _destinations(l10n),
      ),
    );
  }
}

class _RailShell extends StatelessWidget {
  const _RailShell({required this.navigationShell, required this.extended});

  final StatefulNavigationShell navigationShell;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final index = navigationShell.currentIndex;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: extended,
            minExtendedWidth: 208,
            labelType: extended
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.all,
            selectedIndex: index,
            onDestinationSelected: navigationShell.goBranch,
            leading: Padding(
              padding: const EdgeInsets.only(
                top: AppConstants.spaceSm,
                bottom: AppConstants.spaceMd,
              ),
              child: extended
                  ? FloatingActionButton.extended(
                      onPressed: () => navigationShell.goBranch(_chatIndex),
                      icon: const Icon(Icons.add_comment_outlined),
                      label: Text(l10n.chatNewConversation),
                    )
                  : FloatingActionButton(
                      onPressed: () => navigationShell.goBranch(_chatIndex),
                      tooltip: l10n.chatNewConversation,
                      child: const Icon(Icons.add_comment_outlined),
                    ),
            ),
            destinations: [
              for (final destination in _destinations(l10n))
                NavigationRailDestination(
                  icon: destination.icon,
                  selectedIcon: destination.selectedIcon ?? destination.icon,
                  label: Text(destination.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
