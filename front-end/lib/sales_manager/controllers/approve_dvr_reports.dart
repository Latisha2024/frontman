import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../admin/url.dart' as admin_url;
import '../../admin/user_lookup.dart';

class SalesManagerApproveDvrReportsController extends ChangeNotifier {
  List<Map<String, dynamic>> reports = [];

  Dio _buildDio() {
    return Dio(BaseOptions(
      baseUrl: admin_url.BaseUrl.b_url,
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  Future<void> _attachAuth(Dio dio) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null && token.isNotEmpty) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<void> loadAllReports() async {
    final dio = _buildDio();
    await _attachAuth(dio);
    final resp = await dio.get('/fieldExecutive/dvr');
    if (resp.statusCode == 200 && resp.data is List) {
      final List list = resp.data as List;
      reports
        ..clear()
        ..addAll(list.map<Map<String, dynamic>>((e) {
          final m = e as Map<String, dynamic>;
          return {
            'id': (m['id'] ?? '').toString(),
            'executiveId': (m['executiveId'] ?? '').toString(),
            'executiveName': (m['executiveName'] ?? '').toString(),
            'feedback': (m['feedback'] ?? '').toString(),
            'location': (m['location'] ?? '').toString(),
            'status': (m['status'] ?? 'Pending').toString(),
            'approvedBy': (m['approvedBy'] ?? '').toString(),
            'approvedAt': m['approvedAt'] != null ? DateTime.tryParse(m['approvedAt'].toString()) : null,
          };
        }));
      notifyListeners();
    } else {
      throw Exception('Failed to load DVRs (${resp.statusCode}): ${resp.data}');
    }
  }

  Future<void> loadReportsByExecutiveName(String executiveName) async {
    final userId = await UserLookup.resolveUserIdByName(executiveName);
    if (userId == null) {
      throw Exception('Executive "$executiveName" not found');
    }
    final dio = _buildDio();
    await _attachAuth(dio);
    final resp = await dio.get('/fieldExecutive/dvr', queryParameters: {
      'executiveUserId': userId,
    });
    if (resp.statusCode == 200 && resp.data is List) {
      final List list = resp.data as List;
      reports
        ..clear()
        ..addAll(list.map<Map<String, dynamic>>((e) {
          final m = e as Map<String, dynamic>;
          return {
            'id': (m['id'] ?? '').toString(),
            'executiveId': (m['executiveId'] ?? '').toString(),
            'feedback': (m['feedback'] ?? '').toString(),
            'location': (m['location'] ?? '').toString(),
            'status': (m['status'] ?? 'Pending').toString(),
            'approvedBy': (m['approvedBy'] ?? '').toString(),
            'approvedAt': m['approvedAt'] != null ? DateTime.tryParse(m['approvedAt'].toString()) : null,
          };
        }));
      notifyListeners();
    } else {
      throw Exception('Failed to load DVRs (${resp.statusCode}): ${resp.data}');
    }
  }

  Future<void> approveReportRemote(String id) async {
    final dio = _buildDio();
    await _attachAuth(dio);
    final resp = await dio.patch('/fieldExecutive/dvr/$id/approve');
    if (resp.statusCode == 200) {
      final idx = reports.indexWhere((r) => r['id'] == id);
      if (idx != -1) {
        reports[idx]['status'] = 'Approved';
        reports[idx]['approvedBy'] = '';
        reports[idx]['approvedAt'] = DateTime.now();
        notifyListeners();
      }
    } else {
      throw Exception('Failed to approve DVR (${resp.statusCode}): ${resp.data}');
    }
  }

  Future<void> rejectReportRemote(String id) async {
    final dio = _buildDio();
    await _attachAuth(dio);
    final resp = await dio.patch('/fieldExecutive/dvr/$id/reject');
    if (resp.statusCode == 200) {
      final idx = reports.indexWhere((r) => r['id'] == id);
      if (idx != -1) {
        reports[idx]['status'] = 'Rejected';
        reports[idx]['approvedBy'] = '';
        reports[idx]['approvedAt'] = DateTime.now();
        notifyListeners();
      }
    } else {
      throw Exception('Failed to reject DVR (${resp.statusCode}): ${resp.data}');
    }
  }
}
 