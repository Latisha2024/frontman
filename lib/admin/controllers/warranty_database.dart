import 'package:flutter/material.dart';

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