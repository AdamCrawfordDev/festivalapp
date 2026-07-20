import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/login_result.dart';
import 'api_client.dart';

class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<LoginResult> login({
    required String login,
    required String password,
  }) async {
    final response =
        await _dio.post<dynamic>(
      '/accounts/mobile/login/',
      data: {
        'login': login,
        'password': password,
      },
    );

    return LoginResult.fromJson(
      Map<String, dynamic>.from(
        response.data as Map,
      ),
    );
  }

  Future<void> logout() async {
    await _dio.post<void>(
      '/accounts/mobile/logout/',
    );
  }
}

final authApiProvider =
    Provider<AuthApi>((ref) {
  return AuthApi(
    ref.watch(dioProvider),
  );
});