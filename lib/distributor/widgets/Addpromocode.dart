// apply_promo_page.dart
import 'package:flutter/material.dart';
import 'package:role_based_app/constants/colors.dart';

class ApplyPromoPage extends StatefulWidget {
  const ApplyPromoPage({super.key});

  @override
  State<ApplyPromoPage> createState() => _ApplyPromoPageState();
}

class _ApplyPromoPageState extends State<ApplyPromoPage> {
  final promoCodeController = TextEditingController();
  String message = '';

  void applyPromo() {
    final code = promoCodeController.text.trim();
    if (code.isEmpty) {
      setState(() => message = 'Please enter a promo code');
      return;
    }
    setState(() => message = 'Promo code "$code" applied successfully!');
  }

  @override
  void dispose() {
    promoCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Apply Promo Code"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: promoCodeController,
              decoration: const InputDecoration(
                labelText: "Enter Promo Code",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: applyPromo,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text("Apply Code"),
            ),
            const SizedBox(height: 12),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
