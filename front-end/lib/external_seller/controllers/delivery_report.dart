import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../helpers/auth_service.dart'; // updated path

class ExternalSellerDeliveryReportController extends ChangeNotifier {
  final productController = TextEditingController();
  final quantityController = TextEditingController();
  bool qrRequested = false;

  bool isLoading = false;
  String? error;
  bool? success;

  final Dio _dio = Dio();

  Future<void> submitReport() async {
    isLoading = true;
    error = null;
    success = null;
    notifyListeners();

    try {
      final token = AuthService().token;
      if (token == null) {
        error = 'Not authenticated';
        success = false;
        isLoading = false;
        notifyListeners();
        return;
      }

      final response = await _dio.post(
        'http://localhost:5000/user/delivery-report',
        data: {
          'product': productController.text,
          'quantity': int.tryParse(quantityController.text) ?? 0,
          'qrRequested': qrRequested,
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
    } catch (e) {
      error = 'Error: $e';
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
