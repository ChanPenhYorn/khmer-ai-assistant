import 'dart:math';

/// Generates collision-resistant identifiers without a third-party package.
abstract final class IdGenerator {
  static final Random _random = Random.secure();

  /// 16 random bytes rendered as hex, optionally prefixed.
  static String nextId([String prefix = '']) {
    final buffer = StringBuffer(prefix);
    for (var i = 0; i < 16; i++) {
      buffer.write(_random.nextInt(256).toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}
