import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../helpers/auth_service.dart';

class ExternalSellerPointsController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  dynamic points;

  Future<void> fetchPoints() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = AuthService().token;
      if (token == null) throw Exception('User not logged in');

      final dio = Dio(BaseOptions(
        baseUrl: 'http://localhost:5000/user/points',
        headers: {'Authorization': 'Bearer $token'},
      ));

      final response = await dio.get('');
      points = response.data;
      error = null;
    } on DioException catch (e) {
      error = e.response?.data['message'] ?? 'Failed to fetch points';
      points = null;
    } catch (e) {
      error = 'Unexpected error: $e';
      points = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
