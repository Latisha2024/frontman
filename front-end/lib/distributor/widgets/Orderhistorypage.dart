// // order_history_page.dart
// import 'package:flutter/material.dart';
// import 'package:role_based_app/constants/colors.dart';

// class OrderHistoryPage extends StatefulWidget {
//   const OrderHistoryPage({super.key});

//   @override
//   State<OrderHistoryPage> createState() => _OrderHistoryPageState();
// }

// class _OrderHistoryPageState extends State<OrderHistoryPage> {
//   final distributorIdController = TextEditingController();
//   List<String> orderHistory = [];
//   bool isError = false;

//   void fetchOrderHistory() {
//     final distributorId = distributorIdController.text.trim();
//     if (distributorId.isEmpty) {
//       setState(() {
//         orderHistory = ['⚠️ Please enter a valid Distributor ID'];
//         isError = true;
//       });
//       return;
//     }

//     // Simulated order data
//     setState(() {
//       orderHistory = [
//         'Order ID: 001 - ✅ Delivered',
//         'Order ID: 002 - 🚚 In Transit',
//         'Order ID: 003 - ❌ Cancelled',
//       ];
//       isError = false;
//     });
//   }

//   @override
//   void dispose() {
//     distributorIdController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: const Text("Order History"),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               controller: distributorIdController,
//               decoration: const InputDecoration(
//                 labelText: "Distributor ID",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: fetchOrderHistory,
//                 icon: const Icon(Icons.history),
//                 label: const Text("Fetch History"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             if (orderHistory.isNotEmpty)
//               Expanded(
//                 child: ListView.separated(
//                   itemCount: orderHistory.length,
//                   separatorBuilder: (_, __) => const Divider(height: 1),
//                   itemBuilder: (context, index) => ListTile(
//                     leading: const Icon(Icons.assignment),
//                     title: Text(
//                       orderHistory[index],
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: isError ? Colors.red[800] : Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// order_history_page.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';
import 'package:role_based_app/constants/colors.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final dio = Dio(BaseOptions(baseUrl: "https://frontman-backend-2.onrender.com/"));

  bool loading = false;
  String? message;
  List<String> orderHistory = [];

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
          orderHistory = data
              .map((item) =>
                  "📦 Order ID: ${item['order_id']} - Status: ${item['status']}")
              .toList()
              .cast<String>();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: loading ? null : fetchOrderHistory,
              icon: const Icon(Icons.history),
              label: loading
                  ? const Text("Fetching...")
                  : const Text("Fetch Order History"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 20),
            if (message != null) Text(message!),
            const SizedBox(height: 10),
            Expanded(
              child: orderHistory.isEmpty
                  ? const Center(
                      child: Text(
                        "No data to display",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                  : ListView.separated(
                      itemCount: orderHistory.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) => ListTile(
                        leading: const Icon(Icons.assignment_outlined),
                        title: Text(orderHistory[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

