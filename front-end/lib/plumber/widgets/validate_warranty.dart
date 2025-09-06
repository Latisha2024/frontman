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

  Widget _buildInfoRow(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: AppColors.surfaceVariant,
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // <--- Wrap content with scrolling
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: controller.isLoading ? null : () => _pickImage(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonPrimary,
            ),
            icon: const Icon(Icons.image),
            label: const Text("Upload QR Image"),
          ),
          const SizedBox(height: 12),
          if (controller.isLoading)
            const Center(child: CircularProgressIndicator()),
          if (controller.error != null) ...[
            const SizedBox(height: 12),
            Text(controller.error!,
                style: const TextStyle(color: AppColors.error)),
          ],
          const SizedBox(height: 12),
          if (controller.warrantyInfo != null) ...[
            _buildInfoRow(
                'Product ID / Name',
                controller.warrantyInfo!.productName.isNotEmpty
                    ? controller.warrantyInfo!.productName
                    : controller.warrantyInfo!.productId),
            _buildInfoRow(
                'Serial Number', controller.warrantyInfo!.serialNumber),
            _buildInfoRow(
                'Purchase Date', controller.warrantyInfo!.purchaseDate),
            _buildInfoRow('Warranty Months',
                controller.warrantyInfo!.warrantyMonths.toString()),
            _buildInfoRow('Seller', controller.warrantyInfo!.sellerName),
            if (controller.warrantyInfo!.registeredAt != null)
              _buildInfoRow('Registered At',
                  controller.warrantyInfo!.registeredAt!.toLocal().toString()),
            if (controller.warrantyInfo!.expiryDate != null)
              _buildInfoRow('Expiry Date',
                  controller.warrantyInfo!.expiryDate!.toLocal().toString()),
          ],
          const SizedBox(height: 12),
          if (controller.isVerified != null) ...[
            Text(
              controller.isVerified == true
                  ? '✅ Warranty Verified'
                  : '❌ Warranty Not Found',
              style: TextStyle(
                color:
                    controller.isVerified == true ? Colors.green : Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => controller.clear(),
              child: const Text('Clear'),
            ),
          ],
          const SizedBox(height: 24), // Add some padding at the bottom
        ],
      ),
    );
  }
}
