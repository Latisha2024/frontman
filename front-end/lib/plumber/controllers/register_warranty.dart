// lib/plumber/controllers/register_warranty.dart
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _resolveBaseUrl() {
  const lanIpForPhysicalDevice = '';
  if (lanIpForPhysicalDevice.isNotEmpty) return lanIpForPhysicalDevice;
  return 'https://frontman-1.onrender.com';
}

class PlumberRegisterWarrantyController extends ChangeNotifier {
  final productIdController = TextEditingController();
  final serialNumberController = TextEditingController();
  final purchaseDateController = TextEditingController(); // YYYY-MM-DD
  final warrantyMonthsController = TextEditingController();
  final sellerIdController = TextEditingController();

  bool isLoading = false;
  String? error;
  bool? success;

  String? qrCodeData;

  late final Dio _dio;

  PlumberRegisterWarrantyController() {
    _dio = Dio(BaseOptions(
      baseUrl: _resolveBaseUrl(),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
    ));
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? prefs.getString('jwt_token');
  }

  Future<void> submitWarranty() async {
    isLoading = true;
    error = null;
    success = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token missing.');
      }

      final payload = {
        'productId': productIdController.text.trim(),
        'serialNumber': serialNumberController.text.trim(),
        'purchaseDate': purchaseDateController.text.trim(),
        'warrantyMonths':
            int.tryParse(warrantyMonthsController.text.trim()) ?? 0,
      };

      final response = await _dio.post(
        '/user/warranty/register',
        data: jsonEncode(payload),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201) {
        success = true;
        qrCodeData = generateQrDataFromForm();
      } else {
        error =
            'Failed to register warranty. Server responded: ${response.statusCode}';
        success = false;
      }
    } catch (e) {
      error = 'Unexpected error: $e';
      success = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String generateQrDataFromForm() {
    final payload = {
      'productId': productIdController.text.trim(),
      'serialNumber': serialNumberController.text.trim(),
      'purchaseDate': purchaseDateController.text.trim(),
      'warrantyMonths': int.tryParse(warrantyMonthsController.text.trim()) ?? 0,
    };
    return jsonEncode(payload);
  }

  @override
  void dispose() {
    productIdController.dispose();
    serialNumberController.dispose();
    purchaseDateController.dispose();
    warrantyMonthsController.dispose();
    sellerIdController.dispose();
    super.dispose();
  }
}
