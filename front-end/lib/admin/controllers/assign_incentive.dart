import 'package:flutter/material.dart';

class Seller {
  final String id;
  final String name;
  final double totalPoints;

  Seller({required this.id, required this.name, required this.totalPoints});

  Seller copyWith({String? id, String? name, double? totalPoints}) {
    return Seller(
      id: id ?? this.id,
      name: name ?? this.name,
      totalPoints: totalPoints ?? this.totalPoints,
    );
  }
}

class AdminAssignIncentiveController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  String? successMessage;
  final sellerIdController = TextEditingController();
  final pointsController = TextEditingController();

  void assignPoints() {
    final sellerId = sellerIdController.text.trim();
    final points = double.tryParse(pointsController.text.trim());
    if (sellerId.isEmpty || points == null || points <= 0) {
      error = 'Enter valid seller ID and points.';
      notifyListeners();
      return;
    }
    successMessage = 'Points assigned.';
    error = null;
    notifyListeners();
    sellerIdController.clear();
    pointsController.clear();
  }

  void clearMessages() {
    error = null;
    successMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    sellerIdController.dispose();
    pointsController.dispose();
    super.dispose();
  }
} 