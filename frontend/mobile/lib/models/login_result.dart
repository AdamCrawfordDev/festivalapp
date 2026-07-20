import 'auth_user.dart';

class LoginResult {
  const LoginResult({
    required this.token,
    required this.user,
  });

  final String token;
  final AuthUser user;

  factory LoginResult.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginResult(
      token: json['token'] as String,
      user: AuthUser.fromJson(
        Map<String, dynamic>.from(
          json['user'] as Map,
        ),
      ),
    );
  }
}