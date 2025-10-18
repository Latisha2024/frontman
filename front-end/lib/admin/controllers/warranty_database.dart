import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../url.dart';

class Warranty {
  final String id;
  final String product;
  final String customer;
  final String serialNumber;
  final DateTime purchaseDate;
  final DateTime expiryDate;

  Warranty({
    required this.id,
    required this.product,
    required this.customer,
    required this.serialNumber,
    required this.purchaseDate,
    required this.expiryDate,
  });

  Warranty copyWith({
    String? id,
    String? product,
    String? customer,
    String? serialNumber,
    DateTime? purchaseDate,
    DateTime? expiryDate,
  }) {
    return Warranty(
      id: id ?? this.id,
      product: product ?? this.product,
      customer: customer ?? this.customer,
      serialNumber: serialNumber ?? this.serialNumber,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
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

  static const String baseUrl = BaseUrl.b_url;
  late final Dio _dio;
  
  String _asString(dynamic v) {
    if (v == null) return '';
    if (v is String) return v;
    if (v is num || v is bool) return v.toString();
    if (v is Map) {
      for (final key in const ['name', 'title', 'label', 'value', 'id', '_id']) {
        if (v[key] is String) return v[key] as String;
      }
    }
    return v.toString();
  }

  DateTime _asDate(dynamic v) {
    if (v is DateTime) return v;
    if (v is String) return DateTime.parse(v);
    if (v is Map) {
      for (final key in const ['date', 'iso', '\$date']) {
        final val = v[key];
        if (val is String) return DateTime.parse(val);
        if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      }
    }
    return DateTime.parse(v.toString());
  }
  
  void _initializeDio() {
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
  }

  AdminWarrantyDatabaseController() {
    _initializeDio();
    
    warranties = [];
    filteredWarranties = [];
    notifyListeners();
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
    filteredWarranties = warranties.where((w) {
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
      _scheduleAutoHideMessages();
      return;
    }
    final newWarranty = Warranty(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      product: productController.text.trim(),
      customer: customerController.text.trim(),
      serialNumber: serialController.text.trim(),
      purchaseDate: DateTime.parse(purchaseDateController.text.trim()),
      expiryDate: DateTime.parse(expiryDateController.text.trim()),
    );
    warranties.add(newWarranty);
    applyFilters();
    clearForm();
    successMessage = 'Warranty added.';
    notifyListeners();
    _scheduleAutoHideMessages();
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
      _scheduleAutoHideMessages();
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
    _scheduleAutoHideMessages();
  }

  void deleteWarranty(String id) {
    warranties.removeWhere((w) => w.id == id);
    applyFilters();
    successMessage = 'Warranty deleted.';
    notifyListeners();
    _scheduleAutoHideMessages();
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

  Future<List<Warranty>> fetchWarrantyCards() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final response = await _dio.get('/admin/warranty-cards');
      
      if (response.statusCode == 200) {
        final dynamic body = response.data;
        final List<dynamic> data = body is List ? body : (body['data'] as List? ?? []);
        final List<Warranty> fetchedWarranties = data.map((item) {
          final map = item as Map<String, dynamic>;
          return Warranty(
            id: _asString(map['id']).isNotEmpty ? _asString(map['id']) : _asString(map['_id']),
            product: _asString(map['product']),
            customer: _asString(map['customer']),
            serialNumber: _asString(map['serialNumber']),
            purchaseDate: _asDate(map['purchaseDate']),
            expiryDate: _asDate(map['expiryDate']),
          );
        }).toList();
        
        warranties = fetchedWarranties;
        applyFilters();
        successMessage = 'Warranty cards loaded successfully';
        _scheduleAutoHideMessages();
        return fetchedWarranties;
      } else {
        error = 'Failed to fetch warranty cards: ${response.statusCode}';
        notifyListeners();
        _scheduleAutoHideMessages();
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
      _scheduleAutoHideMessages();
      return [];
    } catch (e) {
      error = 'Unexpected error: $e';
      notifyListeners();
      _scheduleAutoHideMessages();
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  Future<Warranty?> fetchWarrantyCardById(String id) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final response = await _dio.get('/admin/warranty-cards/$id');
      
      if (response.statusCode == 200) {
        final dynamic body = response.data;
        final Map<String, dynamic> data = body is Map<String, dynamic> && body.containsKey('data')
            ? (body['data'] as Map<String, dynamic>)
            : (body as Map<String, dynamic>);
        final warranty = Warranty(
          id: _asString(data['id']).isNotEmpty ? _asString(data['id']) : _asString(data['_id']),
          product: _asString(data['product']),
          customer: _asString(data['customer']),
          serialNumber: _asString(data['serialNumber']),
          purchaseDate: _asDate(data['purchaseDate']),
          expiryDate: _asDate(data['expiryDate']),
        );
        
        successMessage = 'Warranty card loaded successfully';
        notifyListeners();
        _scheduleAutoHideMessages();
        return warranty;
      } else {
        error = 'Failed to fetch warranty card: ${response.statusCode}';
        notifyListeners();
        _scheduleAutoHideMessages();
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
      _scheduleAutoHideMessages();
      return null;
    } catch (e) {
      error = 'Unexpected error: $e';
      notifyListeners();
      _scheduleAutoHideMessages();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
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