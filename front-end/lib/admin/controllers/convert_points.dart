import 'package:flutter/material.dart';

class AdminConvertPointsController extends ChangeNotifier {
  final sellerIdController = TextEditingController();
  final pointsController = TextEditingController();

  bool isLoading = false;
  String? error;
  String? successMessage;
  double? convertedAmount;

  void convertPointsToCash() {
    isLoading = true;
    error = null;
    successMessage = null;
    convertedAmount = null;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 500), () {
      final sellerId = sellerIdController.text.trim();
      final pointsStr = pointsController.text.trim();
      if (sellerId.isEmpty || pointsStr.isEmpty) {
        error = 'Please enter both Seller ID and Points.';
        isLoading = false;
        notifyListeners();
        return;
      }
      final points = double.tryParse(pointsStr);
      if (points == null || points <= 0) {
        error = 'Points must be a positive number.';
        isLoading = false;
        notifyListeners();
        return;
      }
      convertedAmount = points * 0.5;
      successMessage = 'Points converted successfully!';
      error = null;
      isLoading = false;
      notifyListeners();
    });
  }

  void clear() {
    sellerIdController.clear();
    pointsController.clear();
    error = null;
    successMessage = null;
    convertedAmount = null;
    notifyListeners();
  }

  @override
  void dispose() {
    sellerIdController.dispose();
    pointsController.dispose();
    super.dispose();
  }
} 