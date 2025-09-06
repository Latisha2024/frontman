// lib/plumber/controllers/validate_warranty.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

String _resolveBaseUrl() {
  const lanIpForPhysicalDevice = '';
  if (lanIpForPhysicalDevice.isNotEmpty) return lanIpForPhysicalDevice;
  if (kIsWeb)
    return 'https://frontman-backend-2.onrender.com/'; // still supports web builds
  if (Platform.isAndroid) return 'https://frontman-backend-2.onrender.com/';
  return 'https://frontman-backend-2.onrender.com/';
}

class WarrantyInfo {
  final String productId;
  final String productName;
  final String serialNumber;
  final String purchaseDate;
  final int warrantyMonths;
  final String sellerName;
  final DateTime? registeredAt;
  final DateTime? expiryDate;

  WarrantyInfo({
    required this.productId,
    required this.productName,
    required this.serialNumber,
    required this.purchaseDate,
    required this.warrantyMonths,
    required this.sellerName,
    required this.registeredAt,
    required this.expiryDate,
  });

  factory WarrantyInfo.fromQrJson(Map<String, dynamic> json) {
    return WarrantyInfo(
      productId: json['productId']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      serialNumber: json['serialNumber']?.toString() ?? '',
      purchaseDate: json['purchaseDate']?.toString() ?? '',
      warrantyMonths:
          int.tryParse(json['warrantyMonths']?.toString() ?? '0') ?? 0,
      sellerName: json['sellerName']?.toString() ?? '',
      registeredAt: null,
      expiryDate: null,
    );
  }

  factory WarrantyInfo.fromBackendJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic d) {
      try {
        return d == null ? null : DateTime.parse(d.toString());
      } catch (_) {
        return null;
      }
    }

    return WarrantyInfo(
      productId: json['id']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      serialNumber: json['serialNumber']?.toString() ?? '',
      purchaseDate: json['purchaseDate']?.toString() ?? '',
      warrantyMonths:
          int.tryParse(json['warrantyMonths']?.toString() ?? '0') ?? 0,
      sellerName: json['sellerName']?.toString() ?? '',
      registeredAt: parseDate(json['registeredAt']),
      expiryDate: parseDate(json['expiryDate']),
    );
  }
}

class ValidateWarrantyController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  WarrantyInfo? warrantyInfo;
  bool? isVerified;

  late final Dio _dio;

  ValidateWarrantyController() {
    _dio = Dio(BaseOptions(
      baseUrl: _resolveBaseUrl(),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
      validateStatus: (status) =>
          status != null && status >= 100 && status < 600,
      headers: {'Accept': 'application/json'},
    ));
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    for (final k in ['auth_token', 'jwt_token', 'token']) {
      final v = prefs.getString(k);
      if (v != null && v.isNotEmpty) return v;
    }
    return null;
  }

  /// Decode QR from an uploaded file
  Future<void> decodeQrFromFile(File file) async {
    isLoading = true;
    error = null;
    warrantyInfo = null;
    isVerified = null;
    notifyListeners();

    try {
      String? raw;

      // Only mobile: use ML Kit
      final scanner = BarcodeScanner(formats: [BarcodeFormat.qrCode]);
      final inputImage = InputImage.fromFile(file);
      final barcodes = await scanner.processImage(inputImage);

      if (barcodes.isEmpty || barcodes.first.rawValue == null) {
        error = 'No QR code found or invalid QR content.';
        await scanner.close();
        return;
      }

      raw = barcodes.first.rawValue!.trim();
      await scanner.close();

      if (raw.isEmpty) {
        error = 'No QR code data found.';
        return;
      }

      Map<String, dynamic> decodedJson;
      try {
        final parsed = jsonDecode(raw);
        if (parsed is Map<String, dynamic>) {
          decodedJson = parsed;
        } else {
          error = 'QR does not contain a JSON object.';
          return;
        }
      } catch (e) {
        error = 'Failed to parse QR JSON: $e\nRaw: $raw';
        return;
      }

      warrantyInfo = WarrantyInfo.fromQrJson(decodedJson);
      notifyListeners();

      await _validateOnBackend(decodedJson);
    } catch (e) {
      error = 'Failed to decode QR: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _validateOnBackend(Map<String, dynamic> qrJson) async {
    try {
      final token = await _getToken();
      if (token == null) {
        error = 'Not authenticated. Token missing.';
        isVerified = false;
        return;
      }

      final response = await _dio.post(
        '/user/warranty/validate',
        data: qrJson,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200 && response.data['warranty'] != null) {
        warrantyInfo = WarrantyInfo.fromBackendJson(response.data['warranty']);
        isVerified = true;
        error = null;
      } else {
        isVerified = false;
        error = response.data['message']?.toString() ?? 'Warranty not found';
      }
    } catch (e) {
      error = 'Validation failed: $e';
      isVerified = false;
    } finally {
      notifyListeners();
    }
  }

  void clear() {
    error = null;
    warrantyInfo = null;
    isVerified = null;
    notifyListeners();
  }
}
