// apply_promo_page.dart
import 'package:flutter/material.dart';
import 'package:role_based_app/constants/colors.dart';

class ApplyPromoPage extends StatefulWidget {
  const ApplyPromoPage({super.key});

  @override
  State<ApplyPromoPage> createState() => _ApplyPromoPageState();
}

class _ApplyPromoPageState extends State<ApplyPromoPage> {
  final promoCodeController = TextEditingController(text: 'DEMO2025'); // Demo placeholder
  String message = '';

  void applyPromo() {
    final code = promoCodeController.text.trim();
    if (code.isEmpty) {
      setState(() => message = '❗ Please enter a promo code.');
      return;
    }

    // Simulated logic for demo
    if (code == 'DEMO2025') {
      setState(() => message = '✅ Promo code "$code" applied successfully! You saved 20%.');
    } else {
      setState(() => message = '❌ Invalid promo code "$code". Please try again.');
    }
  }

  @override
  void dispose() {
    promoCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Apply Promo Code"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Enter your promo code below to apply discounts",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: promoCodeController,
                  decoration: InputDecoration(
                    labelText: "Promo Code",
                    hintText: "e.g. DEMO2025",
                    filled: true,
                    fillColor: AppColors.inputFill,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: applyPromo,
                  icon: const Icon(Icons.discount),
                  label: const Text("Apply Code"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                if (message.isNotEmpty)
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: message.contains("✅")
                          ? Colors.green
                          : message.contains("❗")
                              ? Colors.orange
                              : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
