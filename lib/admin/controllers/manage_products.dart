import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int stock;
  final String status; // 'active' or 'inactive'
  final String companyId; // Company this product belongs to
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
    required this.companyId,
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
    String? companyId,
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
      companyId: companyId ?? this.companyId,
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
  String? currentCompanyId;

  // Getter for current company ID
  String? get companyId => currentCompanyId;

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

  // Available categories (could be dynamic)
  List<String> availableCategories = [
    'All',
    'Electronics',
    'Apparel',
    'Home',
    'Sports',
    'Industrial',
    'Safety',
    'Tools',
    'Other',
  ];

  AdminManageProductsController({String? companyId}) {
    currentCompanyId = companyId;
    products = [
      // Company 1 products
      Product(
        id: '1',
        name: 'Premium Smartphone',
        description: 'Latest smartphone with advanced features and high-quality camera',
        category: 'Electronics',
        price: 72999,
        stock: 50,
        status: 'active',
        companyId: 'company1',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Product(
        id: '2',
        name: 'Gaming Laptop',
        description: 'High-performance gaming laptop with RTX graphics',
        category: 'Electronics',
        price: 89999,
        stock: 25,
        status: 'active',
        companyId: 'company1',
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Product(
        id: '3',
        name: 'Wireless Headphones',
        description: 'Noise-cancelling wireless headphones with premium sound quality',
        category: 'Electronics',
        price: 15999,
        stock: 100,
        status: 'active',
        companyId: 'company1',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      // Company 2 products
      Product(
        id: '4',
        name: 'Industrial Machine',
        description: 'Heavy-duty industrial manufacturing machine',
        category: 'Industrial',
        price: 250000,
        stock: 5,
        status: 'active',
        companyId: 'company2',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Product(
        id: '5',
        name: 'Safety Equipment',
        description: 'Complete safety equipment set for industrial workers',
        category: 'Safety',
        price: 45000,
        stock: 75,
        status: 'active',
        companyId: 'company2',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Product(
        id: '6',
        name: 'Factory Tools',
        description: 'Professional grade tools for manufacturing processes',
        category: 'Tools',
        price: 35000,
        stock: 40,
        status: 'active',
        companyId: 'company2',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
    filteredProducts = List.from(products);
    applyFilters(); // Apply filters immediately
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

    List<Product> companyFiltered = products;
    if (currentCompanyId != null) {
      companyFiltered = products.where((product) => product.companyId == currentCompanyId).toList();

    }

    // Then apply other filters
    filteredProducts = companyFiltered.where((product) {
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
      companyId: currentCompanyId ?? 'company1',
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

  // Category management methods
  void addCategory(String categoryName) {
    if (categoryName.trim().isEmpty) {
      error = 'Category name cannot be empty.';
      notifyListeners();
      return;
    }
    
    if (availableCategories.contains(categoryName.trim())) {
      error = 'Category already exists.';
      notifyListeners();
      return;
    }
    
    availableCategories.add(categoryName.trim());
    error = null;
    successMessage = 'Category "${categoryName.trim()}" added successfully!';
    notifyListeners();
  }

  void renameCategory(String oldName, String newName) {
    if (newName.trim().isEmpty) {
      error = 'Category name cannot be empty.';
      notifyListeners();
      return;
    }
    
    if (oldName == 'All' || oldName == 'All') {
      error = 'Cannot rename the "All" category.';
      notifyListeners();
      return;
    }
    
    if (availableCategories.contains(newName.trim())) {
      error = 'Category name already exists.';
      notifyListeners();
      return;
    }
    
    final index = availableCategories.indexOf(oldName);
    if (index != -1) {
      availableCategories[index] = newName.trim();
      
      // Update all products with the old category name
      for (int i = 0; i < products.length; i++) {
        if (products[i].category == oldName) {
          products[i] = products[i].copyWith(category: newName.trim());
        }
      }
      
      error = null;
      successMessage = 'Category renamed from "$oldName" to "${newName.trim()}" successfully!';
      applyFilters();
      notifyListeners();
    }
  }

  void deleteCategory(String categoryName) {
    if (categoryName == 'All') {
      error = 'Cannot delete the "All" category.';
      notifyListeners();
      return;
    }
    
    // Check if any products are using this category
    final productsWithCategory = products.where((p) => p.category == categoryName).length;
    if (productsWithCategory > 0) {
      error = 'Cannot delete category "$categoryName" because $productsWithCategory product(s) are using it.';
      notifyListeners();
      return;
    }
    
    availableCategories.remove(categoryName);
    error = null;
    successMessage = 'Category "$categoryName" deleted successfully!';
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