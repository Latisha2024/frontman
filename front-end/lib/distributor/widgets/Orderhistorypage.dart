import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:role_based_app/distributor/screens/distributorsUI.dart';
import '../../authpage/pages/auth_services.dart';
import '../../constants/colors.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));

  bool loading = false;
  String? message;
  List<Map<String, dynamic>> orderHistory = [];

  @override
  void initState() {
    super.initState();
    fetchOrderHistory(); // Auto-fetch orders on page load
  }

  Future<void> fetchOrderHistory() async {
    setState(() {
      loading = true;
      message = null;
      orderHistory = [];
    });

    try {
      final authService = AuthService();
      final token = await authService.getToken();

      if (token == null) {
        setState(() => message = "⚠️ No token found. Please login again.");
        return;
      }

      final response = await dio.get(
        "/distributor/order",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      final data = response.data as List;

      if (data.isEmpty) {
        setState(() {
          message = "🚫 No orders found.";
        });
      } else {
        setState(() {
          orderHistory = List<Map<String, dynamic>>.from(data);
          message = "✅ Order history fetched successfully";
        });
      }
    } catch (e) {
      setState(() {
        message = "❌ Error fetching order history: $e";
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Widget _buildOrderList() {
    if (loading) return const Center(child: CircularProgressIndicator());

    if (orderHistory.isEmpty) {
      return Center(
        child: Text(
          message ?? "📭 No orders to display",
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return ListView.separated(
      itemCount: orderHistory.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = orderHistory[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: const Icon(Icons.assignment_outlined, color: AppColors.primary),
            ),
            title: Text("📦 Order ID: ${order['order_id']}"),
            subtitle: Text("Status: ${order['status']}"),
            trailing: Text(
              order['order_date'] ?? "",
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Order History", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Message banner
            if (message != null)
              Card(
                color: message!.startsWith("✅") ? Colors.green[50] : Colors.red[50],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        message!.startsWith("✅") ? Icons.check_circle : Icons.error,
                        color: message!.startsWith("✅") ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          message!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: message!.startsWith("✅") ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Orders list
            Expanded(child: _buildOrderList()),
          ],
        ),
      ),
    );
  }
}
