import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int stock;
  final String status; // 'active' or 'inactive'
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.stock,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? price,
    int? stock,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AdminManageProductsController extends ChangeNotifier {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  bool isLoading = false;
  String? error;
  String? successMessage;

  // Search and filter
  String searchQuery = '';
  String selectedCategory = 'All';
  String selectedStatus = 'All';

  // Form controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  String selectedProductStatus = 'active';

  // Edit mode
  Product? editingProduct;
  bool isEditMode = false;

  // Available statuses
  final List<String> availableStatuses = ['active', 'inactive'];

  // Available categories (could be dynamic in real app)
  final List<String> availableCategories = [
    'All',
    'Electronics',
    'Apparel',
    'Home',
    'Sports',
    'Other',
  ];

  AdminManageProductsController() {
    // Initialize with dummy product data
    products = [
      Product(
        id: '1',
        name: 'Premium Smartphone',
        description: 'Latest smartphone with advanced features and high-quality camera',
        category: 'Electronics',
        price: 72999,
        stock: 50,
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
    filteredProducts = List.from(products);
    notifyListeners();
  }

  void searchProducts(String query) {
    searchQuery = query;
    applyFilters();
  }

  void filterByCategory(String category) {
    selectedCategory = category;
    applyFilters();
  }

  void filterByStatus(String status) {
    selectedStatus = status;
    applyFilters();
  }

  void applyFilters() {
    filteredProducts = products.where((product) {
      bool matchesSearch = searchQuery.isEmpty ||
          product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesCategory = selectedCategory == 'All' || product.category == selectedCategory;
      bool matchesStatus = selectedStatus == 'All' || product.status == selectedStatus;
      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
    notifyListeners();
  }

  void addProduct() {
    if (!validateForm()) return;
    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      category: categoryController.text.trim(),
      price: double.parse(priceController.text.trim()),
      stock: int.parse(stockController.text.trim()),
      status: selectedProductStatus,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    products.add(newProduct);
    applyFilters();
    clearForm();
    successMessage = 'Product added successfully!';
    notifyListeners();
  }

  void editProduct(Product product) {
    editingProduct = product;
    isEditMode = true;
    nameController.text = product.name;
    descriptionController.text = product.description;
    categoryController.text = product.category;
    priceController.text = product.price.toString();
    stockController.text = product.stock.toString();
    selectedProductStatus = product.status;
    notifyListeners();
  }

  void updateProduct() {
    if (editingProduct == null) return;
    if (!validateForm()) return;
    final updatedProduct = editingProduct!.copyWith(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      category: categoryController.text.trim(),
      price: double.parse(priceController.text.trim()),
      stock: int.parse(stockController.text.trim()),
      status: selectedProductStatus,
      updatedAt: DateTime.now(),
    );
    final index = products.indexWhere((p) => p.id == editingProduct!.id);
    if (index != -1) {
      products[index] = updatedProduct;
      applyFilters();
      clearForm();
      successMessage = 'Product updated successfully!';
    }
    notifyListeners();
  }

  void deleteProduct(String productId) {
    products.removeWhere((product) => product.id == productId);
    applyFilters();
    successMessage = 'Product deleted successfully!';
    notifyListeners();
  }

  void updatePrice(String productId, double newPrice) {
    final index = products.indexWhere((p) => p.id == productId);
    if (index != -1 && newPrice > 0) {
      products[index] = products[index].copyWith(price: newPrice, updatedAt: DateTime.now());
      applyFilters();
      successMessage = 'Price updated!';
      notifyListeners();
    }
  }

  void updateStock(String productId, int newStock) {
    final index = products.indexWhere((p) => p.id == productId);
    if (index != -1 && newStock >= 0) {
      products[index] = products[index].copyWith(stock: newStock, updatedAt: DateTime.now());
      applyFilters();
      successMessage = 'Stock updated!';
      notifyListeners();
    }
  }

  bool validateForm() {
    error = null;
    if (nameController.text.trim().isEmpty ||
        categoryController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        stockController.text.trim().isEmpty) {
      error = 'Please fill in all required fields.';
      notifyListeners();
      return false;
    }
    final price = double.tryParse(priceController.text.trim());
    final stock = int.tryParse(stockController.text.trim());
    if (price == null || price <= 0) {
      error = 'Price must be a positive number.';
      notifyListeners();
      return false;
    }
    if (stock == null || stock < 0) {
      error = 'Stock must be zero or a positive integer.';
      notifyListeners();
      return false;
    }
    return true;
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    categoryController.clear();
    priceController.clear();
    stockController.clear();
    selectedProductStatus = 'active';
    editingProduct = null;
    isEditMode = false;
    error = null;
    successMessage = null;
    notifyListeners();
  }

  void clearMessages() {
    error = null;
    successMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }
}   