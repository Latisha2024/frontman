import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../controllers/delivery_report.dart';

class DeliveryReportForm extends StatelessWidget {
  final PlumberDeliveryReportController controller;
  final VoidCallback onSubmit;
  final bool isLoading;

  const DeliveryReportForm({
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
          _buildTextField(controller.productController, 'Product'),
          _buildTextField(
            controller.quantityController,
            'Quantity',
            keyboardType: TextInputType.number,
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

  Widget _buildTextField(TextEditingController ctrl, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Container(
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
        controller: ctrl,
        decoration: InputDecoration(labelText: label, border: InputBorder.none),
        keyboardType: keyboardType,
      ),
    );
  }
}
