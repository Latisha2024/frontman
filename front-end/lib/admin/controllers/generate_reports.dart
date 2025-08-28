import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? successMessage;
  List<ReportData> reports = [];
  String selectedType = 'sales';
  String? currentCompanyId;
  final List<String> availableTypes = ['sales', 'inventory', 'performance','individual'];
  late final Dio _dio;
  final String baseUrl = 'http://10.0.2.2:5000';

  AdminGenerateReportsController({String? companyId}) {
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
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
    currentCompanyId = companyId;
    // Load reports from backend on initialization
    loadAllReports();
  }


  void selectType(String type) {
    selectedType = type;
    notifyListeners();
  }

  List<ReportData> get filteredReports => reports
      .where((r) => r.type == selectedType && r.companyId == currentCompanyId)
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

  void clearSuccess() {
    successMessage = null;
    notifyListeners();
  }

  // Load all reports based on selected type
  Future<void> loadAllReports() async {
    switch (selectedType) {
      case 'sales':
        await fetchSalesReport();
        break;
      case 'inventory':
        await fetchInventoryReport();
        break;
      case 'performance':
        await fetchPerformanceReport();
        break;
      case 'individual':
        await fetchIndividualReport();
        break;
    }
  }

  // GET /admin/reports/sales
  Future<void> fetchSalesReport() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _dio.get('/admin/reports/sales');
      
      if (response.statusCode == 200) {
        final data = response.data;
        reports = [ReportData(
          type: 'sales',
          title: 'Sales Report',
          description: 'Comprehensive sales analysis',
          date: DateTime.now(),
          companyId: currentCompanyId ?? 'default',
          details: data,
        )];
        successMessage = 'Sales report loaded successfully';
      }
    } on DioException catch (e) {
      error = 'Failed to load sales report: ${e.message}';
    } catch (e) {
      error = 'Unexpected error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // GET /admin/reports/inventory
  Future<void> fetchInventoryReport() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _dio.get('/admin/reports/inventory');
      
      if (response.statusCode == 200) {
        final data = response.data;
        reports = [ReportData(
          type: 'inventory',
          title: 'Inventory Report',
          description: 'Current inventory levels and stock analysis',
          date: DateTime.now(),
          companyId: currentCompanyId ?? 'default',
          details: data,
        )];
        successMessage = 'Inventory report loaded successfully';
      }
    } on DioException catch (e) {
      error = 'Failed to load inventory report: ${e.message}';
    } catch (e) {
      error = 'Unexpected error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // GET /admin/reports/performance
  Future<void> fetchPerformanceReport() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _dio.get('/admin/reports/performance');
      
      if (response.statusCode == 200) {
        final data = response.data;
        reports = [ReportData(
          type: 'performance',
          title: 'Performance Report',
          description: 'Employee and system performance analysis',
          date: DateTime.now(),
          companyId: currentCompanyId ?? 'default',
          details: data,
        )];
        successMessage = 'Performance report loaded successfully';
      }
    } on DioException catch (e) {
      error = 'Failed to load performance report: ${e.message}';
    } catch (e) {
      error = 'Unexpected error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // GET /admin/reports/individual
  Future<void> fetchIndividualReport({String? userId}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      String url = '/admin/reports/individual';
      if (userId != null) {
        url += '?userId=$userId';
      }
      
      final response = await _dio.get(url);
      
      if (response.statusCode == 200) {
        final data = response.data;
        reports = [ReportData(
          type: 'individual',
          title: 'Individual Report',
          description: 'Individual performance metrics',
          date: DateTime.now(),
          companyId: currentCompanyId ?? 'default',
          userId: userId,
          details: data,
        )];
        successMessage = 'Individual report loaded successfully';
      }
    } on DioException catch (e) {
      error = 'Failed to load individual report: ${e.message}';
    } catch (e) {
      error = 'Unexpected error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}