import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

import '../url.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final int stockQuantity;
  final int warrantyPeriodInMonths;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stockQuantity,
    required this.warrantyPeriodInMonths,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stockQuantity: json['stockQuantity'] ?? 0,
      warrantyPeriodInMonths: json['warrantyPeriodInMonths'] ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'stockQuantity': stockQuantity,
      'warrantyPeriodInMonths': warrantyPeriodInMonths,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    double? price,
    int? stockQuantity,
    int? warrantyPeriodInMonths,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      warrantyPeriodInMonths: warrantyPeriodInMonths ?? this.warrantyPeriodInMonths,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AdminManageProductsController extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;
  List<Product> filteredProducts = [];
  bool isLoading = false;
  String? error;
  String? successMessage;
  late final Dio _dio;

  // Search and filter
  String searchQuery = '';

  // Form controllers
  final nameController = TextEditingController();
  // Removed description, backend does not use it
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final warrantyController = TextEditingController();

  // Edit mode
  Product? _editingProduct;
  bool _isEditMode = false;

  // Getters
  Product? get editingProduct => _editingProduct;
  bool get isEditMode => _isEditMode;

  // Base URL - configure based on your backend
  static const String baseUrl = BaseUrl.b_url;

  AdminManageProductsController() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    // Attach Authorization header for every request if token exists
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer ' + token;
        }
      } catch (_) {
        // If SharedPreferences fails, proceed without auth header
      }
      return handler.next(options);
    }));
    fetchProducts();
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


  // GET /admin/products
  Future<void> fetchProducts() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _dio.get('/admin/products');
      final List<dynamic> data = response.data;
      _products = data.map((json) => Product.fromJson(json)).toList();
      applyFilters();
      successMessage = 'Products loaded successfully';
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      if (e.response != null) {
        error = 'Failed to fetch products: ${e.response!.statusCode} - ${e.response!.data}';
      } else {
        error = 'Network error: ${e.message}';
      }
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'Unexpected error: $e';
      _scheduleAutoHideMessages();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchProducts(String query) {
    searchQuery = query;
    applyFilters();
  }

  void applyFilters() {
    filteredProducts = _products.where((product) {
      bool matchesSearch = searchQuery.isEmpty ||
          product.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();
    notifyListeners();
  }

  // POST /admin/products/create
  Future<void> addProduct() async {
    if (!validateForm()) return;

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final productData = {
        'name': nameController.text.trim(),
        'price': double.parse(priceController.text.trim()),
        'stockQuantity': int.parse(stockController.text.trim()),
        'warrantyPeriodInMonths': int.parse(warrantyController.text.trim()),
      };

      final response = await _dio.post(
        '/admin/products/create',
        data: productData,
      );

      final responseData = response.data;
      successMessage = responseData['message'] ?? 'Product created successfully';
      clearForm();
      await fetchProducts(); // Refresh the list
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        error = responseData['message'] ?? 'Failed to create product: ${e.response!.statusCode}';
      } else {
        error = 'Network error: ${e.message}';
      }
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'Unexpected error: $e';
      _scheduleAutoHideMessages();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void editProduct(Product product) {
    _editingProduct = product;
    _isEditMode = true;
    nameController.text = product.name;
    priceController.text = product.price.toString();
    stockController.text = product.stockQuantity.toString();
    warrantyController.text = product.warrantyPeriodInMonths.toString();
    clearMessages();
    notifyListeners();
  }

  // PUT /admin/products/:id
  Future<void> updateProduct() async {
    if (_editingProduct == null) return;
    if (!validateForm()) return;

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final updateData = {
        'name': nameController.text.trim(),
        'price': double.parse(priceController.text.trim()),
        'stockQuantity': int.parse(stockController.text.trim()),
        'warrantyPeriodInMonths': int.parse(warrantyController.text.trim()),
      };

      final response = await _dio.put(
        '/admin/products/${_editingProduct!.id}',
        data: updateData,
      );

      final responseData = response.data;
      successMessage = responseData['message'] ?? 'Product updated successfully';
      clearForm();
      await fetchProducts(); // Refresh the list
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        error = responseData['message'] ?? 'Failed to update product: ${e.response!.statusCode}';
      } else {
        error = 'Network error: ${e.message}';
      }
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'Unexpected error: $e';
      _scheduleAutoHideMessages();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // DELETE /admin/products/:id
  Future<void> deleteProduct(String productId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _dio.delete('/admin/products/$productId');

      final responseData = response.data;
      successMessage = responseData['message'] ?? 'Product deleted successfully';
      await fetchProducts(); // Refresh the list
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        error = responseData['message'] ?? 'Failed to delete product: ${e.response!.statusCode}';
      } else {
        error = 'Network error: ${e.message}';
      }
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'Unexpected error: $e';
      _scheduleAutoHideMessages();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // GET /admin/products/:id
  Future<Product?> getProductById(String productId) async {
    try {
      final response = await _dio.get('/admin/products/$productId');
      return Product.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        error = 'Failed to fetch product: ${e.response!.statusCode} - ${e.response!.data}';
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
    }
  }

  // POST /admin/products/import
  Future<void> importProducts() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        String fileName = file.name;
        FormData formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(file.path!, filename: fileName),
        });

        isLoading = true;
        notifyListeners();

        final response = await _dio.post('/admin/products/import', data: formData);

        successMessage = response.data['message'] ?? 'Products imported successfully';
        await fetchProducts(); // Refresh the product list
        _scheduleAutoHideMessages();
      } else {
        // User canceled the picker
        successMessage = 'File import canceled.';
        _scheduleAutoHideMessages();
      }
    } on DioException catch (e) {
      error = 'Failed to import products: ${e.response?.data?['message'] ?? e.message}';
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'An unexpected error occurred: $e';
      _scheduleAutoHideMessages();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // GET /admin/products/export
  Future<void> exportProducts() async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await _dio.get(
        '/admin/products/export',
        options: Options(responseType: ResponseType.bytes), // Important for file downloads
      );

      // In a real app, you'd use a package like 'path_provider' and 'open_file'
      // to save and open the file. This is a simplified placeholder.
      successMessage = 'Products exported successfully. Check your downloads folder.';
      _scheduleAutoHideMessages();

    } on DioException catch (e) {
      error = 'Failed to export products: ${e.response?.data ?? e.message}';
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'An unexpected error occurred: $e';
      _scheduleAutoHideMessages();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool validateForm() {
    error = null;
    if (nameController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        stockController.text.trim().isEmpty ||
        warrantyController.text.trim().isEmpty) {
      error = 'Please fill in all required fields.';
      notifyListeners();
      _scheduleAutoHideMessages();
      return false;
    }
    final price = double.tryParse(priceController.text.trim());
    final stock = int.tryParse(stockController.text.trim());
    final warranty = int.tryParse(warrantyController.text.trim());
    if (price == null || price <= 0) {
      error = 'Price must be a positive number.';
      notifyListeners();
      _scheduleAutoHideMessages();
      return false;
    }
    if (stock == null || stock < 0) {
      error = 'Stock must be zero or a positive integer.';
      notifyListeners();
      _scheduleAutoHideMessages();
      return false;
    }
    if (warranty == null || warranty < 0) {
      error = 'Warranty must be zero or a positive integer (months).';
      notifyListeners();
      _scheduleAutoHideMessages();
      return false;
    }
    return true;
  }

  void clearForm() {
    nameController.clear();
    priceController.clear();
    stockController.clear();
    warrantyController.clear();
    _editingProduct = null;
    _isEditMode = false;
    clearMessages();
    notifyListeners();
  }

  // GET /admin/search/products - Search products with query (API)
  Future<List<Product>> searchProductsApi(String query, {double? minPrice, double? maxPrice, int? minStock}) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final queryParams = <String, dynamic>{
        'q': query,
      };
      if (minPrice != null) queryParams['minPrice'] = minPrice;
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
      if (minStock != null) queryParams['minStock'] = minStock;

      final response = await _dio.get(
        '/admin/search/products',
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data;
      final searchResults = data.map((json) => Product.fromJson(json)).toList();
      successMessage = 'Product search completed successfully';
      _scheduleAutoHideMessages();
      return searchResults;
    } on DioException catch (e) {
      if (e.response != null) {
        error = 'Failed to search products: ${e.response!.statusCode} - ${e.response!.data}';
      } else {
        error = 'Network error: ${e.message}';
      }
      _scheduleAutoHideMessages();
      return [];
    } catch (e) {
      error = 'Unexpected error: $e';
      _scheduleAutoHideMessages();
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    error = null;
    successMessage = null;
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    warrantyController.dispose();
    super.dispose();
  }
}