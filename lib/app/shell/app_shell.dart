import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/context_extensions.dart';
import '../router/app_routes.dart';

/// Bottom-navigation shell for the four primary destinations.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: navigationShell,
      floatingActionButton:
          navigationShell.currentIndex == 0 || navigationShell.currentIndex == 2
          ? FloatingActionButton.extended(
              onPressed: () => context.go(AppRoutes.chat),
              icon: const Icon(Icons.add_comment_outlined),
              label: Text(l10n.chatNewConversation),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          // Tapping the active tab returns to its root.
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
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
        ],
      ),
    );
  }

  /// Convenience used by screens that need to select the chat tab directly.
  static void openChat(BuildContext context) => context.go(AppRoutes.chat);
}
