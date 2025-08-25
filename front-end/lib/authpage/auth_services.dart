import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _userRoleKey = 'user_role';
  static const _userNameKey = 'user_name';
  static const _userEmailKey = 'user_email';
  static const _userPhoneKey = 'user_phone';

  /// Save token & user details
  Future<void> setToken(String token, Map<String, dynamic> user) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_tokenKey, token);
  await prefs.setString(_userIdKey, user['_id'] ?? '');
  await prefs.setString(_userRoleKey, user['role'] ?? '');
  await prefs.setString(_userNameKey, user['name'] ?? '');
  await prefs.setString(_userEmailKey, user['email'] ?? '');
  await prefs.setString(_userPhoneKey, user['phone'] ?? '');

  print("✅ Token saved: $token");
  print("✅ User saved: $user");
}


  /// Get token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Get user role
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  /// Get full user object
  Future<Map<String, dynamic>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "_id": prefs.getString(_userIdKey),
      "role": prefs.getString(_userRoleKey),
      "name": prefs.getString(_userNameKey),
      "email": prefs.getString(_userEmailKey),
      "phone": prefs.getString(_userPhoneKey),
    };
  }

  /// Clear saved token & user data (logout)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
