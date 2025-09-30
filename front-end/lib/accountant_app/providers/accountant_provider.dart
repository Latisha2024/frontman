// accountant_provider.dart (FIXED)

import 'package:flutter/material.dart';
import '../models/financial_log.dart';
import '../models/invoice.dart';
import '../services/accountant_service.dart';

class AccountantProvider with ChangeNotifier {
  final AccountantService _accountantService = AccountantService();

  List<FinancialLog> _financialLogs = [];
  List<Invoice> _invoices = [];
  bool _isLoading = false;
  String? _error;

  double _totalIncome = 0.0;
  double _totalExpenses = 0.0;
  double _pendingInvoicesAmount = 0.0;

  List<FinancialLog> get financialLogs => _financialLogs;
  List<Invoice> get invoices => _invoices;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalIncome => _totalIncome;
  double get totalExpenses => _totalExpenses;
  double get netProfit => _totalIncome - _totalExpenses;
  double get pendingInvoicesAmount => _pendingInvoicesAmount;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final summaryFuture = _accountantService.getFinancialSummary();
      final logsFuture = _accountantService.getFinancialLogs();
      final invoicesFuture = _accountantService.getInvoices();

      final results = await Future.wait([summaryFuture, logsFuture, invoicesFuture]);

      final summaryData = results[0] as Map<String, dynamic>;
      // FIX: Use robust parsing for all numerical summary fields.
      _totalIncome = double.tryParse(summaryData['totalIncome'].toString()) ?? 0.0;
      _totalExpenses = double.tryParse(summaryData['totalExpenses'].toString()) ?? 0.0;
      _pendingInvoicesAmount = double.tryParse(summaryData['pendingInvoicesAmount'].toString()) ?? 0.0;
      
      _financialLogs = results[1] as List<FinancialLog>;
      _invoices = results[2] as List<Invoice>;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFinancialLog(FinancialLog log) async {
    try {
      await _accountantService.addFinancialLog(log);
      await loadDashboardData();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
  
  Future<void> loadFinancialLogs() async {
     _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _financialLogs = await _accountantService.getFinancialLogs();
    } catch (e) {
       _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> loadInvoices() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _invoices = await _accountantService.getInvoices();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ... (No changes needed in the rest of the file)

  Future<void> addInvoice(Invoice invoice) async {
    try {
      await _accountantService.addInvoice(invoice);
      await loadDashboardData();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> sendInvoice(String invoiceId, String email) async {
    try {
      await _accountantService.sendInvoice(invoiceId, email);
      final index = _invoices.indexWhere((inv) => inv.id == invoiceId);
      if (index != -1) {
        _invoices[index].status = 'Sent';
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> verifyPayment(String invoiceId) async {
    try {
      await _accountantService.verifyPayment(invoiceId);
      final index = _invoices.indexWhere((inv) => inv.id == invoiceId);
      if (index != -1) {
        _invoices[index].status = 'Paid';
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}