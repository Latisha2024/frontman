import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:role_based_app/distributor/screens/distributorsUI.dart';
import '../../authpage/pages/auth_services.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController productIdController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController itemIdController = TextEditingController();
  final dio = Dio(BaseOptions(baseUrl: "https://frontman-1.onrender.com"));

  bool loading = false;
  String? message;

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  // Format cart summary into readable sentences (only used for View Cart, Remove, Clear)
  String _formatCartSummary(dynamic cart, dynamic total) {
    if (cart == null || cart['items'] == null || cart['items'].isEmpty) {
      return "🛒 Your cart is currently empty.";
    }

    final items = cart['items'] as List;
    final cartSummary = items.map((item) {
      final product = item['product'];
      return "${product['name']} (x${item['quantity']})";
    }).join(", ");

    return "🛒 Your cart contains: $cartSummary.\n💰 Total: ₹$total";
  }

  Future<void> addToCart() async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final token = await _getToken();
      if (token == null) {
        setState(() => message = "⚠️ Please login again.");
        return;
      }

      final response = await dio.post(
        "/distributor/cart",
        data: {
          "productId": productIdController.text,
          "quantity": int.tryParse(quantityController.text) ?? 0,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      final updatedCart = response.data['cart'];
      final lastItem =
          (updatedCart?['items'] != null && updatedCart['items'].isNotEmpty)
              ? updatedCart['items'].last
              : null;

      setState(() {
        if (lastItem != null) {
          message =
              "✅ ${lastItem['product']['name']} (x${lastItem['quantity']}) was added to your cart.";
        } else {
          message = "✅ Item added to your cart.";
        }
      });
    } catch (e) {
      setState(() => message = "❌ Something went wrong while adding to cart.");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> getCart() async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final token = await _getToken();
      if (token == null) {
        setState(() => message = "⚠️ Please login again.");
        return;
      }

      final response = await dio.get(
        "/distributor/cart",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      final cart = response.data['cart'];
      final total = response.data['total'] ?? 0;

      setState(() {
        message = _formatCartSummary(cart, total);
      });
    } catch (e) {
      setState(() => message = "❌ Unable to fetch cart details.");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> removeItem() async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final token = await _getToken();
      if (token == null) {
        setState(() => message = "⚠️ Please login again.");
        return;
      }

      await dio.delete(
        "/distributor/cart/items/${itemIdController.text}",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      // fetch updated cart after removal
      final response = await dio.get(
        "/distributor/cart",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      final cart = response.data['cart'];
      final total = response.data['total'] ?? 0;

      setState(() {
        message =
            "🗑️ The item has been removed from your cart.\n\n${_formatCartSummary(cart, total)}";
      });
    } catch (e) {
      setState(() => message = "❌ Could not remove the item.");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> clearCart() async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final token = await _getToken();
      if (token == null) {
        setState(() => message = "⚠️ Please login again.");
        return;
      }

      await dio.delete(
        "/distributor/cart",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        message = "🧹 Your cart has been cleared successfully.\n\n🛒 Your cart is now empty.";
      });
    } catch (e) {
      setState(() => message = "❌ Could not clear the cart.");
    } finally {
      setState(() => loading = false);
    }
  }

  Widget _buildActionCard({required String title, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Distributor Cart",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.shopping_cart, size: 26),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, size: 26),
            tooltip: "Back to Dashboard",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DistributorHomePage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildActionCard(
              title: "Add Product to Cart",
              children: [
                TextField(
                  controller: productIdController,
                  decoration: const InputDecoration(
                    labelText: "Product ID",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Quantity",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: loading ? null : addToCart,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text("Add to Cart"),
                  ),
                ),
              ],
            ),

            _buildActionCard(
              title: "View Cart",
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: loading ? null : getCart,
                    icon: const Icon(Icons.shopping_basket),
                    label: const Text("Get Cart"),
                  ),
                ),
              ],
            ),

            _buildActionCard(
              title: "Remove Item from Cart",
              children: [
                TextField(
                  controller: itemIdController,
                  decoration: const InputDecoration(
                    labelText: "Item ID",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: loading ? null : removeItem,
                    icon: const Icon(Icons.delete_forever),
                    label: const Text("Remove Item"),
                  ),
                ),
              ],
            ),

            _buildActionCard(
              title: "Clear Entire Cart",
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: loading ? null : clearCart,
                    icon: const Icon(Icons.cleaning_services),
                    label: const Text("Clear Cart"),
                  ),
                ),
              ],
            ),

            if (loading) const SizedBox(height: 16),
            if (loading) const CircularProgressIndicator(),

            if (message != null) ...[
              const SizedBox(height: 16),
              Card(
                color: message!.startsWith("✅") ||
                        message!.startsWith("🛒") ||
                        message!.startsWith("🗑️") ||
                        message!.startsWith("🧹")
                    ? Colors.green[50]
                    : Colors.red[50],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    message!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: message!.startsWith("✅") ||
                              message!.startsWith("🛒") ||
                              message!.startsWith("🗑️") ||
                              message!.startsWith("🧹")
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
