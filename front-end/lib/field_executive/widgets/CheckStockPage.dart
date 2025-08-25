import 'package:flutter/material.dart';
import '../../constants/colors.dart'; // Make sure AppColors is defined

class CheckStockPage extends StatefulWidget {
  const CheckStockPage({super.key});

  @override
  State<CheckStockPage> createState() => _CheckStockPageState();
}

class _CheckStockPageState extends State<CheckStockPage> {
  final TextEditingController skuController = TextEditingController();

  // Placeholder for stock details
  String? productName;
  int? quantity;
  String? location;

  void checkStock() {
    final sku = skuController.text.trim();

    if (sku.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a SKU/Product ID")),
      );
      return;
    }

    // Simulate fetching stock info (demo data)
    setState(() {
      productName = "Demo Product for SKU: $sku";
      quantity = 47;
      location = "Warehouse A - Rack 3B";
    });
  }

  @override
  void dispose() {
    skuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              decoration: const InputDecoration(
                labelText: "Enter SKU or Product ID",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: checkStock,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.inventory),
                label: const Text("Check Availability"),
              ),
            ),
            const SizedBox(height: 30),

            // Stock info display block
            if (productName != null && quantity != null && location != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Product Name: $productName", style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text("Available Quantity: $quantity", style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text("Location: $location", style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
