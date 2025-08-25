import 'package:flutter/material.dart';

class WorkerProductionController {
  final productIdController = TextEditingController();
  final quantityController = TextEditingController();
  final locationController = TextEditingController();
  String status = 'Available';

  void dispose() {
    productIdController.dispose();
    quantityController.dispose();
    locationController.dispose();
  }
}
