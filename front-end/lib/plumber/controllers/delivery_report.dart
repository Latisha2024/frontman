import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlumberDeliveryReportController extends ChangeNotifier {
  final productController = TextEditingController();
  final quantityController = TextEditingController();

  bool isLoading = false;
  String? error;
  bool? success;

  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://frontman-backend-2.onrender.com/'));
  // 👆 Use 10.0.2.2 for Android emulator; replace with your LAN IP if testing on real device.

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? prefs.getString('jwt_token');
    debugPrint("🔑 Retrieved token: $token");
    return token;
  }

  Future<void> submitReport() async {
    isLoading = true;
    error = null;
    success = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        error = 'Not authenticated';
        success = false;
        isLoading = false;
        notifyListeners();
        return;
      }

      final response = await _dio.post(
        '/user/delivery-report',
        data: {
          'product': productController.text.trim(),
          'quantity': int.tryParse(quantityController.text) ?? 0,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        success = true;
      } else {
        error = response.data['message'] ?? 'Failed to submit report';
        success = false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        error = e.response?.data['message'] ?? 'Delivery report failed';
        debugPrint("❌ Server error: ${e.response?.data}");
      } else {
        error = 'Network error: ${e.message}';
        debugPrint("❌ Network error: ${e.message}");
      }
      success = false;
    } catch (e) {
      error = 'Unexpected error: $e';
      debugPrint("❌ Unexpected error: $e");
      success = false;
    }

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    productController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}
