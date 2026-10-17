import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/settings/presentation/providers/settings_providers.dart';
import 'localization/generated/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// Root widget: localization, theme and routing.
class KhmerAiApp extends ConsumerStatefulWidget {
  const KhmerAiApp({super.key, this.initialLocation});

  /// Used by tests to start on a specific route.
  final String? initialLocation;

  @override
  ConsumerState<KhmerAiApp> createState() => _KhmerAiAppState();
}

class _KhmerAiAppState extends ConsumerState<KhmerAiApp> {
  late final GoRouter _router = createRouter(
    initialLocation: widget.initialLocation ?? '/',
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(appLocaleProvider);
    final themeMode = ref.watch(appThemeModeProvider).themeMode;

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
    );
  }
}
