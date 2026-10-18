import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_providers.dart';
import '../storage/auth_token_store.dart';
import '../storage/secure_auth_token_store.dart';

part 'dio_providers.g.dart';

/// Secure storage for the optional access token of the operator's endpoint.
@Riverpod(keepAlive: true)
AuthTokenStore authTokenStore(Ref ref) =>
    SecureAuthTokenStore()..invalidateCache();

/// HTTP client shared by every data source.
///
/// The client has no `baseUrl`: requests always use the absolute URI built from
/// configuration, which keeps accidental calls to unexpected hosts visible in
/// code review. No interceptor logs bodies, headers or tokens.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final config = ref.watch(aiConfigProvider);
  final tokenStore = ref.watch(authTokenStoreProvider);

  final client = Dio(
    BaseOptions(
      connectTimeout: config.requestTimeout,
      sendTimeout: config.requestTimeout,
      receiveTimeout: config.requestTimeout,
      headers: const {'Accept': 'application/json'},
    ),
  );

  client.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (options.uri.scheme != 'https' && options.uri.scheme != 'http') {
          handler.reject(
            DioException(
              requestOptions: options,
              error: 'unsupported scheme ${options.uri.scheme}',
            ),
          );
          return;
        }
        final token = await tokenStore.read();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ),
  );

  ref.onDispose(client.close);
  return client;
}
