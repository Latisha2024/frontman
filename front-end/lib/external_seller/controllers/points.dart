import 'package:flutter/material.dart';

class ExternalSellerPointsController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  dynamic points;

  void fetchPoints(String sellerId) {
    isLoading = true;
    error = null;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (sellerId.isEmpty) {
        error = 'Seller ID required';
        points = null;
      } else {
        points = [];
        error = null;
      }
      isLoading = false;
      notifyListeners();
    });
  }
} 