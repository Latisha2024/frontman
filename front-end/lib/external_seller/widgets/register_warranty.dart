import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../constants/colors.dart';
import '../controllers/register_warranty.dart';

class RegisterWarrantyForm extends StatelessWidget {
  final ExternalSellerRegisterWarrantyController controller;
  final VoidCallback onSubmit;
  final bool isLoading;

  const RegisterWarrantyForm({
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
              decoration: const InputDecoration(
                  labelText: 'Product ID:', border: InputBorder.none),
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
              controller: controller.serialNumberController,
              decoration: const InputDecoration(
                  labelText: 'Serial Number:', border: InputBorder.none),
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
              controller: controller.purchaseDateController,
              decoration: const InputDecoration(
                  labelText: 'Purchase Date (YYYY-MM-DD):',
                  border: InputBorder.none),
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
              controller: controller.warrantyMonthsController,
              decoration: const InputDecoration(
                  labelText: 'Warranty Months:', border: InputBorder.none),
              keyboardType: TextInputType.number,
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
              controller: controller.sellerIdController,
              decoration: const InputDecoration(
                  labelText: 'Seller ID:', border: InputBorder.none),
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
                : const Text('Register Warranty'),
          ),
        ],
      ),
    );
  }
}

class QRCodeDisplay extends StatelessWidget {
  final String qrCodeData;

  const QRCodeDisplay({super.key, required this.qrCodeData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Generated QR Code:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            QrImageView(
              data: qrCodeData,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 16),
            const Text(
              'QR Code generated successfully!',
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
