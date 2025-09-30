import 'package:flutter/material.dart';
import '../controllers/manage_stock.dart';

class WorkerManageStockForm extends StatelessWidget {
  final WorkerManageStockController controller;
  final VoidCallback? onSubmit;
  final bool isLoading;

  const WorkerManageStockForm({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stock ID Input
            TextField(
              controller: controller.stockIdController,
              decoration: const InputDecoration(
                labelText: "Stock ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Status Dropdown
            DropdownButtonFormField<String>(
              value: controller.selectedStatus,
              items: ["Available", "Moved", "Sold"]
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) controller.selectedStatus = val;
              },
              decoration: const InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Location Input
            TextField(
              controller: controller.locationController,
              decoration: const InputDecoration(
                labelText: "Location",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // consistent theme
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Update Stock",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
