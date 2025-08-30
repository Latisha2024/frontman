import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/colors.dart';
import '../controllers/validate_warranty.dart';

class ValidateRegistrationWidget extends StatelessWidget {
  final ValidateWarrantyController controller;

  const ValidateRegistrationWidget({super.key, required this.controller});

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      await controller.decodeQrFromFile(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: controller.isLoading ? null : () => _pickImage(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonPrimary,
          ),
          child: const Text("Upload QR Image"),
        ),
        const SizedBox(height: 20),

        // Loader
        if (controller.isLoading)
          const Center(child: CircularProgressIndicator()),

        // Error
        if (controller.error != null)
          Text(
            controller.error!,
            style: const TextStyle(color: AppColors.error),
          ),

        // Warranty info
        if (controller.warrantyInfo != null) ...[
          _buildDataRow("Product ID", controller.warrantyInfo!.productId),
          _buildDataRow("Serial Number", controller.warrantyInfo!.serialNumber),
          _buildDataRow("Purchase Date", controller.warrantyInfo!.purchaseDate),
          _buildDataRow(
              "Warranty Months", controller.warrantyInfo!.warrantyMonths),
          _buildDataRow("Seller ID", controller.warrantyInfo!.sellerId),
        ],

        // Verification status
        if (controller.isVerified != null) ...[
          const SizedBox(height: 20),
          Text(
            controller.isVerified == true
                ? "✅ Warranty Verified"
                : "❌ Warranty Not Found",
            style: TextStyle(
              color: controller.isVerified == true ? Colors.green : Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: AppColors.surfaceVariant,
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
