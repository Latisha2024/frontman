import 'package:flutter/material.dart';
import '../models/financial_log.dart';
import '../models/invoice.dart';
import '../services/accountant_service.dart';

class AccountantProvider with ChangeNotifier {
  final AccountantService _service = AccountantService();
  
  List<FinancialLog> _financialLogs = [];
  List<Invoice> _invoices = [];
  bool _isLoading = false;
  String? _error;

  List<FinancialLog> get financialLogs => _financialLogs;
  List<Invoice> get invoices => _invoices;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Financial Logs methods
  Future<void> loadFinancialLogs() async {
    _setLoading(true);
    try {
      _financialLogs = await _service.getFinancialLogs();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addFinancialLog(FinancialLog log) async {
    try {
      await _service.addFinancialLog(log);
      _financialLogs.add(log);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteFinancialLog(String id) async {
    try {
      await _service.deleteFinancialLog(id);
      _financialLogs.removeWhere((log) => log.id == id);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Invoice methods
  Future<void> loadInvoices() async {
    _setLoading(true);
    try {
      _invoices = await _service.getInvoices();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addInvoice(Invoice invoice) async {
    try {
      await _service.addInvoice(invoice);
      _invoices.add(invoice);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> sendInvoice(String invoiceId, String email) async {
    try {
      await _service.sendInvoice(invoiceId, email);
      final index = _invoices.indexWhere((inv) => inv.id == invoiceId);
      if (index != -1) {
        _invoices[index] = Invoice(
          id: _invoices[index].id,
          clientName: _invoices[index].clientName,
          clientEmail: _invoices[index].clientEmail,
          clientAddress: _invoices[index].clientAddress,
          description: _invoices[index].description,
          amount: _invoices[index].amount,
          dueDate: _invoices[index].dueDate,
          createdDate: _invoices[index].createdDate,
          status: 'sent',
          notes: _invoices[index].notes,
        );
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> verifyPayment(String invoiceId) async {
    try {
      await _service.verifyPayment(invoiceId);
      final index = _invoices.indexWhere((inv) => inv.id == invoiceId);
      if (index != -1) {
        _invoices[index] = Invoice(
          id: _invoices[index].id,
          clientName: _invoices[index].clientName,
          clientEmail: _invoices[index].clientEmail,
          clientAddress: _invoices[index].clientAddress,
          description: _invoices[index].description,
          amount: _invoices[index].amount,
          dueDate: _invoices[index].dueDate,
          createdDate: _invoices[index].createdDate,
          status: 'paid',
          notes: _invoices[index].notes,
        );
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Dashboard calculations
  double get totalIncome {
    return _financialLogs
        .where((log) => log.type == 'income')
        .fold(0.0, (sum, log) => sum + log.amount);
  }

  double get totalExpenses {
    return _financialLogs
        .where((log) => log.type == 'expense')
        .fold(0.0, (sum, log) => sum + log.amount);
  }

  double get netProfit => totalIncome - totalExpenses;

  double get pendingInvoicesAmount {
    return _invoices
        .where((invoice) => invoice.status == 'sent')
        .fold(0.0, (sum, invoice) => sum + invoice.amount);
  }
}