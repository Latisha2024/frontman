import 'package:dio/dio.dart';
import '../models/financial_log.dart';
import '../models/invoice.dart';
import '../../authpage/pages/auth_services.dart';

class AccountantService {
  final Dio _dio = AuthService().dio;

  Future<Map<String, dynamic>> getFinancialSummary() async {
    try {
      final response = await _dio.get('/accountant/invoice/summary');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to load financial summary: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<List<FinancialLog>> getFinancialLogs() async {
    try {
      final response = await _dio.get('/accountant/financial-logs');
      print('RAW JSON RECEIVED: ${response.data}');
      final List<dynamic> data = response.data['financialLogs'];
      return data.map((json) => FinancialLog.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load financial logs: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<void> addFinancialLog(FinancialLog log) async {
    try {
      await _dio.post('/accountant/financial-logs', data: log.toJson());
    } on DioException catch (e) {
      throw Exception('Failed to add financial log: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<List<Invoice>> getInvoices() async {
    try {
      final response = await _dio.get('/accountant/invoice');
      final List<dynamic> data = response.data;
      return data.map((json) => Invoice.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load invoices: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<void> addInvoice(Invoice invoice) async {
    try {
      await _dio.post('/accountant/invoice', data: invoice.toJson());
    } on DioException catch (e) {
      throw Exception('Failed to add invoice: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<void> sendInvoice(String invoiceId, String email) async {
    try {
      await _dio.patch('/accountant/invoice/$invoiceId/send', data: {'email': email});
    } on DioException catch (e) {
      throw Exception('Failed to send invoice: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<void> verifyPayment(String invoiceId) async {
    try {
      await _dio.patch('/accountant/invoice/$invoiceId/verify-payment');
    } on DioException catch (e) {
      throw Exception('Failed to verify payment: ${e.response?.data['message'] ?? e.message}');
    }
  }
}