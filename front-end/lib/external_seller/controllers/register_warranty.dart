import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../helpers/auth_service.dart';

class ExternalSellerRegisterWarrantyController extends ChangeNotifier {
  final productIdController = TextEditingController();
  final serialNumberController = TextEditingController();
  final purchaseDateController = TextEditingController();
  final warrantyMonthsController = TextEditingController();
  final sellerIdController = TextEditingController();

  bool isLoading = false;
  String? error;
  bool? success;
  String? qrCodeData;

  final Dio _dio = Dio();

  Future<void> submitWarranty() async {
    isLoading = true;
    error = null;
    success = null;
    qrCodeData = null;
    notifyListeners();

    try {
      final token = AuthService().token;
      if (token == null) {
        throw Exception("Authentication token missing.");
      }

      final response = await _dio.post(
        'http://localhost:5000/user/register-warranty',
        data: {
          'productId': productIdController.text,
          'serialNumber': serialNumberController.text,
          'purchaseDate': purchaseDateController.text,
          'warrantyMonths': int.tryParse(warrantyMonthsController.text) ?? 0,
          'sellerId': sellerIdController.text,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        final data = response.data is Map<String, dynamic>
            ? response.data
            : jsonDecode(response.data);

        success = true;
        qrCodeData = data['qrImage']; // backend must return qrImage field
      } else {
        error = response.data['message'] ?? 'Failed to register warranty';
        success = false;
      }
    } catch (e) {
      error = e.toString();
      success = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
