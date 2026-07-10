import 'package:employee_app/core/constant/api_exception.dart';

class AuthService {
  Future<LoginResponse> requestLogin(String identity, String password) async {
    final normalizedIdentity = identity.trim();

    if (normalizedIdentity.isEmpty || password.isEmpty) {
      throw ApiException.validationError({
        'identity': normalizedIdentity.isEmpty ? ['Identity is required.'] : <String>[],
        'password': password.isEmpty ? ['Password is required.'] : <String>[],
      });
    }

    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (normalizedIdentity == 'demo' && password == 'demo123') {
      return const LoginResponse(200);
    }

    throw ApiException.unauthorized('Use demo / demo123 to try the app without the API.');
  }
}

class LoginResponse {
  final int statusCode;

  const LoginResponse(this.statusCode);
}