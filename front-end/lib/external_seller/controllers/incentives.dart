import 'package:flutter/material.dart';

class ExternalSellerIncentivesController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  List<dynamic>? incentives;

  void fetchIncentives(String sellerId) {
    isLoading = true;
    error = null;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (sellerId.isEmpty) {
        error = 'Seller ID required';
        incentives = [];
      } else {
        incentives = [];
        error = null;
      }
      isLoading = false;
      notifyListeners();
    });
  }
}