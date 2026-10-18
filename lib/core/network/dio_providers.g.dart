// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Secure storage for the optional access token of the operator's endpoint.

@ProviderFor(authTokenStore)
final authTokenStoreProvider = AuthTokenStoreProvider._();

/// Secure storage for the optional access token of the operator's endpoint.

final class AuthTokenStoreProvider
    extends $FunctionalProvider<AuthTokenStore, AuthTokenStore, AuthTokenStore>
    with $Provider<AuthTokenStore> {
  /// Secure storage for the optional access token of the operator's endpoint.
  AuthTokenStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authTokenStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authTokenStoreHash();

  @$internal
  @override
  $ProviderElement<AuthTokenStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthTokenStore create(Ref ref) {
    return authTokenStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthTokenStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthTokenStore>(value),
    );
  }
}

String _$authTokenStoreHash() => r'9d6b1cf177f52703ecad4d2142294416da7d99ad';

/// HTTP client shared by every data source.
///
/// The client has no `baseUrl`: requests always use the absolute URI built from
/// configuration, which keeps accidental calls to unexpected hosts visible in
/// code review. No interceptor logs bodies, headers or tokens.

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// HTTP client shared by every data source.
///
/// The client has no `baseUrl`: requests always use the absolute URI built from
/// configuration, which keeps accidental calls to unexpected hosts visible in
/// code review. No interceptor logs bodies, headers or tokens.

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// HTTP client shared by every data source.
  ///
  /// The client has no `baseUrl`: requests always use the absolute URI built from
  /// configuration, which keeps accidental calls to unexpected hosts visible in
  /// code review. No interceptor logs bodies, headers or tokens.
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'08888e24ad3ebdb811450ad0fe8ffcef4b12d918';
