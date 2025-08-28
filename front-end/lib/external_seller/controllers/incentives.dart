import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../helpers/auth_service.dart'; // the AuthService file

class ExternalSellerIncentivesController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  List<dynamic>? incentives;

  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5000'));

  Future<void> fetchIncentives() async {
    final token = AuthService().token;
    if (token == null) {
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
        '/user/incentives',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      incentives = response.data; // list of incentives
      error = null;
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
