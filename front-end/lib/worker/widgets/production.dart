import 'package:flutter/material.dart';
import '../controllers/production.dart';
import '../../constants/colors.dart';

class WorkerProductionForm extends StatelessWidget {
  final WorkerProductionController controller;
  final VoidCallback? onSubmit;
  final bool isLoading;

  const WorkerProductionForm({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product ID
          TextField(
            controller: controller.productIdController,
            decoration: const InputDecoration(
              labelText: 'Product ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Quantity
          TextField(
            controller: controller.quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Location
          TextField(
            controller: controller.locationController,
            decoration: const InputDecoration(
              labelText: 'Location',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Status Dropdown
          DropdownButtonFormField<String>(
            value: controller.status,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Available', child: Text('Available')),
              DropdownMenuItem(value: 'Damaged', child: Text('Damaged')),
              DropdownMenuItem(value: 'Moved', child: Text('Moved')),
            ],
            onChanged: isLoading
                ? null
                : (val) {
                    if (val != null) controller.status = val;
                  },
          ),
          const SizedBox(height: 24),

          // Submit Button
          ElevatedButton(
            onPressed: isLoading ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Submit', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
