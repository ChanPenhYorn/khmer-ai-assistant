import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_providers.g.dart';

/// Emits `true` while the device reports no active network interface.
///
/// This reports link state, not reachability: a connected network can still
/// fail to reach the AI server, which the app surfaces as a network failure
/// from the request itself. The banner is therefore worded as a warning.
@Riverpod(keepAlive: true)
Stream<bool> offline(Ref ref) async* {
  final connectivity = Connectivity();

  bool isOffline(List<ConnectivityResult> results) =>
      results.isEmpty || results.every((r) => r == ConnectivityResult.none);

  try {
    yield isOffline(await connectivity.checkConnectivity());
    yield* connectivity.onConnectivityChanged.map(isOffline);
  } catch (_) {
    // Platforms without connectivity support simply never report offline.
    yield false;
  }
}
