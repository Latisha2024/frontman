import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_lookup.dart';

import '../url.dart';

class ReportData {
  final String type;
  final String title;
  final String description;
  final DateTime date;
  final String? userId;
  final String? userName;
  final dynamic details;

  ReportData({
    required this.type,
    required this.title,
    required this.description,
    required this.date,
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
  final List<String> availableTypes = ['sales', 'inventory', 'performance','individual'];
  late final Dio _dio;
  final String baseUrl = BaseUrl.b_url;

  final TextEditingController individualUserIdController = TextEditingController();
  String individualReportType = 'performance';
  DateTime? individualStartDate;
  DateTime? individualEndDate;

  DateTime? salesStartDate;
  DateTime? salesEndDate;

  AdminGenerateReportsController() {
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
    loadAllReports();
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


  void selectType(String type) {
    selectedType = type;
    notifyListeners();
    if (type == 'individual') {
      if (individualUserIdController.text.trim().isNotEmpty) {
        fetchIndividualReport();
      }
    } else if (type == 'sales') {
      fetchSalesReport();
    } else if (type == 'inventory') {
      fetchInventoryReport();
    } else if (type == 'performance') {
      fetchPerformanceReport();
    }
  }

  List<ReportData> get filteredReports => reports
      .where((r) => r.type == selectedType)
      .toList();

  double get totalAmount {
    if (filteredReports.isEmpty) return 0.0;
    
    switch (selectedType) {
      case 'sales':
        return filteredReports.fold(0.0, (sum, report) {
          final v = report.details['totalSales'];
          return sum + ((v is num) ? v.toDouble() : 0.0);
        });
      case 'inventory':
        return filteredReports.fold(0.0, (sum, report) {
          final details = report.details;
          if (details is List) {
            final totalQty = details.fold<num>(0, (s, item) {
              if (item is Map) {
                final q = item['stockQuantity'];
                return s + ((q is num) ? q : 0);
              }
              return s;
            });
            return sum + totalQty.toDouble();
          }
          if (details is Map) {
            final v = details['totalValue'];
            return sum + ((v is num) ? v.toDouble() : 0.0);
          }
          return sum;
        });
      case 'performance':
        return filteredReports.fold(0.0, (sum, report) {
          final v = report.details['totalRevenue'];
          return sum + ((v is num) ? v.toDouble() : 0.0);
        });
      case 'individual':
        return filteredReports.fold(0.0, (sum, report) {
          final v = report.details['totalSales'];
          return sum + ((v is num) ? v.toDouble() : 0.0);
        });
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

  Future<void> fetchSalesReport() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final params = <String, dynamic>{};
      if (salesStartDate != null) params['startDate'] = _formatDate(salesStartDate!);
      if (salesEndDate != null) params['endDate'] = _formatDate(salesEndDate!);
      final response = await _dio.get('/admin/reports/sales', queryParameters: params);
      
      if (response.statusCode == 200) {
        final data = response.data;
        reports = [ReportData(
          type: 'sales',
          title: 'Sales Report',
          description: 'Comprehensive sales analysis',
          date: DateTime.now(),
          details: data,
        )];
        successMessage = 'Sales report loaded successfully';
        _scheduleAutoHideMessages();
      }
    } on DioException catch (e) {
      error = 'Failed to load sales report: ${e.message}';
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'Unexpected error: $e';
      _scheduleAutoHideMessages();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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
          details: data,
        )];
        successMessage = 'Inventory report loaded successfully';
        _scheduleAutoHideMessages();
      }
    } on DioException catch (e) {
      error = 'Failed to load inventory report: ${e.message}';
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'Unexpected error: $e';
      _scheduleAutoHideMessages();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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
          details: data,
        )];
        successMessage = 'Performance report loaded successfully';
        _scheduleAutoHideMessages();
      }
    } on DioException catch (e) {
      error = 'Failed to load performance report: ${e.message}';
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'Unexpected error: $e';
      _scheduleAutoHideMessages();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchIndividualReport({
    String? userId,
    String? reportType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      String uid = (userId ?? individualUserIdController.text.trim());
      if (uid.isEmpty) {
        error = 'User name is required for individual reports';
        isLoading = false;
        notifyListeners();
        return;
      }

      final lookedUp = await UserLookup.resolveUserIdByName(uid);
      if (lookedUp != null) {
        uid = lookedUp;
      }

      final type = (reportType ?? individualReportType);

      final params = <String, dynamic>{
        'userId': uid,
        'reportType': type,
      };
      if (startDate != null) params['startDate'] = _formatDate(startDate);
      if (endDate != null) params['endDate'] = _formatDate(endDate);
      if (individualStartDate != null && startDate == null) params['startDate'] = _formatDate(individualStartDate!);
      if (individualEndDate != null && endDate == null) params['endDate'] = _formatDate(individualEndDate!);

      const path = '/admin/reports/individual';
      final response = await _dio.get(path, queryParameters: params);
      
      if (response.statusCode == 200) {
        final data = response.data;
        Map<String, dynamic> detailsBlock;
        String title;
        String description;
        switch (type) {
          case 'sales':
            detailsBlock = Map<String, dynamic>.from(data['salesData'] ?? {});
            title = 'Individual Sales Report';
            description = 'Sales metrics for the selected user';
            break;
          case 'attendance':
            detailsBlock = Map<String, dynamic>.from(data['attendanceData'] ?? {});
            title = 'Individual Attendance Report';
            description = 'Attendance metrics for the selected user';
            break;
          case 'points':
            detailsBlock = Map<String, dynamic>.from(data['pointsData'] ?? {});
            title = 'Individual Points Report';
            description = 'Points and cash earnings for the selected user';
            break;
          case 'performance':
          default:
            detailsBlock = Map<String, dynamic>.from(data['performanceData'] ?? {});
            title = 'Individual Performance Report';
            description = 'Performance metrics for the selected user';
            break;
        }

        reports = [ReportData(
          type: 'individual',
          title: title,
          description: description,
          date: DateTime.now(),
          userId: data['userId']?.toString(),
          userName: data['userName']?.toString(),
          details: detailsBlock,
        )];
        successMessage = 'Individual report loaded successfully';
        _scheduleAutoHideMessages();
      }
    } on DioException catch (e) {
      error = 'Failed to load individual report: ${e.message}';
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'Unexpected error: $e';
      _scheduleAutoHideMessages();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _formatDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    individualUserIdController.dispose();
    super.dispose();
  }
}