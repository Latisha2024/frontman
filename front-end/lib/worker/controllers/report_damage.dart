import 'package:flutter/material.dart';

class WorkerReportDamageController {
  final productIdController = TextEditingController();
  final quantityController = TextEditingController();
  final locationController = TextEditingController();

  void dispose() {
    productIdController.dispose();
    quantityController.dispose();
    locationController.dispose();
  }
} 