import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat/presentation/providers/chat_providers.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/chat/presentation/screens/conversation_history_screen.dart';
import '../../features/english/presentation/screens/english_learning_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/summarization/presentation/screens/summarize_screen.dart';
import '../../features/translation/presentation/screens/translation_screen.dart';
import '../../features/writing/presentation/screens/writing_screen.dart';
import '../shell/app_shell.dart';
import 'app_routes.dart';

/// Root navigator key: tool screens are pushed above the bottom navigation.
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Application router.
///
/// The four primary destinations live in a stateful shell so their state is
/// preserved when switching tabs. The focused tools (translate, writing,
/// summarize, English) open full screen with a back button.
GoRouter createRouter({String initialLocation = AppRoutes.home}) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: initialLocation,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.chat,
                builder: (context, state) =>
                    const ChatScreen(conversationId: newConversationId),
                routes: [
                  GoRoute(
                    path: ':conversationId',
                    builder: (context, state) => ChatScreen(
                      conversationId:
                          state.pathParameters['conversationId'] ??
                          newConversationId,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                builder: (context, state) => const ConversationHistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.translate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TranslationScreen(),
      ),
      GoRoute(
        path: AppRoutes.writing,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const WritingScreen(),
      ),
      GoRoute(
        path: AppRoutes.summarize,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SummarizeScreen(),
      ),
      GoRoute(
        path: AppRoutes.english,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EnglishLearningScreen(),
      ),
    ],
    errorBuilder: (context, state) =>
        _RouteNotFoundScreen(location: state.uri.toString()),
  );
}

class _RouteNotFoundScreen extends StatelessWidget {
  const _RouteNotFoundScreen({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.explore_off_outlined, size: 40),
              const SizedBox(height: 16),
              Text(
                location,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go(AppRoutes.home),
                child: Text(
                  MaterialLocalizations.of(context).backButtonTooltip,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
