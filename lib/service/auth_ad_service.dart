import 'package:aad_oauth/aad_oauth.dart';

class AuthService {
  final AadOAuth oAuth;

  AuthService({required this.oAuth});

  Future<String?> getAccessToken() async {
    try {
      final result = await oAuth.getAccessToken();
      return result;
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }

  Future<bool> login() async {
    try {
      final result = await oAuth.login();
      // ignore: unnecessary_null_comparison
      return result != null;
    } catch (e) {
      print("Error logging in: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await oAuth.logout();
  }
}
