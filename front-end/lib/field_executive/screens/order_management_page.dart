import 'package:flutter/material.dart';
import 'package:role_based_app/authpage/config/app_colors.dart';
import '../../constants/colors.dart';

// Import your navigation target pages
import '../widgets/PlaceOrderPage.dart';
import '../widgets/GetProductDetailsPage.dart';
import '../widgets/CheckStockPage.dart';
import '../widgets/AddProductToOrderPage.dart';
import '../widgets/UpdateStockPage.dart';

class OrderManagementPage extends StatelessWidget {
  const OrderManagementPage({super.key});

  Widget buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 36, color: const Color(0xFFA5C8D0)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: AppBar(
        title: const Text("Order Management", style: TextStyle(color: Colors.white)),
        backgroundColor: AuthColors.textDark,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildActionCard(
                    icon: Icons.shopping_cart,
                    title: "Place Order",
                    description: "Submit a new order with product details.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PlaceOrderPage()),
                      );
                    },
                  ),
                  buildActionCard(
                    icon: Icons.search,
                    title: "Get Product Details",
                    description: "Retrieve product information by ID.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GetProductDetailsPage()),
                      );
                    },
                  ),
                  buildActionCard(
                    icon: Icons.inventory,
                    title: "Check Stock",
                    description: "Check the availability of a product.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CheckStockPage()),
                      );
                    },
                  ),
                  buildActionCard(
                    icon: Icons.add_shopping_cart,
                    title: "Add Product to Order",
                    description: "Add items to an existing order.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddProductToOrderPage()),
                      );
                    },
                  ),
                  buildActionCard(
                    icon: Icons.update,
                    title: "Update Stock",
                    description: "Modify stock quantity after transaction.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UpdateStockPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black12)),
              color: Color(0xFFEFF6F8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.menu, size: 30, color: Color(0xFFA5C8D0)),
                Icon(Icons.arrow_back, size: 30, color: Color(0xFFA5C8D0)),
                Icon(Icons.settings, size: 30, color: Color(0xFFA5C8D0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
