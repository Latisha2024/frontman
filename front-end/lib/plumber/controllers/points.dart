import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlumberPointsController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  List<dynamic>? points;

  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://frontman-backend-2.onrender.com/'));
  // 👆 Use 10.0.2.2 if running on Android emulator, change to your LAN IP for device testing

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    // 👇 Match the key you used when saving token at login
    return prefs.getString('auth_token') ?? prefs.getString('jwt_token');
  }

  Future<void> fetchPoints() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('User not logged in');
      }

      final response = await _dio.get(
        '/user/points',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final data = response.data;

      if (data is List) {
        points = data;
        error = null;
      } else {
        points = [];
        error = 'No transactions found';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        error = e.response?.data['message'] ?? 'Failed to fetch points';
      } else {
        error = 'Network error: ${e.message}';
      }
      points = [];
    } catch (e) {
      error = 'Unexpected error: $e';
      points = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
