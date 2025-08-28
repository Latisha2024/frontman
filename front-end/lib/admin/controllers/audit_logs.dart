import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String selectedAction = 'All';
  final List<String> availableActions = ['All', 'Login', 'Update Product', 'Delete User', 'Create Order'];

  final Dio _dio = Dio();
  final String _baseUrl = 'http://10.0.2.2:5000/admin';

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

  void searchLogs(String query) {
    searchQuery = query;
    applyFilters();
  }

  void filterByAction(String action) {
    selectedAction = action;
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
      bool matchesAction = selectedAction == 'All' || log.action == selectedAction;
      return matchesSearch && matchesAction;
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
      final response = await _dio.get('$_baseUrl/audit-logs');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        logs = data.map((json) => AuditLog.fromJson(json)).toList();
        applyFilters();
      }
    } on DioException catch (e) {
      error = 'Failed to fetch logs: ${e.message}';
    } catch (e) {
      error = 'An unexpected error occurred: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAuditLog({
    required String userId,
    required String action,
    required String resource,
    String? details,
  }) async {
    isLoading = true;
    error = null;
    successMessage = null;
    notifyListeners();
    try {
      final response = await _dio.post('$_baseUrl/audit-logs', data: {
        'userId': userId,
        'action': action,
        'resource': resource,
        'details': details,
      });
      if (response.statusCode == 201) {
        successMessage = 'Audit log created successfully.';
        fetchAuditLogs(); // Refresh the list
      }
    } on DioException catch (e) {
      error = 'Failed to create log: ${e.response?.data?['message'] ?? e.message}';
    } catch (e) {
      error = 'An unexpected error occurred: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}