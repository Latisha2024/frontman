import 'package:flutter/material.dart';

class ReportData {
  final String type;
  final String title;
  final String description;
  final DateTime date;
  final Map<String, dynamic> details;

  ReportData({
    required this.type,
    required this.title,
    required this.description,
    required this.date,
    required this.details,
  });
}

class AdminGenerateReportsController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  List<ReportData> reports = [];
  String selectedType = 'sales';
  final List<String> availableTypes = ['sales', 'inventory', 'performance'];

  void selectType(String type) {
    selectedType = type;
    notifyListeners();
  }

  List<ReportData> get filteredReports => reports.where((r) => r.type == selectedType).toList();

  void clearError() {
    error = null;
    notifyListeners();
  }
} 