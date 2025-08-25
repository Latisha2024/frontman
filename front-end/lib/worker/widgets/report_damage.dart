import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../controllers/report_damage.dart';

class WorkerReportDamageForm extends StatelessWidget {
  final WorkerReportDamageController controller;
  final VoidCallback onSubmit;
  final bool isLoading;

  const WorkerReportDamageForm({
    super.key,
    required this.controller,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: TextFormField(
              controller: controller.productIdController,
              decoration: const InputDecoration(labelText: 'Product ID:', border: InputBorder.none),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: TextFormField(
              controller: controller.quantityController,
              decoration: const InputDecoration(labelText: 'Quantity:', border: InputBorder.none),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: TextFormField(
              controller: controller.locationController,
              decoration: const InputDecoration(labelText: 'Location:', border: InputBorder.none),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isLoading ? null : onSubmit,
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Submit'),
          ),
        ],
      ),
    );
  }
} 