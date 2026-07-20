import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/auth_storage.dart';

const String apiBaseUrl =
    String.fromEnvironment(
  'API_BASE_URL',
  defaultValue:
      'http://10.0.2.2:8000/api',
);

final authStorageProvider =
    Provider<AuthStorage>((ref) {
  return AuthStorage();
});

final dioProvider =
    Provider<Dio>((ref) {
  final authStorage =
      ref.watch(authStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout:
          const Duration(seconds: 10),
      receiveTimeout:
          const Duration(seconds: 10),
      sendTimeout:
          const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type':
            'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (
        options,
        handler,
      ) async {
        final token =
            await authStorage.readToken();

        if (
          token != null &&
          token.isNotEmpty
        ) {
          options.headers[
            'Authorization'
          ] = 'Token $token';
        }

        handler.next(options);
      },
    ),
  );

  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: false,
      responseHeader: false,
    ),
  );

  return dio;
});