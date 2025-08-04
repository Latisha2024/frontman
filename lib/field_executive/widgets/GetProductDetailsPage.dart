import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class GetProductDetailsPage extends StatelessWidget {
  const GetProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productIdController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Get Product Details"),
        backgroundColor: AppColors.primary,
        elevation: 2,
      ),
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Product Lookup",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: productIdController,
                  decoration: InputDecoration(
                    labelText: "Enter Product ID",
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: AppColors.inputFill,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Call API or fetch mock data
                    },
                    icon: const Icon(Icons.search),
                    label: const Text("Fetch Product Info"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
