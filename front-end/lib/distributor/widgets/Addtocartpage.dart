// cart_page.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
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
  final dio = Dio(BaseOptions(baseUrl: "https://frontman-backend-2.onrender.com/"));

  bool loading = false;
  String? message;

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
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

      setState(() {
        message = "✅ Added to cart: ${response.data}";
      });
    } catch (e) {
      setState(() => message = "❌ Error: $e");
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

      setState(() {
        message = "🛒 Cart: ${response.data}";
      });
    } catch (e) {
      setState(() => message = "❌ Error: $e");
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

      final response = await dio.delete(
        "/distributor/cart/items/${itemIdController.text}",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        message = "🗑️ Removed item: ${response.data}";
      });
    } catch (e) {
      setState(() => message = "❌ Error: $e");
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

      final response = await dio.delete(
        "/distributor/cart",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        message = "🧹 Cart cleared: ${response.data}";
      });
    } catch (e) {
      setState(() => message = "❌ Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Distributor Cart")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: productIdController,
              decoration: const InputDecoration(labelText: "Product ID"),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: "Quantity"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: loading ? null : addToCart,
              child: const Text("➕ Add to Cart"),
            ),
            const Divider(),

            ElevatedButton(
              onPressed: loading ? null : getCart,
              child: const Text("🛒 Get Cart"),
            ),
            const Divider(),

            TextField(
              controller: itemIdController,
              decoration: const InputDecoration(labelText: "Item ID (for removal)"),
            ),
            ElevatedButton(
              onPressed: loading ? null : removeItem,
              child: const Text("❌ Remove Item"),
            ),
            const Divider(),

            ElevatedButton(
              onPressed: loading ? null : clearCart,
              child: const Text("🧹 Clear Cart"),
            ),
            const SizedBox(height: 20),

            if (loading) const CircularProgressIndicator(),
            if (message != null) Text(message!),
          ],
        ),
      ),
    );
  }
}
