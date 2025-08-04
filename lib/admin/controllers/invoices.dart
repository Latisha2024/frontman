import 'package:flutter/material.dart';

class LineItem {
  final String description;
  final int quantity;
  final double unitPrice;
  final double amount;
  final double gstRate;

  LineItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
    required this.gstRate,
  });

  LineItem copyWith({
    String? description,
    int? quantity,
    double? unitPrice,
    double? amount,
    double? gstRate,
  }) {
    return LineItem(
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      amount: amount ?? this.amount,
      gstRate: gstRate ?? this.gstRate,
    );
  }
}

class Invoice {
  final String id;
  final String invoiceNumber;
  final DateTime issueDate;
  final DateTime dueDate;
  final String reference;
  final String billTo;
  final List<LineItem> items;
  final double subtotal;
  final double gstTotal;
  final double totalDue;
  final String? signature;

  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.issueDate,
    required this.dueDate,
    required this.reference,
    required this.billTo,
    required this.items,
    required this.subtotal,
    required this.gstTotal,
    required this.totalDue,
    this.signature,
  });

  Invoice copyWith({
    String? id,
    String? invoiceNumber,
    DateTime? issueDate,
    DateTime? dueDate,
    String? reference,
    String? billTo,
    List<LineItem>? items,
    double? subtotal,
    double? gstTotal,
    double? totalDue,
    String? signature,
  }) {
    return Invoice(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      reference: reference ?? this.reference,
      billTo: billTo ?? this.billTo,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      gstTotal: gstTotal ?? this.gstTotal,
      totalDue: totalDue ?? this.totalDue,
      signature: signature ?? this.signature,
    );
  }
}

class AdminInvoicesController extends ChangeNotifier {
  List<Invoice> invoices = [];
  List<Invoice> filteredInvoices = [];
  bool isLoading = false;
  String? error;
  String? successMessage;

  AdminInvoicesController() {
    // Initialize with dummy invoice data
    invoices = [
      Invoice(
        id: '1',
        invoiceNumber: 'INV-2024-001',
        issueDate: DateTime.now().subtract(const Duration(days: 15)),
        dueDate: DateTime.now().add(const Duration(days: 15)),
        reference: 'REF-2024-001',
        billTo: 'ABC Company Ltd.',
        items: [
          LineItem(
            description: 'Premium Smartphone',
            quantity: 2,
            unitPrice: 72999,
            amount: 80000,
            gstRate: 18.0,
          ),
        ],
        subtotal: 80000,
        gstTotal: 1999,
        totalDue: 81999,
        signature: 'John Doe',
      ),
    ];
    filteredInvoices = List.from(invoices);
    notifyListeners();
  }

  // Form controllers
  final invoiceNumberController = TextEditingController();
  final issueDateController = TextEditingController();
  final dueDateController = TextEditingController();
  final referenceController = TextEditingController();
  final billToController = TextEditingController();
  final signatureController = TextEditingController();

  List<LineItem> formItems = [];

  Invoice? editingInvoice;
  bool isEditMode = false;

  void addInvoice() {
    if (!validateForm()) return;
    final newInvoice = Invoice(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      invoiceNumber: invoiceNumberController.text.trim(),
      issueDate: DateTime.now(),
      dueDate: DateTime.parse(dueDateController.text.trim()),
      reference: referenceController.text.trim(),
      billTo: billToController.text.trim(),
      items: List<LineItem>.from(formItems),
      subtotal: calculateSubtotal(),
      gstTotal: calculateGstTotal(),
      totalDue: calculateTotalDue(),
      signature: signatureController.text.trim(),
    );
    invoices.add(newInvoice);
    filteredInvoices = List.from(invoices);
    clearForm();
    successMessage = 'Invoice added successfully!';
    notifyListeners();
  }

  void editInvoice(Invoice invoice) {
    editingInvoice = invoice;
    isEditMode = true;
    invoiceNumberController.text = invoice.invoiceNumber;
    issueDateController.text = invoice.issueDate.toIso8601String().split('T')[0];
    dueDateController.text = invoice.dueDate.toIso8601String().split('T')[0];
    referenceController.text = invoice.reference;
    billToController.text = invoice.billTo;
    signatureController.text = invoice.signature ?? '';
    formItems = List<LineItem>.from(invoice.items);
    notifyListeners();
  }

  void updateInvoice() {
    if (editingInvoice == null) return;
    if (!validateForm()) return;
    final updatedInvoice = editingInvoice!.copyWith(
      invoiceNumber: invoiceNumberController.text.trim(),
      dueDate: DateTime.parse(dueDateController.text.trim()),
      reference: referenceController.text.trim(),
      billTo: billToController.text.trim(),
      items: List<LineItem>.from(formItems),
      subtotal: calculateSubtotal(),
      gstTotal: calculateGstTotal(),
      totalDue: calculateTotalDue(),
      signature: signatureController.text.trim(),
    );
    final index = invoices.indexWhere((i) => i.id == editingInvoice!.id);
    if (index != -1) {
      invoices[index] = updatedInvoice;
      filteredInvoices = List.from(invoices);
      clearForm();
      successMessage = 'Invoice updated successfully!';
    }
    notifyListeners();
  }

  void deleteInvoice(String invoiceId) {
    invoices.removeWhere((invoice) => invoice.id == invoiceId);
    filteredInvoices = List.from(invoices);
    successMessage = 'Invoice deleted successfully!';
    notifyListeners();
  }

  double calculateSubtotal() {
    return formItems.fold(0, (sum, item) => sum + item.amount);
  }

  double calculateGstTotal() {
    return formItems.fold(0, (sum, item) => sum + (item.amount * item.gstRate / 100));
  }

  double calculateTotalDue() {
    return calculateSubtotal() + calculateGstTotal();
  }

  bool validateForm() {
    error = null;
    if (invoiceNumberController.text.trim().isEmpty ||
        dueDateController.text.trim().isEmpty ||
        referenceController.text.trim().isEmpty ||
        billToController.text.trim().isEmpty ||
        formItems.isEmpty) {
      error = 'Please fill in all required fields and add at least one line item.';
      notifyListeners();
      return false;
    }
    return true;
  }

  void clearForm() {
    invoiceNumberController.clear();
    issueDateController.clear();
    dueDateController.clear();
    referenceController.clear();
    billToController.clear();
    signatureController.clear();
    formItems = [];
    editingInvoice = null;
    isEditMode = false;
    error = null;
    successMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    invoiceNumberController.dispose();
    issueDateController.dispose();
    dueDateController.dispose();
    referenceController.dispose();
    billToController.dispose();
    signatureController.dispose();
    super.dispose();
  }
}