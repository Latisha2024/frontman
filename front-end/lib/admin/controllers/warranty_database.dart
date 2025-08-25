import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Warranty {
  final String id;
  final String product;
  final String customer;
  final String serialNumber;
  final DateTime purchaseDate;
  final DateTime expiryDate;
  final String companyId;

  Warranty({
    required this.id,
    required this.product,
    required this.customer,
    required this.serialNumber,
    required this.purchaseDate,
    required this.expiryDate,
    required this.companyId,
  });

  Warranty copyWith({
    String? id,
    String? product,
    String? customer,
    String? serialNumber,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    String? companyId,
  }) {
    return Warranty(
      id: id ?? this.id,
      product: product ?? this.product,
      customer: customer ?? this.customer,
      serialNumber: serialNumber ?? this.serialNumber,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      companyId: companyId ?? this.companyId,
    );
  }
}

class AdminWarrantyDatabaseController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  String? successMessage;
  List<Warranty> warranties = [];
  List<Warranty> filteredWarranties = [];
  String searchQuery = '';
  final productController = TextEditingController();
  String? currentCompanyId;
  String? get companyId => currentCompanyId;

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

  AdminWarrantyDatabaseController({String? companyId}) {
    // Initialize Dio
    _initializeDio();
    
    // Initialize with empty warranty data - will be loaded from API
    currentCompanyId = companyId;
    warranties = [];
    filteredWarranties = [];
    notifyListeners();
  }
  final customerController = TextEditingController();
  final serialController = TextEditingController();
  final purchaseDateController = TextEditingController();
  final expiryDateController = TextEditingController();
  Warranty? editingWarranty;
  bool isEditMode = false;

  void searchWarranties(String query) {
    searchQuery = query;
    applyFilters();
  }

  void applyFilters() {
    List<Warranty> companyFiltered = warranties;
    if (currentCompanyId != null) {
      companyFiltered = warranties.where((warranty) => warranty.companyId == currentCompanyId).toList();

    }
    filteredWarranties = companyFiltered.where((w) {
      final q = searchQuery.toLowerCase();
      return q.isEmpty ||
        w.product.toLowerCase().contains(q) ||
        w.customer.toLowerCase().contains(q) ||
        w.serialNumber.toLowerCase().contains(q);
    }).toList();
    notifyListeners();
  }

  void addWarranty() {
    if (productController.text.isEmpty || customerController.text.isEmpty || serialController.text.isEmpty || purchaseDateController.text.isEmpty || expiryDateController.text.isEmpty) {
      error = 'All fields are required.';
      notifyListeners();
      return;
    }
    final newWarranty = Warranty(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      product: productController.text.trim(),
      customer: customerController.text.trim(),
      serialNumber: serialController.text.trim(),
      purchaseDate: DateTime.parse(purchaseDateController.text.trim()),
      expiryDate: DateTime.parse(expiryDateController.text.trim()),
      companyId: currentCompanyId ?? 'company1',
    );
    warranties.add(newWarranty);
    applyFilters();
    clearForm();
    successMessage = 'Warranty added.';
    notifyListeners();
  }

  void editWarranty(Warranty warranty) {
    editingWarranty = warranty;
    isEditMode = true;
    productController.text = warranty.product;
    customerController.text = warranty.customer;
    serialController.text = warranty.serialNumber;
    purchaseDateController.text = warranty.purchaseDate.toIso8601String().split('T')[0];
    expiryDateController.text = warranty.expiryDate.toIso8601String().split('T')[0];
    notifyListeners();
  }

  void updateWarranty() {
    if (editingWarranty == null) return;
    if (productController.text.isEmpty || customerController.text.isEmpty || serialController.text.isEmpty || purchaseDateController.text.isEmpty || expiryDateController.text.isEmpty) {
      error = 'All fields are required.';
      notifyListeners();
      return;
    }
    final updatedWarranty = editingWarranty!.copyWith(
      product: productController.text.trim(),
      customer: customerController.text.trim(),
      serialNumber: serialController.text.trim(),
      purchaseDate: DateTime.parse(purchaseDateController.text.trim()),
      expiryDate: DateTime.parse(expiryDateController.text.trim()),
    );
    final index = warranties.indexWhere((w) => w.id == editingWarranty!.id);
    if (index != -1) {
      warranties[index] = updatedWarranty;
      applyFilters();
      clearForm();
      successMessage = 'Warranty updated.';
    }
    notifyListeners();
  }

  void deleteWarranty(String id) {
    warranties.removeWhere((w) => w.id == id);
    applyFilters();
    successMessage = 'Warranty deleted.';
    notifyListeners();
  }

  void clearForm() {
    productController.clear();
    customerController.clear();
    serialController.clear();
    purchaseDateController.clear();
    expiryDateController.clear();
    editingWarranty = null;
    isEditMode = false;
    error = null;
    successMessage = null;
    notifyListeners();
  }

  // GET /admin/warranty-cards - Fetch all warranty cards
  Future<List<Warranty>> fetchWarrantyCards() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final response = await _dio.get('/admin/warranty-cards');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<Warranty> fetchedWarranties = data.map((item) => Warranty(
          id: item['id'].toString(),
          product: item['product'] ?? '',
          customer: item['customer'] ?? '',
          serialNumber: item['serialNumber'] ?? '',
          purchaseDate: DateTime.parse(item['purchaseDate']),
          expiryDate: DateTime.parse(item['expiryDate']),
          companyId: item['companyId'] ?? '',
        )).toList();
        
        warranties = fetchedWarranties;
        applyFilters();
        successMessage = 'Warranty cards loaded successfully';
        return fetchedWarranties;
      } else {
        error = 'Failed to fetch warranty cards: ${response.statusCode}';
        notifyListeners();
        return [];
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        error = 'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        error = 'Server response timeout. Please try again.';
      } else if (e.response?.statusCode == 401) {
        error = 'Unauthorized access. Please login again.';
      } else if (e.response?.statusCode == 403) {
        error = 'Access forbidden. You do not have permission.';
      } else if (e.response?.statusCode == 500) {
        error = 'Server error. Please try again later.';
      } else {
        error = 'Network error: ${e.message}';
      }
      notifyListeners();
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
  
  // GET /admin/warranty-cards/{id} - Fetch specific warranty card by ID
  Future<Warranty?> fetchWarrantyCardById(String id) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final response = await _dio.get('/admin/warranty-cards/$id');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final warranty = Warranty(
          id: data['id'].toString(),
          product: data['product'] ?? '',
          customer: data['customer'] ?? '',
          serialNumber: data['serialNumber'] ?? '',
          purchaseDate: DateTime.parse(data['purchaseDate']),
          expiryDate: DateTime.parse(data['expiryDate']),
          companyId: data['companyId'] ?? '',
        );
        
        successMessage = 'Warranty card loaded successfully';
        notifyListeners();
        return warranty;
      } else {
        error = 'Failed to fetch warranty card: ${response.statusCode}';
        notifyListeners();
        return null;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        error = 'Warranty card not found';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        error = 'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        error = 'Server response timeout. Please try again.';
      } else if (e.response?.statusCode == 401) {
        error = 'Unauthorized access. Please login again.';
      } else if (e.response?.statusCode == 403) {
        error = 'Access forbidden. You do not have permission.';
      } else if (e.response?.statusCode == 500) {
        error = 'Server error. Please try again later.';
      } else {
        error = 'Network error: ${e.message}';
      }
      notifyListeners();
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
  
  // Helper method to refresh warranty cards from API
  Future<void> refreshWarrantyCards() async {
    await fetchWarrantyCards();
  }
  
  @override
  void dispose() {
    productController.dispose();
    customerController.dispose();
    serialController.dispose();
    purchaseDateController.dispose();
    expiryDateController.dispose();
    super.dispose();
  }
}