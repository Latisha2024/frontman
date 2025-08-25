import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../controllers/assign_incentive.dart';

class AssignIncentiveForm extends StatelessWidget {
  final AdminAssignIncentiveController controller;
  final VoidCallback onSubmit;
  final bool isLoading;

  const AssignIncentiveForm({
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
              controller: controller.sellerIdController,
              decoration: const InputDecoration(labelText: 'Seller ID:', border: InputBorder.none),
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
              controller: controller.pointsController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Points to Add:', border: InputBorder.none),
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
                : const Text('Assign Points'),
          ),
        ],
      ),
    );
  }
} 