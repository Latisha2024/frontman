// // // // track_order_page.dart
// // // import 'package:flutter/material.dart';
// // // import 'package:dio/dio.dart';
// // // import '../../authpage/pages/auth_services.dart';
// // // import 'package:role_based_app/constants/colors.dart';

// // // class TrackOrderPage extends StatefulWidget {
// // //   const TrackOrderPage({super.key});

// // //   @override
// // //   State<TrackOrderPage> createState() => _TrackOrderPageState();
// // // }

// // // class _TrackOrderPageState extends State<TrackOrderPage> {
// // //   final dio = Dio(BaseOptions(baseUrl: "https://frontman-backend-2.onrender.com/"));

// // //   bool loading = false;
// // //   String? message;
// // //   Map<String, dynamic>? orderDetails;
// // //   final TextEditingController orderIdController = TextEditingController();

// // //   Future<void> fetchOrderDetails(String orderId) async {
// // //     setState(() {
// // //       loading = true;
// // //       message = null;
// // //       orderDetails = null;
// // //     });

// // //     try {
// // //       final authService = AuthService();
// // //       final token = await authService.getToken();

// // //       if (token == null) {
// // //         setState(() => message = "⚠️ No token found. Please login again.");
// // //         return;
// // //       }

// // //       final response = await dio.get(
// // //         "/distributor/order/$orderId",
// // //         options: Options(headers: {"Authorization": "Bearer $token"}),
// // //       );

// // //       setState(() {
// // //         orderDetails = response.data as Map<String, dynamic>;
// // //       });
// // //     } catch (e) {
// // //       setState(() {
// // //         message = "❌ Error fetching order details: $e";
// // //       });
// // //     } finally {
// // //       setState(() {
// // //         loading = false;
// // //       });
// // //     }
// // //   }

// // //   Widget _buildOrderDetails() {
// // //     if (orderDetails == null) return const SizedBox.shrink();

// // //     final items = orderDetails!['items'] as List<dynamic>;

// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         Text("🆔 Order ID: ${orderDetails!['id']}",
// // //             style: const TextStyle(fontWeight: FontWeight.bold)),
// // //         Text("📌 Status: ${orderDetails!['status']}"),
// // //         Text("📅 Date: ${orderDetails!['orderDate']}"),
// // //         Text("💰 Subtotal: ₹${orderDetails!['subtotal']}"),
// // //         Text("🎟️ Discount: ₹${orderDetails!['discountAmount']}"),
// // //         Text("✅ Total: ₹${orderDetails!['total']}"),
// // //         const SizedBox(height: 10),
// // //         const Text("📦 Items:", style: TextStyle(fontWeight: FontWeight.bold)),
// // //         ...items.map((item) => ListTile(
// // //               leading: const Icon(Icons.shopping_bag_outlined),
// // //               title: Text("${item['productName']} (x${item['quantity']})"),
// // //               subtitle: Text("Unit Price: ₹${item['unitPrice']}"),
// // //               trailing: Text("₹${item['total']}"),
// // //             )),
// // //       ],
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text("Track Order"),
// // //         backgroundColor: AppColors.primary,
// // //         foregroundColor: Colors.white,
// // //       ),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Column(
// // //           children: [
// // //             TextField(
// // //               controller: orderIdController,
// // //               decoration: const InputDecoration(
// // //                 labelText: "Enter Order ID",
// // //                 border: OutlineInputBorder(),
// // //               ),
// // //             ),
// // //             const SizedBox(height: 10),
// // //             ElevatedButton.icon(
// // //               onPressed: loading
// // //                   ? null
// // //                   : () {
// // //                       if (orderIdController.text.isNotEmpty) {
// // //                         fetchOrderDetails(orderIdController.text.trim());
// // //                       }
// // //                     },
// // //               icon: const Icon(Icons.search),
// // //               label: loading
// // //                   ? const Text("Tracking...")
// // //                   : const Text("Track Order"),
// // //               style: ElevatedButton.styleFrom(
// // //                 backgroundColor: AppColors.primary,
// // //                 padding: const EdgeInsets.symmetric(vertical: 14),
// // //                 minimumSize: const Size(double.infinity, 50),
// // //               ),
// // //             ),
// // //             const SizedBox(height: 20),
// // //             if (message != null) Text(message!),
// // //             Expanded(
// // //               child: orderDetails == null
// // //                   ? const Center(
// // //                       child: Text(
// // //                         "Enter an Order ID to track",
// // //                         style: TextStyle(fontSize: 16, color: Colors.black54),
// // //                       ),
// // //                     )
// // //                   : SingleChildScrollView(child: _buildOrderDetails()),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // // // track_order_page.dart
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import '../../authpage/pages/auth_services.dart';
// import 'package:role_based_app/constants/colors.dart';
// import 'package:role_based_app/distributor/screens/distributorsUI.dart';

// class TrackOrderPage extends StatefulWidget {
//   const TrackOrderPage({super.key});

//   @override
//   State<TrackOrderPage> createState() => _TrackOrderPageState();
// }

// class _TrackOrderPageState extends State<TrackOrderPage> {
//   final dio = Dio(BaseOptions(baseUrl: "https://frontman-backend-2.onrender.com/"));
//   final TextEditingController orderIdController = TextEditingController();

//   bool loading = false;
//   String? message;
//   Map<String, dynamic>? orderDetails;

//   Future<String?> _getToken() async {
//     final authService = AuthService();
//     return await authService.getToken();
//   }

//   Future<void> fetchOrderDetails(String orderId) async {
//     setState(() {
//       loading = true;
//       message = null;
//       orderDetails = null;
//     });

//     try {
//       final token = await _getToken();
//       if (token == null) {
//         setState(() => message = "⚠️ No token found. Please login again.");
//         return;
//       }

//       final response = await dio.get(
//         "/distributor/order/$orderId",
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );

//       setState(() => orderDetails = response.data as Map<String, dynamic>);
//     } catch (e) {
//       setState(() => message = "❌ Error fetching order details: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   Widget _buildOrderDetailsCard() {
//     if (orderDetails == null) return const SizedBox.shrink();
//     final items = orderDetails!['items'] as List<dynamic>;

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("🆔 Order ID: ${orderDetails!['id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 4),
//             Text("📌 Status: ${orderDetails!['status']}"),
//             Text("📅 Date: ${orderDetails!['orderDate']}"),
//             Text("💰 Subtotal: ₹${orderDetails!['subtotal']}"),
//             Text("🎟️ Discount: ₹${orderDetails!['discountAmount']}"),
//             Text("✅ Total: ₹${orderDetails!['total']}"),
//             const SizedBox(height: 12),
//             const Text("📦 Items:", style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 6),
//             ...items.map((item) => Card(
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   elevation: 1,
//                   margin: const EdgeInsets.symmetric(vertical: 4),
//                   child: ListTile(
//                     leading: const Icon(Icons.shopping_bag_outlined),
//                     title: Text("${item['productName']} (x${item['quantity']})"),
//                     subtitle: Text("Unit Price: ₹${item['unitPrice']}"),
//                     trailing: Text("₹${item['total']}"),
//                   ),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           "Track Order",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         leading: const Icon(Icons.track_changes, size: 26),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.home, size: 26),
//             tooltip: "Back to Dashboard",
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const DistributorHomePage()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               elevation: 3,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: orderIdController,
//                       decoration: const InputDecoration(
//                         labelText: "Enter Order ID",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton.icon(
//                       onPressed: loading
//                           ? null
//                           : () {
//                               if (orderIdController.text.isNotEmpty) {
//                                 fetchOrderDetails(orderIdController.text.trim());
//                               }
//                             },
//                       icon: loading
//                           ? const SizedBox(
//                               width: 18,
//                               height: 18,
//                               child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//                             )
//                           : const Icon(Icons.search),
//                       label: Text(loading ? "Tracking..." : "Track Order"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         minimumSize: const Size(double.infinity, 50),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             if (message != null)
//               Card(
//                 color: message!.startsWith("❌") ? Colors.red[50] : Colors.green[50],
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Text(
//                     message!,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: message!.startsWith("❌") ? Colors.red : Colors.green,
//                     ),
//                   ),
//                 ),
//               ),
//             if (orderDetails != null) _buildOrderDetailsCard(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // // import 'package:flutter/material.dart';
// // // import 'package:dio/dio.dart';
// // // import '../../authpage/pages/auth_services.dart';
// // // import 'package:role_based_app/constants/colors.dart';
// // // import 'package:role_based_app/distributor/screens/distributorsUI.dart';

// // // class TrackOrderPage extends StatefulWidget {
// // //   const TrackOrderPage({super.key});

// // //   @override
// // //   State<TrackOrderPage> createState() => _TrackOrderPageState();
// // // }

// // // class _TrackOrderPageState extends State<TrackOrderPage> {
// // //   final dio = Dio(BaseOptions(baseUrl: "https://frontman-backend-2.onrender.com/"));
// // //   final TextEditingController orderIdController = TextEditingController();

// // //   bool loading = false;
// // //   String? message;
// // //   Map<String, dynamic>? orderDetails;

// // //   Future<String?> _getToken() async {
// // //     final authService = AuthService();
// // //     return await authService.getToken();
// // //   }

// // //   Future<void> fetchOrderDetails(String orderId) async {
// // //     setState(() {
// // //       loading = true;
// // //       message = null;
// // //       orderDetails = null;
// // //     });

// // //     try {
// // //       final token = await _getToken();
// // //       if (token == null) {
// // //         setState(() => message = "⚠️ No token found. Please login again.");
// // //         return;
// // //       }

// // //       final response = await dio.get(
// // //         "/distributor/order/$orderId",
// // //         options: Options(headers: {"Authorization": "Bearer $token"}),
// // //       );

// // //       setState(() => orderDetails = response.data as Map<String, dynamic>);
// // //     } catch (e) {
// // //       setState(() => message = "❌ Error fetching order details: $e");
// // //     } finally {
// // //       setState(() => loading = false);
// // //     }
// // //   }

// // //   /// ✅ Response Formatter (customer friendly sentences)
// // //   String _formatOrderDetails(Map<String, dynamic> order) {
// // //     final buffer = StringBuffer();

// // //     buffer.writeln("✅ Your order with ID ${order['id']} is currently **${order['status']}**.");
// // //     buffer.writeln("🗓️ It was placed on ${order['orderDate']}.");
// // //     buffer.writeln("💰 The subtotal of your order is ₹${order['subtotal']}.");
// // //     if (order['discountAmount'] != null && order['discountAmount'] > 0) {
// // //       buffer.writeln("🎟️ A discount of ₹${order['discountAmount']} has been applied.");
// // //     }
// // //     buffer.writeln("👉 The final total is ₹${order['total']}.");
// // //     buffer.writeln("\n📦 Your order contains:");

// // //     final items = order['items'] as List<dynamic>;
// // //     for (var item in items) {
// // //       buffer.writeln(
// // //           "- ${item['productName']} × ${item['quantity']} (₹${item['unitPrice']} each, total ₹${item['total']})");
// // //     }

// // //     if (order['promoCode'] != null) {
// // //       buffer.writeln(
// // //           "\n🎁 Promo code '${order['promoCode']['code']}' was applied: ${order['promoCode']['description']}.");
// // //     }

// // //     return buffer.toString();
// // //   }

// // //   Widget _buildOrderDetailsCard() {
// // //     if (orderDetails == null) return const SizedBox.shrink();

// // //     return Card(
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //       elevation: 3,
// // //       margin: const EdgeInsets.symmetric(vertical: 8),
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Text(
// // //           _formatOrderDetails(orderDetails!),
// // //           style: const TextStyle(fontSize: 16, height: 1.4),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         centerTitle: true,
// // //         title: const Text(
// // //           "Track Order",
// // //           style: TextStyle(fontWeight: FontWeight.bold),
// // //         ),
// // //         leading: const Icon(Icons.track_changes, size: 26),
// // //         actions: [
// // //           IconButton(
// // //             icon: const Icon(Icons.home, size: 26),
// // //             tooltip: "Back to Dashboard",
// // //             onPressed: () {
// // //               Navigator.pushReplacement(
// // //                 context,
// // //                 MaterialPageRoute(builder: (context) => const DistributorHomePage()),
// // //               );
// // //             },
// // //           ),
// // //         ],
// // //       ),
// // //       body: SingleChildScrollView(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Column(
// // //           children: [
// // //             Card(
// // //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //               elevation: 3,
// // //               child: Padding(
// // //                 padding: const EdgeInsets.all(16),
// // //                 child: Column(
// // //                   children: [
// // //                     TextField(
// // //                       controller: orderIdController,
// // //                       decoration: const InputDecoration(
// // //                         labelText: "Enter Order ID",
// // //                         border: OutlineInputBorder(),
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 16),
// // //                     ElevatedButton.icon(
// // //                       onPressed: loading
// // //                           ? null
// // //                           : () {
// // //                               if (orderIdController.text.isNotEmpty) {
// // //                                 fetchOrderDetails(orderIdController.text.trim());
// // //                               }
// // //                             },
// // //                       icon: loading
// // //                           ? const SizedBox(
// // //                               width: 18,
// // //                               height: 18,
// // //                               child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
// // //                             )
// // //                           : const Icon(Icons.search),
// // //                       label: Text(loading ? "Tracking..." : "Track Order"),
// // //                       style: ElevatedButton.styleFrom(
// // //                         backgroundColor: AppColors.primary,
// // //                         padding: const EdgeInsets.symmetric(vertical: 14),
// // //                         minimumSize: const Size(double.infinity, 50),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //             const SizedBox(height: 20),
// // //             if (message != null)
// // //               Card(
// // //                 color: message!.startsWith("❌") ? Colors.red[50] : Colors.green[50],
// // //                 child: Padding(
// // //                   padding: const EdgeInsets.all(12),
// // //                   child: Text(
// // //                     message!,
// // //                     style: TextStyle(
// // //                       fontWeight: FontWeight.bold,
// // //                       color: message!.startsWith("❌") ? Colors.red : Colors.green,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //             if (orderDetails != null) _buildOrderDetailsCard(),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import '../../authpage/pages/auth_services.dart';
// import 'package:role_based_app/constants/colors.dart';
// import 'package:role_based_app/distributor/screens/distributorsUI.dart';

// class TrackOrderPage extends StatefulWidget {
//   const TrackOrderPage({super.key});
//   @override
//   State<TrackOrderPage> createState() => _TrackOrderPageState();
// }

// class _TrackOrderPageState extends State<TrackOrderPage> {
//   final dio =
//       Dio(BaseOptions(baseUrl: "https://frontman-backend-2.onrender.com/"));
//   final TextEditingController orderIdController = TextEditingController();
//   bool loading = false;
//   String? message;
//   Map<String, dynamic>? orderDetails;
//   Future<String?> _getToken() async {
//     final authService = AuthService();
//     return await authService.getToken();
//   }

//   Future<void> fetchOrderDetails(String orderId) async {
//     setState(() {
//       loading = true;
//       message = null;
//       orderDetails = null;
//     });
//     try {
//       final token = await _getToken();
//       if (token == null) {
//         setState(() => message = "⚠️ No token found. Please login again.");
//         return;
//       }
//       final response = await dio.get(
//         "/distributor/order/$orderId",
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );
//       setState(() => orderDetails = response.data as Map<String, dynamic>);
//     } catch (e) {
//       setState(() => message = "❌ Error fetching order details: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   Widget _buildOrderDetailsCard() {
//     if (orderDetails == null) return const SizedBox.shrink();
//     final items = orderDetails!['items'] as List<dynamic>;
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("🆔 Order ID: ${orderDetails!['id']}",
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 4),
//             Text("📌 Status: ${orderDetails!['status']}"),
//             Text("📅 Date: ${orderDetails!['orderDate']}"),
//             Text("💰 Subtotal: ₹${orderDetails!['subtotal']}"),
//             Text("🎟️ Discount: ₹${orderDetails!['discountAmount']}"),
//             Text("✅ Total: ₹${orderDetails!['total']}"),
//             const SizedBox(height: 12),
//             const Text("📦 Items:",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 6),
//             ...items.map((item) => Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   elevation: 1,
//                   margin: const EdgeInsets.symmetric(vertical: 4),
//                   child: ListTile(
//                     leading: const Icon(Icons.shopping_bag_outlined),
//                     title:
//                         Text("${item['productName']} (x${item['quantity']})"),
//                     subtitle: Text("Unit Price: ₹${item['unitPrice']}"),
//                     trailing: Text("₹${item['total']}"),
//                   ),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           "Track Order",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         leading: const Icon(Icons.track_changes, size: 26),
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
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Card(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               elevation: 3,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: orderIdController,
//                       decoration: const InputDecoration(
//                         labelText: "Enter Order ID",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton.icon(
//                       onPressed: loading
//                           ? null
//                           : () {
//                               if (orderIdController.text.isNotEmpty) {
//                                 fetchOrderDetails(
//                                     orderIdController.text.trim());
//                               }
//                             },
//                       icon: loading
//                           ? const SizedBox(
//                               width: 18,
//                               height: 18,
//                               child: CircularProgressIndicator(
//                                   color: Colors.white, strokeWidth: 2),
//                             )
//                           : const Icon(Icons.search),
//                       label: Text(loading ? "Tracking..." : "Track Order"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         minimumSize: const Size(double.infinity, 50),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             if (message != null)
//               Card(
//                 color: message!.startsWith("❌")
//                     ? Colors.red[50]
//                     : Colors.green[50],
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Text(
//                     message!,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color:
//                           message!.startsWith("❌") ? Colors.red : Colors.green,
//                     ),
//                   ),
//                 ),
//               ),
//             if (orderDetails != null) _buildOrderDetailsCard(),
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
import 'package:role_based_app/constants/colors.dart';
import 'package:role_based_app/distributor/screens/distributorsUI.dart';

class TrackOrderPage extends StatefulWidget {
  const TrackOrderPage({super.key});

  @override
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  final dio = Dio(BaseOptions(baseUrl: "https://frontman-backend-2.onrender.com/"));
  final TextEditingController orderIdController = TextEditingController();

  bool loading = false;
  String? message;
  Map<String, dynamic>? orderDetails;

  final currencyFormatter = NumberFormat.currency(locale: "en_IN", symbol: "₹");
  final dateFormatter = DateFormat("d MMM yyyy");

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  Future<void> fetchOrderDetails(String orderId) async {
    setState(() {
      loading = true;
      message = null;
      orderDetails = null;
    });

    try {
      final token = await _getToken();
      if (token == null) {
        setState(() => message = "⚠️ No token found. Please login again.");
        return;
      }

      final response = await dio.get(
        "/distributor/order/$orderId",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() => orderDetails = response.data as Map<String, dynamic>);
    } catch (e) {
      setState(() => message = "❌ Error fetching order details: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "confirmed":
      case "delivered":
        return Colors.green;
      case "pending":
      case "processing":
        return Colors.orange;
      case "cancelled":
      case "failed":
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  Widget _buildOrderDetailsCard() {
    if (orderDetails == null) return const SizedBox.shrink();
    final items = orderDetails!['items'] as List<dynamic>? ?? [];

    // Format date
    String formattedDate = orderDetails!['orderDate'] ?? "";
    try {
      final date = DateTime.parse(orderDetails!['orderDate']);
      formattedDate = dateFormatter.format(date);
    } catch (_) {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Order Summary Card
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("📦 Order Summary",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Your order #${orderDetails!['id']} was placed on $formattedDate."),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text("Current Status: "),
                    Text(
                      orderDetails!['status'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(orderDetails!['status'])),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Items Card
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("🛍️ Items in your order",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...items.map((item) => Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.shopping_bag_outlined),
                        title: Text("${item['productName']} (x${item['quantity']})"),
                        subtitle: Text("Unit Price: ${currencyFormatter.format(item['unitPrice'])}"),
                        trailing: Text(currencyFormatter.format(item['total'])),
                      ),
                    )),
              ],
            ),
          ),
        ),

        // Payment Summary Card
        Card(
          color: Colors.blueGrey[50],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("💳 Payment Summary",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Subtotal: ${currencyFormatter.format(orderDetails!['subtotal'])}"),
                Text("Discount: -${currencyFormatter.format(orderDetails!['discountAmount'])}"),
                const Divider(),
                Text(
                  "Total Paid: ${currencyFormatter.format(orderDetails!['total'])}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Track Order", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.track_changes, size: 26),
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
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: orderIdController,
                      decoration: const InputDecoration(
                        labelText: "Enter Order ID",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: loading
                          ? null
                          : () {
                              if (orderIdController.text.isNotEmpty) {
                                fetchOrderDetails(orderIdController.text.trim());
                              }
                            },
                      icon: loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.search),
                      label: Text(loading ? "Tracking..." : "📄 Get Confirmation"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (message != null)
              Card(
                color: message!.startsWith("❌") ? Colors.red[50] : Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    message!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: message!.startsWith("❌") ? Colors.red : Colors.green,
                    ),
                  ),
                ),
              ),
            if (orderDetails != null) _buildOrderDetailsCard(),
          ],
        ),
      ),
    );
  }
}

