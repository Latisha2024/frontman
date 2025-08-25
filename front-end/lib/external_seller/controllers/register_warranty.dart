import 'dart:convert';
import 'package:flutter/material.dart';

class ExternalSellerRegisterWarrantyController extends ChangeNotifier {
  final productIdController = TextEditingController();
  final serialNumberController = TextEditingController();
  final purchaseDateController = TextEditingController();
  final warrantyMonthsController = TextEditingController();
  final sellerIdController = TextEditingController();

  bool isLoading = false;
  String? error;
  bool? success;
  String? qrCodeData;

  void submitWarranty() {
    isLoading = true;
    error = null;
    success = null;
    qrCodeData = null;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (productIdController.text.isEmpty ||
          serialNumberController.text.isEmpty ||
          purchaseDateController.text.isEmpty ||
          warrantyMonthsController.text.isEmpty ||
          sellerIdController.text.isEmpty) {
        error = 'All fields are required.';
        success = false;
        qrCodeData = null;
      } else {
        success = true;
        error = null;

        final warrantyDetails = {
          'productId': productIdController.text,
          'serialNumber': serialNumberController.text,
          'purchaseDate': purchaseDateController.text,
          'warrantyMonths': warrantyMonthsController.text,
          'sellerId': sellerIdController.text,
        };

        qrCodeData = jsonEncode(warrantyDetails);
      }

      isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    productIdController.dispose();
    serialNumberController.dispose();
    purchaseDateController.dispose();
    warrantyMonthsController.dispose();
    sellerIdController.dispose();
    super.dispose();
  }
}
