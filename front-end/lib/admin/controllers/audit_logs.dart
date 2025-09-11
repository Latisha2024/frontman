import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../url.dart';

class User {
  final String id;
  final String? name;
  final String email;

  User({required this.id, this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

class AuditLog {
  final String id;
  final String action;
  final String resource;
  final DateTime timestamp;
  final String? details;
  final User user;

  AuditLog({
    required this.id,
    required this.action,
    required this.resource,
    required this.timestamp,
    this.details,
    required this.user,
  });

  factory AuditLog.fromJson(Map<String, dynamic> json) {
    return AuditLog(
      id: json['id'],
      action: json['action'],
      resource: json['resource'],
      timestamp: DateTime.parse(json['timestamp']),
      details: json['details'],
      user: User.fromJson(json['user']),
    );
  }
}

class AdminAuditLogsController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  String? successMessage;
  List<AuditLog> logs = [];
  List<AuditLog> filteredLogs = [];
  String searchQuery = '';

  final Dio _dio = Dio();
  final String _baseUrl = BaseUrl.b_url;

  AdminAuditLogsController() {
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
    fetchAuditLogs();
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

  void searchLogs(String query) {
    searchQuery = query;
    applyFilters();
  }

  void applyFilters() {
    filteredLogs = logs.where((log) {
      final userIdentifier = log.user.name ?? log.user.email;
      bool matchesSearch = searchQuery.isEmpty ||
          userIdentifier.toLowerCase().contains(searchQuery.toLowerCase()) ||
          log.action.toLowerCase().contains(searchQuery.toLowerCase()) ||
          log.resource.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (log.details?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
      return matchesSearch;
    }).toList();
    notifyListeners();
  }

  void clearMessages() {
    error = null;
    successMessage = null;
    notifyListeners();
  }

  Future<void> fetchAuditLogs() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final response = await _dio.get('${_baseUrl}admin/audits');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data as Map<String, dynamic>;
        final List<dynamic> data = body['data'] as List<dynamic>;
        logs = data.map((json) => AuditLog.fromJson(json as Map<String, dynamic>)).toList();
        applyFilters();
        successMessage = 'Audit logs loaded successfully';
        _scheduleAutoHideMessages();
      }
    } on DioException catch (e) {
      error = 'Failed to fetch logs: ${e.message}';
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'An unexpected error occurred: $e';
      _scheduleAutoHideMessages();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAuditLog({
    required String action,
    required String resource,
    String? details,
  }) async {
    isLoading = true;
    error = null;
    successMessage = null;
    notifyListeners();
    try {
      final response = await _dio.post('${_baseUrl}admin/audits', data: {
        'action': action,
        'resource': resource,
        'details': details,
      });
      if (response.statusCode == 201) {
        successMessage = 'Audit log created successfully.';
        fetchAuditLogs(); // Refresh the list
        _scheduleAutoHideMessages();
      }
    } on DioException catch (e) {
      error = 'Failed to create log: ${e.response?.data?['message'] ?? e.message}';
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'An unexpected error occurred: $e';
      _scheduleAutoHideMessages();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}