// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class PlumberRegisterWarrantyController extends ChangeNotifier {
//   final productIdController = TextEditingController();
//   final serialNumberController = TextEditingController();
//   final purchaseDateController = TextEditingController();
//   final warrantyMonthsController = TextEditingController();
//   final sellerIdController = TextEditingController();

//   bool isLoading = false;
//   String? error;
//   bool? success;
//   String? qrCodeData;

//   final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:5000'));

//   // 👆 Use 10.0.2.2 for Android Emulator

//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token') ?? prefs.getString('jwt_token');
//     debugPrint("🔑 Retrieved token: $token");
//     return token;
//   }

//   Future<void> submitWarranty() async {
//     isLoading = true;
//     error = null;
//     success = null;
//     qrCodeData = null;
//     notifyListeners();

//     try {
//       final token = await _getToken();
//       if (token == null || token.isEmpty) {
//         throw Exception("Authentication token missing.");
//       }

//       // Debug log to see what is being sent
//       debugPrint("Sending warranty request with token: $token");

//       final response = await _dio.post(
//         '/user/warranty/register',
//         data: {
//           'productId': productIdController.text.trim(),
//           'serialNumber': serialNumberController.text.trim(),
//           'purchaseDate': purchaseDateController.text.trim(),
//           'warrantyMonths': int.tryParse(warrantyMonthsController.text) ?? 0,
//           'sellerId': sellerIdController.text.trim(),
//         },
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token', // most common format
//             'x-auth-token': token, // fallback if backend expects this
//             'Content-Type': 'application/json',
//           },
//         ),
//       );

//       debugPrint("✅ Response status: ${response.statusCode}");
//       debugPrint("✅ Response data: ${response.data}");

//       if (response.statusCode == 201) {
//         final data = response.data is Map<String, dynamic>
//             ? response.data
//             : jsonDecode(response.data);

//         success = true;
//         qrCodeData = data['qrImage'];
//       } else {
//         error = response.data['message'] ?? 'Failed to register warranty';
//         success = false;
//       }
//     } on DioException catch (e) {
//       if (e.response != null) {
//         error = e.response?.data['message'] ?? 'Warranty registration failed';
//         debugPrint("Server error: ${e.response?.data}");
//       } else {
//         error = 'Network error: ${e.message}';
//         debugPrint("Network error: ${e.message}");
//       }
//       success = false;
//     } catch (e) {
//       error = 'Unexpected error: $e';
//       debugPrint("Unexpected error: $e");
//       success = false;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   @override
//   void dispose() {
//     productIdController.dispose();
//     serialNumberController.dispose();
//     purchaseDateController.dispose();
//     warrantyMonthsController.dispose();
//     sellerIdController.dispose();
//     super.dispose();
//   }
// }
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
  return 'https://frontman-backend-2.onrender.com/';
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
