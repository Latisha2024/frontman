// helpers/auth_service.dart
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  // Singleton pattern (optional, makes it easier to access globally)
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _token; // JWT token
  Map<String, dynamic>? _user; // user info from backend

  /// Set token and notify listeners
  void setToken(String token, [Map<String, dynamic>? user]) {
    _token = token;
    if (user != null) _user = user;
    notifyListeners();
  }

  /// Get token
  String? get token => _token;

  /// Get user info
  Map<String, dynamic>? get user => _user;

  /// Clear token (for logout)
  void clearToken() {
    _token = null;
    _user = null;
    notifyListeners();
  }

  /// Optional: check if logged in
  bool get isLoggedIn => _token != null;
}
