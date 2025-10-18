// // // order_confirmation_page.dart
// // import 'package:flutter/material.dart';
// // import 'package:dio/dio.dart';
// // import '../../authpage/pages/auth_services.dart';

// // class OrderConfirmationPage extends StatefulWidget {
// //   const OrderConfirmationPage({super.key});

// //   @override
// //   State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
// // }

// // class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
// //   final TextEditingController orderIdController = TextEditingController();
// //   final dio = Dio(BaseOptions(baseUrl: "https://frontman-backend-2.onrender.com/"));

// //   bool loading = false;
// //   String? message;
// //   Map<String, dynamic>? confirmationData;

// //   Future<String?> _getToken() async {
// //     final authService = AuthService();
// //     return await authService.getToken();
// //   }

// //   Future<void> getOrderConfirmation() async {
// //     setState(() {
// //       loading = true;
// //       message = null;
// //       confirmationData = null;
// //     });
// //     try {
// //       final token = await _getToken();
// //       if (token == null) {
// //         setState(() => message = "⚠️ Please login again.");
// //         return;
// //       }

// //       final response = await dio.get(
// //         "/distributor/order/${orderIdController.text}/confirmation",
// //         options: Options(headers: {"Authorization": "Bearer $token"}),
// //       );

// //       setState(() {
// //         confirmationData = response.data;
// //       });
// //     } catch (e) {
// //       setState(() => message = "❌ Error: $e");
// //     } finally {
// //       setState(() => loading = false);
// //     }
// //   }

// //   Widget _buildConfirmationDetails() {
// //     if (confirmationData == null) return const SizedBox();

// //     final items = (confirmationData!['items'] as List<dynamic>? ?? []);
// //     final pricing = confirmationData!['pricing'] ?? {};
// //     final promo = confirmationData!['promoCode'];

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text("🧾 Order ID: ${confirmationData!['orderId']}"),
// //         Text("📅 Date: ${confirmationData!['orderDate']}"),
// //         Text("📦 Status: ${confirmationData!['status']}"),
// //         const Divider(),

// //         Text("🛒 Items:", style: const TextStyle(fontWeight: FontWeight.bold)),
// //         ...items.map((item) => ListTile(
// //               title: Text(item['productName']),
// //               subtitle: Text("Qty: ${item['quantity']}  |  Warranty: ${item['warrantyPeriod']} months"),
// //               trailing: Text("\$${item['total']}"),
// //             )),

// //         const Divider(),
// //         Text("💰 Subtotal: \$${pricing['subtotal']}"),
// //         Text("🎟️ Discount: -\$${pricing['discountAmount']}"),
// //         Text("✅ Total: \$${pricing['total']}"),
// //         if (promo != null) Text("Promo Applied: ${promo['code']}"),

// //         const Divider(),
// //         Text("🚚 Estimated Delivery: ${confirmationData!['estimatedDelivery']}"),
// //       ],
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Order Confirmation")),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             TextField(
// //               controller: orderIdController,
// //               decoration: const InputDecoration(labelText: "Order ID"),
// //             ),
// //             const SizedBox(height: 10),
// //             ElevatedButton(
// //               onPressed: loading ? null : getOrderConfirmation,
// //               child: const Text("📄 Get Confirmation"),
// //             ),
// //             const SizedBox(height: 20),

// //             if (loading) const CircularProgressIndicator(),
// //             if (message != null) Text(message!, style: const TextStyle(color: Colors.red)),
// //             if (confirmationData != null) _buildConfirmationDetails(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:role_based_app/distributor/screens/distributorsUI.dart';
// import '../../authpage/pages/auth_services.dart';
// import '../../constants/colors.dart';

// class OrderConfirmationPage extends StatefulWidget {
//   const OrderConfirmationPage({super.key});

//   @override
//   State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
// }

// class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
//   final TextEditingController orderIdController = TextEditingController();
//   final dio =
//       Dio(BaseOptions(baseUrl: "https://frontman-backend-2.onrender.com/"));

//   bool loading = false;
//   String? message;
//   Map<String, dynamic>? confirmationData;

//   Future<String?> _getToken() async {
//     final authService = AuthService();
//     return await authService.getToken();
//   }

//   Future<void> getOrderConfirmation() async {
//     setState(() {
//       loading = true;
//       message = null;
//       confirmationData = null;
//     });
//     try {
//       final token = await _getToken();
//       if (token == null) {
//         setState(() => message = "⚠️ Please login again.");
//         return;
//       }

//       final response = await dio.get(
//         "/distributor/order/${orderIdController.text}/confirmation",
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );

//       setState(() {
//         confirmationData = response.data;
//         message = "✅ Order confirmation fetched successfully";
//       });
//     } catch (e) {
//       setState(() => message = "❌ Error: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   Widget _buildConfirmationDetails() {
//     if (confirmationData == null) return const SizedBox();

//     final items = (confirmationData!['items'] as List<dynamic>? ?? []);
//     final pricing = confirmationData!['pricing'] ?? {};
//     final promo = confirmationData!['promoCode'];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Card(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           elevation: 2,
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("🧾 Order ID: ${confirmationData!['orderId']}",
//                     style: const TextStyle(fontWeight: FontWeight.bold)),
//                 Text("📅 Date: ${confirmationData!['orderDate']}"),
//                 Text("📦 Status: ${confirmationData!['status']}"),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),

//         // Items
//         Text("🛒 Items:",
//             style: const TextStyle(
//                 fontWeight: FontWeight.bold, fontSize: 16)),
//         const SizedBox(height: 8),
//         ...items.map((item) => Card(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               child: ListTile(
//                 leading: const Icon(Icons.shopping_bag_outlined,
//                     color: AppColors.primary),
//                 title: Text(item['productName']),
//                 subtitle: Text(
//                     "Qty: ${item['quantity']}  |  Warranty: ${item['warrantyPeriod']} months"),
//                 trailing: Text("\$${item['total']}"),
//               ),
//             )),

//         const SizedBox(height: 16),

//         // Pricing
//         Card(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           elevation: 2,
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("💰 Subtotal: \$${pricing['subtotal']}"),
//                 Text("🎟️ Discount: -\$${pricing['discountAmount']}"),
//                 Text("✅ Total: \$${pricing['total']}",
//                     style: const TextStyle(fontWeight: FontWeight.bold)),
//                 if (promo != null) Text("Promo Applied: ${promo['code']}"),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),

//         // Delivery
//         Card(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           elevation: 2,
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: Text(
//                 "🚚 Estimated Delivery: ${confirmationData!['estimatedDelivery']}"),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: const Text("Order Confirmation",
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.home, size: 26),
//             tooltip: "Back to Dashboard",
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const DistributorHomePage()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // Order ID input
//             TextField(
//               controller: orderIdController,
//               decoration: InputDecoration(
//                 labelText: "Enter Order ID",
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 prefixIcon: const Icon(Icons.receipt_long),
//               ),
//             ),
//             const SizedBox(height: 12),

//             // Fetch button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: loading ? null : getOrderConfirmation,
//                 icon: const Icon(Icons.search),
//                 label: loading
//                     ? const Text("Fetching...")
//                     : const Text("Get Confirmation"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Message banner
//             if (message != null)
//               Card(
//                 color: message!.startsWith("✅")
//                     ? Colors.green[50]
//                     : Colors.red[50],
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 margin: const EdgeInsets.only(bottom: 16),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Row(
//                     children: [
//                       Icon(
//                         message!.startsWith("✅")
//                             ? Icons.check_circle
//                             : Icons.error,
//                         color: message!.startsWith("✅")
//                             ? Colors.green
//                             : Colors.red,
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           message!,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: message!.startsWith("✅")
//                                 ? Colors.green
//                                 : Colors.red,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//             // Confirmation details
//             if (confirmationData != null) _buildConfirmationDetails(),
//           ],
//         ),
//       ),
//     );
//   }
// }
// order_confirmation_page.dart
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import '../../authpage/pages/auth_services.dart';

// class OrderConfirmationPage extends StatefulWidget {
//   const OrderConfirmationPage({super.key});

//   @override
//   State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
// }

// class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
//   final TextEditingController orderIdController = TextEditingController();
//   final dio = Dio(BaseOptions(baseUrl: "https://frontman-backend-2.onrender.com/"));

//   bool loading = false;
//   String? message;
//   Map<String, dynamic>? confirmationData;

//   Future<String?> _getToken() async {
//     final authService = AuthService();
//     return await authService.getToken();
//   }

//   Future<void> getOrderConfirmation() async {
//     setState(() {
//       loading = true;
//       message = null;
//       confirmationData = null;
//     });
//     try {
//       final token = await _getToken();
//       if (token == null) {
//         setState(() => message = "⚠️ Please login again.");
//         return;
//       }

//       final response = await dio.get(
//         "/distributor/order/${orderIdController.text}/confirmation",
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );

//       setState(() {
//         confirmationData = response.data;
//       });
//     } catch (e) {
//       setState(() => message = "❌ Error: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   Widget _buildConfirmationDetails() {
//     if (confirmationData == null) return const SizedBox();

//     final items = (confirmationData!['items'] as List<dynamic>? ?? []);
//     final pricing = confirmationData!['pricing'] ?? {};
//     final promo = confirmationData!['promoCode'];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("🧾 Order ID: ${confirmationData!['orderId']}"),
//         Text("📅 Date: ${confirmationData!['orderDate']}"),
//         Text("📦 Status: ${confirmationData!['status']}"),
//         const Divider(),

//         Text("🛒 Items:", style: const TextStyle(fontWeight: FontWeight.bold)),
//         ...items.map((item) => ListTile(
//               title: Text(item['productName']),
//               subtitle: Text("Qty: ${item['quantity']}  |  Warranty: ${item['warrantyPeriod']} months"),
//               trailing: Text("\$${item['total']}"),
//             )),

//         const Divider(),
//         Text("💰 Subtotal: \$${pricing['subtotal']}"),
//         Text("🎟️ Discount: -\$${pricing['discountAmount']}"),
//         Text("✅ Total: \$${pricing['total']}"),
//         if (promo != null) Text("Promo Applied: ${promo['code']}"),

//         const Divider(),
//         Text("🚚 Estimated Delivery: ${confirmationData!['estimatedDelivery']}"),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Order Confirmation")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: orderIdController,
//               decoration: const InputDecoration(labelText: "Order ID"),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: loading ? null : getOrderConfirmation,
//               child: const Text("📄 Get Confirmation"),
//             ),
//             const SizedBox(height: 20),

//             if (loading) const CircularProgressIndicator(),
//             if (message != null) Text(message!, style: const TextStyle(color: Colors.red)),
//             if (confirmationData != null) _buildConfirmationDetails(),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../authpage/pages/auth_services.dart';

class OrderConfirmationPage extends StatefulWidget {
  const OrderConfirmationPage({super.key});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  final TextEditingController orderIdController = TextEditingController();
  final dio = Dio(BaseOptions(baseUrl: "https://frontman-backend-2.onrender.com/"));

  bool loading = false;
  String? message;
  Map<String, dynamic>? confirmationData;

  final currencyFormatter = NumberFormat.currency(locale: "en_IN", symbol: "₹"); // INR formatting
  final dateFormatter = DateFormat("d MMM yyyy"); // Example: 15 Sep 2025

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  Future<void> getOrderConfirmation() async {
    setState(() {
      loading = true;
      message = null;
      confirmationData = null;
    });
    try {
      final token = await _getToken();
      if (token == null) {
        setState(() => message = "⚠️ Please login again.");
        return;
      }

      final response = await dio.get(
        "/distributor/order/${orderIdController.text}/confirmation",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        confirmationData = response.data;
      });
    } catch (e) {
      setState(() => message = "❌ Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Widget _buildConfirmationDetails() {
    if (confirmationData == null) return const SizedBox();

    final items = (confirmationData!['items'] as List<dynamic>? ?? []);
    final pricing = confirmationData!['pricing'] ?? {};
    final promo = confirmationData!['promoCode'];

    // Format date
    String formattedDate = confirmationData!['orderDate'];
    try {
      final date = DateTime.parse(confirmationData!['orderDate']);
      formattedDate = dateFormatter.format(date);
    } catch (_) {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("✅ Your order has been confirmed!",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(
                  "Order #${confirmationData!['orderId']} was placed on $formattedDate "
                  "and is currently **${confirmationData!['status']}**.",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text("Estimated delivery: ${confirmationData!['estimatedDelivery']} 🚚"),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("🛍️ Items in your order:",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        "- ${item['productName']} (x${item['quantity']}) "
                        "with ${item['warrantyPeriod']} months warranty "
                        "for ${currencyFormatter.format(item['total'])}",
                        style: const TextStyle(fontSize: 15),
                      ),
                    )),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Card(
          color: Colors.blueGrey[50],
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("💳 Payment Summary",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Subtotal: ${currencyFormatter.format(pricing['subtotal'])}"),
                Text("Discount applied: -${currencyFormatter.format(pricing['discountAmount'])}"),
                if (promo != null) Text("Promo code used: ${promo['code']} 🎟️"),
                const Divider(),
                Text(
                  "Total amount paid: ${currencyFormatter.format(pricing['total'])}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Confirmation")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: orderIdController,
              decoration: InputDecoration(
                labelText: "Enter your Order ID",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.receipt_long),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: loading ? null : getOrderConfirmation,
              icon: const Icon(Icons.receipt),
              label: const Text("📄 Get Confirmation"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            if (loading) const CircularProgressIndicator(),
            if (message != null) Text(message!, style: const TextStyle(color: Colors.red, fontSize: 16)),
            if (confirmationData != null) _buildConfirmationDetails(),
          ],
        ),
      ),
    );
  }
}

