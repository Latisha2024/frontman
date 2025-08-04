import 'package:flutter/material.dart';
import '../../constants/colors.dart'; // Make sure AppColors is defined

class CheckStockPage extends StatelessWidget {
  const CheckStockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final skuController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Stock"),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        color: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Product Stock Checker",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: skuController,
              decoration: InputDecoration(
                labelText: "Enter SKU or Product ID",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Call your stock check API here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.inventory),
                label: const Text("Check Availability"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
