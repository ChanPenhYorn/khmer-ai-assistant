import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/core/errors/app_failure.dart';
import 'package:khmer_ai_assistant/core/widgets/output_card.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_language.dart';
import 'package:khmer_ai_assistant/features/translation/presentation/screens/translation_screen.dart';

import '../helpers/fake_ai_data_source.dart';
import '../helpers/test_harness.dart';

/// Reads the text actually rendered in the result panel.
String outputText(WidgetTester tester) =>
    tester.widget<SelectableText>(find.byType(SelectableText)).data ?? '';

void main() {
  testWidgets('translating sends the detected source and chosen target', (
    tester,
  ) async {
    final fake = await pumpAppWithFake(
      tester,
      location: '/translate',
      dataSource: FakeAiDataSource(
        replyText: 'Good morning',
        detectedLanguage: 'km',
      ),
    );

    expect(find.byType(TranslationScreen), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'អរុណសួស្តី');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Translate'));
    await tester.pumpAndSettle();

    // Auto-detect resolves to Khmer locally; the default target is Khmer, so
    // the user sees English selected as the target.
    final request = fake.requests.single;
    expect(request.input, 'អរុណសួស្តី');
    expect(request.params['source'], 'km');
    expect(request.params['target'], 'km');
    expect(outputText(tester), 'Good morning');
  });

  testWidgets('the detected language is shown, not invented', (tester) async {
    await pumpAppWithFake(
      tester,
      location: '/translate',
      dataSource: FakeAiDataSource(
        replyText: 'Good morning',
        detectedLanguage: 'km',
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'អរុណសួស្តី');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Translate'));
    await tester.pumpAndSettle();

    expect(find.text('Detected language: Khmer'), findsOneWidget);
  });

  testWidgets('no detection line is shown when the server reports none', (
    tester,
  ) async {
    await pumpAppWithFake(
      tester,
      location: '/translate',
      dataSource: FakeAiDataSource(replyText: 'Good morning'),
    );

    await tester.enterText(find.byType(TextField).first, 'អរុណសួស្តី');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Translate'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Detected language:'), findsNothing);
  });

  testWidgets('an English source is detected for English input', (
    tester,
  ) async {
    final fake = await pumpAppWithFake(tester, location: '/translate');

    await tester.enterText(find.byType(TextField).first, 'Good morning');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Translate'));
    await tester.pumpAndSettle();

    expect(fake.requests.single.params['source'], 'en');
    expect(fake.requests.single.params['target'], 'km');
  });

  testWidgets('swapping puts the target on the source side', (tester) async {
    final fake = await pumpAppWithFake(tester, location: '/translate');

    await tester.enterText(find.byType(TextField).first, 'Good morning');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.swap_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Translate'));
    await tester.pumpAndSettle();

    expect(fake.requests.single.params['source'], 'km');
    expect(fake.requests.single.params['target'], 'en');
  });

  testWidgets('the source language can be chosen explicitly', (tester) async {
    final fake = await pumpAppWithFake(tester, location: '/translate');

    // The first selector is the source side.
    await tester.tap(find.byType(DropdownButtonFormField<AiLanguage>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'អរុណសួស្តី');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Translate'));
    await tester.pumpAndSettle();

    // The explicit choice wins over local detection.
    expect(fake.requests.single.params['source'], 'en');
  });

  testWidgets('translate stays disabled until something is typed', (
    tester,
  ) async {
    await pumpAppWithFake(tester, location: '/translate');

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Translate'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('a failure replaces the result with a retry action', (
    tester,
  ) async {
    await pumpAppWithFake(
      tester,
      location: '/translate',
      dataSource: FakeAiDataSource(completeFailure: const ProviderFailure()),
    );

    await tester.enterText(find.byType(TextField).first, 'hello');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Translate'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'The AI service could not answer this request. Please try again.',
      ),
      findsOneWidget,
    );
    expect(find.text('Retry'), findsOneWidget);
    expect(outputText(tester), 'The translation appears here.');
  });

  testWidgets('clearing the output empties the result panel', (tester) async {
    await pumpAppWithFake(
      tester,
      location: '/translate',
      dataSource: FakeAiDataSource(replyText: 'Good morning'),
    );

    await tester.enterText(find.byType(TextField).first, 'អរុណសួស្តី');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Translate'));
    await tester.pumpAndSettle();
    expect(outputText(tester), 'Good morning');

    await tester.tap(
      find.descendant(
        of: find.byType(OutputCard),
        matching: find.byIcon(Icons.backspace_outlined),
      ),
    );
    await tester.pumpAndSettle();

    expect(outputText(tester), 'The translation appears here.');
  });

  testWidgets('long Khmer output renders without overflowing', (tester) async {
    await pumpAppWithFake(
      tester,
      location: '/translate',
      dataSource: FakeAiDataSource(
        replyText: List<String>.filled(200, 'ការបកប្រែ').join(' '),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'hello');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Translate'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
