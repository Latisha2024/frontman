import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminShiftAlertsController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  String? successMessage;
  late final Dio _dio;

  // Form controllers
  final userIdController = TextEditingController();
  final messageController = TextEditingController();

  // Base URL - configure based on your backend
  static const String baseUrl = 'http://10.0.2.2:5000';

  AdminShiftAlertsController() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer ' + token;
        }
        return handler.next(options);
      },
    ));
  }

  void _scheduleAutoHideMessages() {
    Future.delayed(const Duration(seconds: 3), () {
      if (error != null || successMessage != null) {
        error = null;
        successMessage = null;
        notifyListeners();
      }
    });
  }

  // POST /admin/shift-alerts
  Future<void> createShiftAlert() async {
    if (!validateForm()) return;

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final alertData = {
        'userId': userIdController.text.trim(),
        'message': messageController.text.trim(),
      };

      final response = await _dio.post(
        '/admin/shift-alerts',
        data: alertData,
      );

      final responseData = response.data;
      successMessage = responseData['message'] ?? 'Shift alert created successfully';
      clearForm();
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        error = responseData['message'] ?? 'Failed to create shift alert: ${e.response!.statusCode}';
      } else {
        error = 'Network error: ${e.message}';
      }
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'Unexpected error: $e';
      _scheduleAutoHideMessages();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool validateForm() {
    error = null;
    if (userIdController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty) {
      error = 'Please fill in all required fields.';
      notifyListeners();
      _scheduleAutoHideMessages();
      return false;
    }
    return true;
  }

  void clearForm() {
    userIdController.clear();
    messageController.clear();
    notifyListeners();
  }

  void clearMessages() {
    error = null;
    successMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    userIdController.dispose();
    messageController.dispose();
    super.dispose();
  }
}
