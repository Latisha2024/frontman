import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_lookup.dart';

import '../url.dart';

class AlertModel {
  final String id;
  final String message;
  final String? userId;
  final bool acknowledged;
  final DateTime createdAt;

  AlertModel({
    required this.id,
    required this.message,
    this.userId,
    required this.acknowledged,
    required this.createdAt,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    bool toBool(dynamic v) {
      if (v is bool) return v;
      if (v is int) return v != 0;
      if (v is String) return v.toLowerCase() == 'true' || v == '1';
      return false;
    }

    DateTime toDate(dynamic v) {
      if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return DateTime.now();
    }

    return AlertModel(
      id: json['id']?.toString() ?? '',
      message: (json['message'] ?? '').toString(),
      userId: json['userId']?.toString(),
      acknowledged: toBool(json['acknowledged']),
      createdAt: toDate(json['createdAt']),
    );
  }
}

class AdminShiftAlertsController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  String? successMessage;
  late final Dio _dio;

  // Form controllers
  final userIdController = TextEditingController();
  final messageController = TextEditingController();

  // Listing state (mirrors notifications)
  List<AlertModel> alerts = [];
  List<AlertModel> filteredAlerts = [];
  String selectedFilter = 'All'; // All, Acked, Unacked
  String searchQuery = '';

  // Base URL - configure based on your backend
  static const String baseUrl = BaseUrl.b_url;

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
    // Preload list
    fetchAlerts();
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

  // GET /admin/shift-alerts (front-end wiring; backend can be added later)
  Future<void> fetchAlerts() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _dio.get('/admin/shift-alerts');
      // Accept either array or {data: []}
      final body = response.data;
      final List<dynamic> list = body is List ? body : (body['data'] as List? ?? []);
      alerts = list.map((e) => AlertModel.fromJson(e as Map<String, dynamic>)).toList();
      applyFilters();
      successMessage = 'Shift alerts loaded';
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      // Graceful message until backend implements GET
      error = e.response?.data is Map && (e.response!.data['message'] != null)
          ? e.response!.data['message'].toString()
          : 'Failed to fetch shift alerts';
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'Unexpected error: $e';
      _scheduleAutoHideMessages();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // POST /admin/shift-alerts
  Future<void> createShiftAlert() async {
    if (!validateForm()) return;

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      // Resolve username to userId if needed
      String resolvedUserId = userIdController.text.trim();
      final lookedUp = await UserLookup.resolveUserIdByName(resolvedUserId);
      if (lookedUp != null) {
        resolvedUserId = lookedUp;
      }

      final alertData = {
        'userId': resolvedUserId,
        'message': messageController.text.trim(),
      };

      final response = await _dio.post(
        '/admin/shift-alerts',
        data: alertData,
      );

      final responseData = response.data;
      successMessage = responseData['message'] ?? 'Shift alert created successfully';
      clearForm();
      await fetchAlerts();
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

  void searchAlerts(String query) {
    searchQuery = query;
    applyFilters();
  }

  void filterAlerts(String filter) {
    selectedFilter = filter; // All, Acked, Unacked
    applyFilters();
  }

  void applyFilters() {
    filteredAlerts = alerts.where((a) {
      final q = searchQuery.trim().toLowerCase();
      final matchesSearch = q.isEmpty ||
          a.message.toLowerCase().contains(q) ||
          (a.userId?.toLowerCase().contains(q) ?? false);
      final matchesFilter = selectedFilter == 'All' ||
          (selectedFilter == 'Acked' && a.acknowledged) ||
          (selectedFilter == 'Unacked' && !a.acknowledged);
      return matchesSearch && matchesFilter;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  bool validateForm() {
    error = null;
    if (userIdController.text.trim().isEmpty || messageController.text.trim().isEmpty) {
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
