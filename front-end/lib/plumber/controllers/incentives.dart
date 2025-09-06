import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlumberIncentivesController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  List<dynamic>? incentives;

  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://frontman-backend-2.onrender.com/'));

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // ✅ use the same key from login
  }

  Future<void> fetchIncentives() async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      error = 'Not logged in';
      incentives = [];
      notifyListeners();
      return;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _dio.get(
        '/user/incentives', // ✅ matches backend route
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final data = response.data;

      if (data is List && data.isNotEmpty) {
        incentives = data;
        error = null;
      } else {
        incentives = [];
        error = 'No incentives assigned';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        error = e.response?.data['message'] ?? 'Server error';
      } else {
        error = 'Network error: ${e.message}';
      }
      incentives = [];
    } catch (e) {
      error = 'Unexpected error: $e';
      incentives = [];
    }

    isLoading = false;
    notifyListeners();
  }
}
