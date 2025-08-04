import 'package:flutter/material.dart';

class AuditLog {
  final String id;
  final String user;
  final String action;
  final DateTime timestamp;
  final String details;

  AuditLog({
    required this.id,
    required this.user,
    required this.action,
    required this.timestamp,
    required this.details,
  });
}

class AdminAuditLogsController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  String? successMessage;
  List<AuditLog> logs = [];
  List<AuditLog> filteredLogs = [];
  String searchQuery = '';
  String selectedAction = 'All';
  final List<String> availableActions = ['All', 'Login', 'Update Product', 'Delete User'];

  AdminAuditLogsController() {
    filteredLogs = List.from(logs);
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
      bool matchesSearch = searchQuery.isEmpty ||
          log.user.toLowerCase().contains(searchQuery.toLowerCase()) ||
          log.action.toLowerCase().contains(searchQuery.toLowerCase()) ||
          log.details.toLowerCase().contains(searchQuery.toLowerCase());
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
}