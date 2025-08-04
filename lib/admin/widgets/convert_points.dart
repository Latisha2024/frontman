import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../controllers/convert_points.dart';

class ConvertPointsToCashForm extends StatelessWidget {
  final AdminConvertPointsController controller;
  const ConvertPointsToCashForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Column(
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
              child: TextField(
                controller: controller.sellerIdController,
                decoration: const InputDecoration(
                  labelText: 'Seller ID',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
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
              child: TextField(
                controller: controller.pointsController,
                decoration: const InputDecoration(
                  labelText: 'Points to Convert',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: controller.isLoading ? null : controller.convertPointsToCash,
              child: controller.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Convert'),
            ),
          ],
        );
      },
    );
  }
}