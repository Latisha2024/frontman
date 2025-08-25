import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class AddProductToOrderPage extends StatelessWidget {
  const AddProductToOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderIdController = TextEditingController();
    final productIdController = TextEditingController();
    final quantityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product to Order"),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent Added Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildRecentProductCard('ORD1234', 'PRD9001', 'Quantity: 2', '2:28'),
              _buildRecentProductCard('ORD5678', 'PRD8123', 'Quantity: 1', '2:25'),
              _buildRecentProductCard('ORD1010', 'PRD8888', 'Quantity: 5', '2:20'),
              const SizedBox(height: 24),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Fill Product Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildInputField("Order ID", orderIdController, "e.g. ORD1023"),
                      _buildInputField("Product ID", productIdController, "e.g. PRD4507"),
                      _buildInputField("Quantity", quantityController, "e.g. 3"),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final orderId = orderIdController.text.trim();
                            final productId = productIdController.text.trim();
                            final quantity = quantityController.text.trim();

                            if (orderId.isNotEmpty &&
                                productId.isNotEmpty &&
                                quantity.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Product added to order successfully')),
                              );
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill all fields')),
                              );
                            }
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text("Add to Order"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildRecentProductCard(String orderId, String productId, String qty, String time) {
    return Card(
      color: Colors.orange.shade50,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.inventory_2, color: Colors.orange),
        title: Text('Order: $orderId'),
        subtitle: Text('Product: $productId\n$qty'),
        trailing: Text('Added: $time', style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ),
    );
  }
}
