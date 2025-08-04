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

  AdminGenerateReportsController() {
    // Initialize with dummy report data
    reports = [
      ReportData(
        type: 'sales',
        title: 'Monthly Sales Report',
        description: 'Comprehensive sales analysis for the current month',
        date: DateTime.now().subtract(const Duration(days: 5)),
        details: {
          'totalSales': 125000.00,
          'totalOrders': 45,
          'averageOrderValue': 2777.78,
          'topProduct': 'Premium Smartphone',
        },
      ),
    ];
  }

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