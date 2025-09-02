// // create_order_page.dart
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import '../../authpage/pages/auth_services.dart';
// import 'package:role_based_app/constants/colors.dart';

// class CreateOrderPage extends StatefulWidget {
//   const CreateOrderPage({super.key});

//   @override
//   State<CreateOrderPage> createState() => _CreateOrderPageState();
// }

// class _CreateOrderPageState extends State<CreateOrderPage> {
//   final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5000"));

//   bool loading = false;
//   String? message;

//   // Order items list
//   final List<Map<String, dynamic>> items = [
//     {"productId": "", "quantity": 1}
//   ];

//   Future<void> createOrder() async {
//     setState(() {
//       loading = true;
//       message = null;
//     });

//     try {
//       final authService = AuthService();
//       final token = await authService.getToken();

//       if (token == null) {
//         setState(() => message = "⚠️ No token found. Please login again.");
//         return;
//       }

//       final response = await dio.post(
//         "/distributor/order",
//         data: {"items": items},
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );

//       setState(() {
//         message = "✅ Order created successfully!";
//       });
//     } catch (e) {
//       setState(() {
//         message = "❌ Error creating order: $e";
//       });
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   Widget _buildItemRow(int index) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 3,
//               child: TextField(
//                 decoration: const InputDecoration(
//                   labelText: "Product ID",
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: (value) => items[index]["productId"] = value,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               flex: 2,
//               child: TextField(
//                 decoration: const InputDecoration(
//                   labelText: "Quantity",
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) => items[index]["quantity"] =
//                     int.tryParse(value) ?? 1,
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: () {
//                 setState(() {
//                   items.removeAt(index);
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Create Order"),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: items.length,
//                 itemBuilder: (context, index) => _buildItemRow(index),
//               ),
//             ),
//             Row(
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     setState(() {
//                       items.add({"productId": "", "quantity": 1});
//                     });
//                   },
//                   icon: const Icon(Icons.add),
//                   label: const Text("Add Item"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
//                   ),
//                 ),
//                 const Spacer(),
//                 ElevatedButton.icon(
//                   onPressed: loading ? null : createOrder,
//                   icon: const Icon(Icons.shopping_cart_checkout),
//                   label: loading
//                       ? const Text("Placing Order...")
//                       : const Text("Place Order"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             if (message != null)
//               Text(
//                 message!,
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
