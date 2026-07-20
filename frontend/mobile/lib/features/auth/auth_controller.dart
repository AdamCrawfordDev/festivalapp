import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_client.dart';
import '../../api/auth_api.dart';
import '../../models/auth_user.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
}

class AuthState {
  const AuthState._({
    required this.status,
    this.user,
    this.errorMessage,
  });

  const AuthState.authenticated([
    AuthUser? user,
  ]) : this._(
          status: AuthStatus.authenticated,
          user: user,
        );

  const AuthState.unauthenticated({
    String? errorMessage,
  }) : this._(
          status: AuthStatus.unauthenticated,
          errorMessage: errorMessage,
        );

  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;

  bool get isAuthenticated {
    return status == AuthStatus.authenticated;
  }
}

class AuthController
    extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final storage = ref.read(
      authStorageProvider,
    );

    final token =
        await storage.readToken();

    if (
      token == null ||
      token.isEmpty
    ) {
      return const AuthState
          .unauthenticated();
    }

    /*
     * For now, a stored token is treated
     * as an authenticated session.
     *
     * Later, call a /me/ endpoint here
     * to verify that the token is still
     * valid and restore the user.
     */
    return const AuthState.authenticated();
  }

  Future<bool> login({
    required String login,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final result = await ref
          .read(authApiProvider)
          .login(
            login: login,
            password: password,
          );

      await ref
          .read(authStorageProvider)
          .saveToken(
            result.token,
          );

      state = AsyncData(
        AuthState.authenticated(
          result.user,
        ),
      );

      return true;
    } catch (
      error,
      stackTrace
    ) {
      state = AsyncError(
        error,
        stackTrace,
      );

      return false;
    }
  }

  Future<void> logout() async {
    try {
      await ref
          .read(authApiProvider)
          .logout();
    } catch (_) {
      /*
       * Still remove the local token
       * when the backend is unavailable.
       */
    }

    await ref
        .read(authStorageProvider)
        .deleteToken();

    state = const AsyncData(
      AuthState.unauthenticated(),
    );
  }
}

final authControllerProvider =
    AsyncNotifierProvider<
      AuthController,
      AuthState
    >(
      AuthController.new,
    );