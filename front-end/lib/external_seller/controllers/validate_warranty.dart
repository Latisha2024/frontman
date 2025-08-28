import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:dio/dio.dart';
import '../../../helpers/auth_service.dart';
import '../models/validate_warranty.dart';

class ValidateWarrantyController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  WarrantyInfo? warrantyInfo;
  bool? isVerified;

  final Dio _dio = Dio();

  Future<void> decodeQrFromFile(File file) async {
    isLoading = true;
    error = null;
    warrantyInfo = null;
    isVerified = null;
    notifyListeners();

    try {
      final inputImage = InputImage.fromFile(file);
      final barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.qrCode]);
      final barcodes = await barcodeScanner.processImage(inputImage);

      if (barcodes.isEmpty) {
        error = "No QR code found in the image.";
        notifyListeners();
        return;
      }

      final qrData = barcodes.first.rawValue;
      if (qrData == null || qrData.isEmpty) {
        error = "QR code is empty.";
        notifyListeners();
        return;
      }

      // Decode QR JSON locally
      final decodedJson = jsonDecode(qrData);
      warrantyInfo = WarrantyInfo.fromJson(decodedJson);

      // Call backend to validate
      await _validateOnBackend(decodedJson);
    } catch (e) {
      error = "Failed to decode QR: $e";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> _validateOnBackend(Map<String, dynamic> qrJson) async {
    try {
      final token = AuthService().token;
      if (token == null) {
        throw Exception("Authentication token missing.");
      }

      final response = await _dio.post(
        'http://localhost:5000/user/validate-warranty',
        data: qrJson, // send scanned QR JSON
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        isVerified = data['verified'] == true;
      } else {
        error = response.data['message'] ?? "Warranty validation failed";
        isVerified = false;
      }
    } catch (e) {
      error = "Validation failed: $e";
      isVerified = false;
    }
  }
}
