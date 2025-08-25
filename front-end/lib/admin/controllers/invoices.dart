import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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
  final String? orderId;
  final String? pdfUrl;

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
    this.orderId,
    this.pdfUrl,
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
    String? orderId,
    String? pdfUrl,
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
      orderId: orderId ?? this.orderId,
      pdfUrl: pdfUrl ?? this.pdfUrl,
    );
  }
}

class AdminInvoicesController extends ChangeNotifier {
  List<Invoice> invoices = [];
  List<Invoice> filteredInvoices = [];
  bool isLoading = false;
  String? error;
  String? successMessage;
  
  // Base URL for API calls - update this to match your backend
  static const String baseUrl = 'http://10.0.2.2:5000'; // Update with your actual backend URL
  
  // Dio instance for HTTP requests
  late final Dio _dio;

  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    
    // Add interceptors for logging and error handling
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
  }


  AdminInvoicesController() {
    // Initialize Dio
    _initializeDio();
    
    // Initialize with empty invoice data - will be loaded from API
    invoices = [];
    filteredInvoices = [];
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

  // GET /admin/invoices - Fetch all invoices
  Future<List<Invoice>> fetchInvoices({String? orderId, String? userId, String? startDate, String? endDate}) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final queryParams = <String, dynamic>{};
      if (orderId != null) queryParams['orderId'] = orderId;
      if (userId != null) queryParams['userId'] = userId;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;
      
      final response = await _dio.get('/admin/invoices', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<Invoice> fetchedInvoices = data.map((item) => _mapBackendInvoiceToModel(item)).toList();
        
        invoices = fetchedInvoices;
        filteredInvoices = List.from(invoices);
        successMessage = 'Invoices loaded successfully';
        return fetchedInvoices;
      } else {
        error = 'Failed to fetch invoices: ${response.statusCode}';
        notifyListeners();
        return [];
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return [];
    } catch (e) {
      error = 'Unexpected error: $e';
      notifyListeners();
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  // GET /admin/invoices/:id - Fetch specific invoice by ID
  Future<Invoice?> fetchInvoiceById(String id) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final response = await _dio.get('/admin/invoices/$id');
      
      if (response.statusCode == 200) {
        final invoice = _mapBackendInvoiceToModel(response.data);
        successMessage = 'Invoice loaded successfully';
        notifyListeners();
        return invoice;
      } else {
        error = 'Failed to fetch invoice: ${response.statusCode}';
        notifyListeners();
        return null;
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      error = 'Unexpected error: $e';
      notifyListeners();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  // POST - Create manual invoice (new endpoint for manual creation)
  Future<Invoice?> createManualInvoice() async {
    if (!validateForm()) return null;
    
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final invoiceData = {
        'invoiceNumber': invoiceNumberController.text.trim(),
        'issueDate': DateTime.now().toIso8601String(),
        'dueDate': DateTime.parse(dueDateController.text.trim()).toIso8601String(),
        'reference': referenceController.text.trim(),
        'billTo': billToController.text.trim(),
        'items': formItems.map((item) => {
          'description': item.description,
          'quantity': item.quantity,
          'unitPrice': item.unitPrice,
          'amount': item.amount,
          'gstRate': item.gstRate,
        }).toList(),
        'subtotal': calculateSubtotal(),
        'gstTotal': calculateGstTotal(),
        'totalAmount': calculateTotalDue(),
        'signature': signatureController.text.trim(),
      };
      
      final response = await _dio.post('/admin/invoices', data: invoiceData);
      
      if (response.statusCode == 201) {
        final invoice = _mapBackendInvoiceToModel(response.data['invoice']);
        invoices.add(invoice);
        filteredInvoices = List.from(invoices);
        clearForm();
        successMessage = 'Invoice created successfully!';
        notifyListeners();
        return invoice;
      } else {
        error = 'Failed to create invoice: ${response.statusCode}';
        notifyListeners();
        return null;
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      error = 'Unexpected error: $e';
      notifyListeners();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  // Generate invoice from existing order
  Future<Invoice?> generateInvoiceFromOrder(String orderId) async {
    // This endpoint does not exist on the backend. Keep the method, but avoid calling a non-existent API.
    isLoading = true;
    error = null;
    successMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 10));
    error = 'Generate from order is not supported by the current backend API.';
    isLoading = false;
    notifyListeners();
    return null;
  }
  
  // Helper method to refresh invoices from API
  Future<void> refreshInvoices() async {
    await fetchInvoices();
  }
  
  // Map backend invoice data to frontend model
  Invoice _mapBackendInvoiceToModel(Map<String, dynamic> data) {
    final orderItems = data['order']?['orderItems'] as List<dynamic>? ?? [];
    final items = orderItems.map((item) => LineItem(
      description: item['product']?['name'] ?? item['description'] ?? 'Unknown Product',
      quantity: item['quantity'] ?? 1,
      unitPrice: (item['unitPrice'] ?? item['product']?['price'] ?? 0.0).toDouble(),
      amount: ((item['unitPrice'] ?? 0.0) * (item['quantity'] ?? 1)).toDouble(),
      gstRate: 18.0, // Default GST rate
    )).toList();
    
    return Invoice(
      id: data['id'].toString(),
      invoiceNumber: data['invoiceNumber'] ?? 'INV-${data['id']}',
      issueDate: DateTime.parse(data['invoiceDate'] ?? data['issueDate'] ?? DateTime.now().toIso8601String()),
      dueDate: data['dueDate'] != null ? DateTime.parse(data['dueDate']) : DateTime.now().add(const Duration(days: 30)),
      reference: data['reference'] ?? data['orderId'] ?? '',
      billTo: data['billTo'] ?? data['order']?['user']?['name'] ?? 'Unknown Customer',
      items: items,
      subtotal: (data['subtotal'] ?? data['totalAmount'] ?? 0.0).toDouble(),
      gstTotal: (data['gstTotal'] ?? 0.0).toDouble(),
      totalDue: (data['totalAmount'] ?? data['totalDue'] ?? 0.0).toDouble(),
      signature: data['signature'],
      orderId: data['orderId'],
      pdfUrl: data['pdfUrl'],
    );
  }
  
  // Handle Dio errors
  void _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      error = 'Connection timeout. Please check your internet connection.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      error = 'Server response timeout. Please try again.';
    } else if (e.response?.statusCode == 401) {
      error = 'Unauthorized access. Please login again.';
    } else if (e.response?.statusCode == 403) {
      error = 'Access forbidden. You do not have permission.';
    } else if (e.response?.statusCode == 404) {
      error = 'Invoice not found.';
    } else if (e.response?.statusCode == 500) {
      error = 'Server error. Please try again later.';
    } else {
      error = 'Network error: ${e.message}';
    }
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