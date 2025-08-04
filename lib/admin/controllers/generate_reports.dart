import 'package:flutter/material.dart';

class ReportData {
  final String type;
  final String title;
  final String description;
  final DateTime date;
  final String companyId;
  final String? userId; // For individual user reports
  final String? userName; // For individual user reports
  final Map<String, dynamic> details;

  ReportData({
    required this.type,
    required this.title,
    required this.description,
    required this.date,
    required this.companyId,
    this.userId,
    this.userName,
    required this.details,
  });
}

class AdminGenerateReportsController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  List<ReportData> reports = [];
  String selectedType = 'sales';
  String? currentCompanyId;
  final List<String> availableTypes = ['sales', 'inventory', 'performance','individual'];

  AdminGenerateReportsController({String? companyId}) {
    currentCompanyId = companyId;
    // Initialize with dummy report data
    reports = [
      ReportData(
        type: 'individual',
        title: 'Jane Smith - Performance Report',
        description: 'Individual performance metrics for Jane Smith',
        date: DateTime.now().subtract(const Duration(days: 1)),
        companyId: companyId ?? 'company1',
        userId: 'user2',
        userName: 'Jane Smith',
        details: {
          'totalSales': 32000.00,
          'ordersCompleted': 18,
          'averageOrderValue': 1777.78,
          'topProduct': 'Laptop',
          'performance': 92.3,
        },
      ),
      ReportData(
        type: 'individual',
        title: 'John Doe - Sales Report',
        description: 'Individual sales performance for John Doe',
        date: DateTime.now().subtract(const Duration(days: 2)),
        companyId: companyId ?? 'company1',
        userId: 'user1',
        userName: 'John Doe',
        details: {
          'totalSales': 25000.00,
          'ordersCompleted': 12,
          'averageOrderValue': 2083.33,
          'topProduct': 'Smart Watch',
          'performance': 85.5,
        },
      ),
      ReportData(
        type: 'individual',
        title: 'Mike Johnson - Inventory Report',
        description: 'Individual inventory management for Mike Johnson',
        date: DateTime.now().subtract(const Duration(days: 3)),
        companyId: companyId ?? 'company1',
        userId: 'user3',
        userName: 'Mike Johnson',
        details: {
          'productsManaged': 45,
          'stockUpdates': 23,
          'lowStockAlerts': 5,
          'efficiency': 88.7,
        },
      ),
      ReportData(
        type: 'sales',
        title: 'Monthly Sales Report',
        description: 'Comprehensive sales analysis for the current month',
        date: DateTime.now().subtract(const Duration(days: 5)),
        companyId: companyId ?? 'company1',
        details: {
          'totalSales': 125000.00,
          'totalOrders': 45,
          'averageOrderValue': 2777.78,
          'topProduct': 'Premium Smartphone',
        },
      ),
      ReportData(
        type: 'inventory',
        title: 'Inventory Status Report',
        description: 'Current inventory levels and stock analysis',
        date: DateTime.now().subtract(const Duration(days: 3)),
        companyId: companyId ?? 'company1',
        details: {
          'totalProducts': 150,
          'lowStockItems': 12,
          'outOfStockItems': 3,
          'totalValue': 2500000.00,
        },
      ),
      ReportData(
        type: 'performance',
        title: 'Performance Metrics Report',
        description: 'Employee and system performance analysis',
        date: DateTime.now().subtract(const Duration(days: 1)),
        companyId: companyId ?? 'company1',
        details: {
          'totalRevenue': 350000.00,
          'activeUsers': 25,
          'completedTasks': 89,
          'efficiency': 94.5,
        },
      ),
    ];
  }

  void selectType(String type) {
    selectedType = type;
    notifyListeners();
  }

  List<ReportData> get filteredReports => reports
      .where((r) => r.type == selectedType && (currentCompanyId == null || r.companyId == currentCompanyId))
      .toList();

  double get totalAmount {
    if (filteredReports.isEmpty) return 0.0;
    
    switch (selectedType) {
      case 'sales':
        return filteredReports.fold(0.0, (sum, report) => 
          sum + (report.details['totalSales'] as double? ?? 0.0));
      case 'inventory':
        return filteredReports.fold(0.0, (sum, report) => 
          sum + (report.details['totalValue'] as double? ?? 0.0));
      case 'performance':
        return filteredReports.fold(0.0, (sum, report) => 
          sum + (report.details['totalRevenue'] as double? ?? 0.0));
      case 'individual':
        return filteredReports.fold(0.0, (sum, report) => 
          sum + (report.details['totalSales'] as double? ?? 0.0));
      default:
        return 0.0;
    }
  }

  void clearError() {
    error = null;
    notifyListeners();
  }
} 