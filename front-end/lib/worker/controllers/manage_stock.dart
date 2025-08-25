import 'package:flutter/material.dart';

class WorkerManageStockController {
  final productIdController = TextEditingController();
  final quantityController = TextEditingController();
  final fromLocationController = TextEditingController();
  final toLocationController = TextEditingController();

  void dispose() {
    productIdController.dispose();
    quantityController.dispose();
    fromLocationController.dispose();
    toLocationController.dispose();
  }
}