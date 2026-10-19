import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/app/router/app_routes.dart';
import 'package:khmer_ai_assistant/core/constants/app_constants.dart';
import 'package:khmer_ai_assistant/core/widgets/app_text_field.dart';
import 'package:khmer_ai_assistant/core/widgets/content_width.dart';
import 'package:khmer_ai_assistant/core/widgets/output_card.dart';
import 'package:khmer_ai_assistant/core/widgets/tool_panes.dart';

import '../helpers/test_harness.dart';

/// Resizes the test surface and rebuilds the app.
Future<void> _resize(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pump();
}

void main() {
  testWidgets('compact windows keep the bottom navigation bar', (tester) async {
    await pumpAppWithFake(tester);
    await _resize(tester, const Size(420, 2000));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('wide windows swap the bar for a navigation rail', (
    tester,
  ) async {
    await pumpAppWithFake(tester);
    await _resize(tester, const Size(1200, 900));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('a tool screen stacks its panes on a compact window', (
    tester,
  ) async {
    await pumpAppWithFake(tester, location: AppRoutes.translate);
    await _resize(tester, const Size(420, 2000));

    expect(find.byType(ToolPanes), findsOneWidget);
    expect(find.byType(AppTextField), findsOneWidget);
    expect(find.byType(OutputCard), findsOneWidget);
    // Stacked: the result sits below the input, not beside it.
    expect(
      tester.getTopLeft(find.byType(OutputCard)).dy,
      greaterThan(tester.getTopLeft(find.byType(AppTextField)).dy),
    );
  });

  testWidgets('a tool screen places its panes side by side when wide', (
    tester,
  ) async {
    await pumpAppWithFake(tester, location: AppRoutes.translate);
    await _resize(tester, const Size(1200, 900));

    expect(find.byType(ToolPanes), findsOneWidget);
    // Side by side: the result starts to the right of the input.
    expect(
      tester.getTopLeft(find.byType(OutputCard)).dx,
      greaterThan(tester.getTopRight(find.byType(AppTextField)).dx),
    );
  });

  testWidgets('ContentWidth caps the column on wide windows only', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ContentWidth(
            padding: EdgeInsets.zero,
            child: SizedBox.expand(key: ValueKey('content')),
          ),
        ),
      ),
    );
    await _resize(tester, const Size(1400, 800));
    expect(
      tester.getSize(find.byKey(const ValueKey('content'))).width,
      AppConstants.contentMaxWidth,
    );

    await _resize(tester, const Size(360, 800));
    expect(tester.getSize(find.byKey(const ValueKey('content'))).width, 360);
  });
}
