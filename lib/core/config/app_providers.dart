import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'ai_config.dart';

part 'app_providers.g.dart';

/// Active AI backend configuration.
///
/// Overridden in tests (and could be overridden by a future remote-config
/// feature) so nothing else has to read compile-time constants directly.
@Riverpod(keepAlive: true)
AiConfig aiConfig(Ref ref) => AiConfig.fromEnvironment();
