import 'package:flutter/material.dart';

class ExternalSellerDeliveryReportController extends ChangeNotifier {
  final sellerIdController = TextEditingController();
  final productController = TextEditingController();
  final quantityController = TextEditingController();
  bool qrRequested = false;

  bool isLoading = false;
  String? error;
  bool? success;

  void submitReport() {
    isLoading = true;
    error = null;
    success = null;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (sellerIdController.text.isEmpty || productController.text.isEmpty || quantityController.text.isEmpty) {
        error = 'All fields are required.';
        success = false;
      } else {
        success = true;
        error = null;
      }
      isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    sellerIdController.dispose();
    productController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}