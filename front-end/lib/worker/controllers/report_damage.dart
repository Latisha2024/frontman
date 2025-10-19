import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class WorkerReportDamageController {
  final stockIdController = TextEditingController();
  final quantityController = TextEditingController();
  final locationController = TextEditingController();
  final reasonController = TextEditingController();

  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://frontman-1.onrender.com'),
  );

  void dispose() {
    stockIdController.dispose();
    quantityController.dispose();
    locationController.dispose();
    reasonController.dispose();
  }

  Future<Map<String, dynamic>> submitDamageReport() async {
    try {
      final token = await AuthService().getToken();

      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'No token found. Please login again.',
        };
      }

      final response = await _dio.post(
        '/worker/damage-report',
        data: {
          'stockId': stockIdController.text.trim(),
          'quantity': int.tryParse(quantityController.text.trim()) ?? 0,
          'location': locationController.text.trim(),
          'reason': reasonController.text.trim(),
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return {
        'success': true,
        'data': response.data,
      };
    } on DioException catch (err) {
      final errorData = err.response?.data;

      return {
        'success': false,
        'message': errorData is Map && errorData['error'] != null
            ? errorData['error'].toString()
            : err.message.toString(),
      };
    } catch (err) {
      return {
        'success': false,
        'message': err.toString(),
      };
    }
  }
}
