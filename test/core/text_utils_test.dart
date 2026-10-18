import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/core/utils/text_utils.dart';

void main() {
  group('TextUtils.containsKhmer', () {
    test('detects Khmer script', () {
      expect(TextUtils.containsKhmer('សូមស្វាគមន៍'), isTrue);
      expect(TextUtils.containsKhmer('Hello ខ្មែរ'), isTrue);
      expect(TextUtils.containsKhmer('Khmer AI Assistant'), isFalse);
      expect(TextUtils.containsKhmer('12345'), isFalse);
      expect(TextUtils.containsKhmer(''), isFalse);
    });

    test('detects Khmer symbols outside the main block', () {
      // U+19E0 KHMER SYMBOL PATHAMASAT starts the symbols block.
      expect(TextUtils.containsKhmer('\u19E0'), isTrue);
    });
  });

  group('TextUtils.detectLanguageCode', () {
    test('returns km for Khmer and en otherwise', () {
      expect(TextUtils.detectLanguageCode('សួស្តី'), 'km');
      expect(TextUtils.detectLanguageCode('Good morning'), 'en');
    });
  });

  group('TextUtils.titleFromMessage', () {
    test('keeps short messages intact', () {
      expect(TextUtils.titleFromMessage('Hello'), 'Hello');
    });

    test('collapses whitespace', () {
      expect(TextUtils.titleFromMessage('hello   \n  world'), 'hello world');
    });

    test('truncates long messages at a word boundary', () {
      final title = TextUtils.titleFromMessage(
        'this is a fairly long sentence that must be shortened for a list row',
        maxLength: 20,
      );
      expect(title.length, lessThanOrEqualTo(21));
      expect(title.endsWith('…'), isTrue);
      expect(title, startsWith('this is a fairly'));
    });

    test('handles long Khmer text without throwing', () {
      final khmer = 'ក' * 100;
      final title = TextUtils.titleFromMessage(khmer, maxLength: 20);
      expect(title.length, lessThanOrEqualTo(21));
    });

    test('returns an empty string for blank input', () {
      expect(TextUtils.titleFromMessage('   '), '');
    });
  });

  test('characterCount ignores surrounding whitespace', () {
    expect(TextUtils.characterCount('  abc  '), 3);
  });

  test('normalize collapses repeated spaces', () {
    expect(TextUtils.normalize('  a \t b '), 'a b');
  });
}
