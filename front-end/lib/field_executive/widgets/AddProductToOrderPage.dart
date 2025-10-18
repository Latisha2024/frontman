// // // // // import 'package:flutter/material.dart';
// // // // // import '../../constants/colors.dart';

// // // // // class AddProductToOrderPage extends StatelessWidget {
// // // // //   const AddProductToOrderPage({super.key});

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     final orderIdController = TextEditingController();
// // // // //     final productIdController = TextEditingController();
// // // // //     final quantityController = TextEditingController();

// // // // //     return Scaffold(
// // // // //       appBar: AppBar(
// // // // //         title: const Text("Add Product to Order"),
// // // // //         backgroundColor: AppColors.primaryBlue,
// // // // //       ),
// // // // //       body: SingleChildScrollView(
// // // // //         child: Padding(
// // // // //           padding: const EdgeInsets.all(20.0),
// // // // //           child: Column(
// // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // //             children: [
// // // // //               const Text(
// // // // //                 'Recent Added Products',
// // // // //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // // // //               ),
// // // // //               const SizedBox(height: 12),
// // // // //               _buildRecentProductCard('ORD1234', 'PRD9001', 'Quantity: 2', '2:28'),
// // // // //               _buildRecentProductCard('ORD5678', 'PRD8123', 'Quantity: 1', '2:25'),
// // // // //               _buildRecentProductCard('ORD1010', 'PRD8888', 'Quantity: 5', '2:20'),
// // // // //               const SizedBox(height: 24),
// // // // //               Card(
// // // // //                 elevation: 6,
// // // // //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// // // // //                 child: Padding(
// // // // //                   padding: const EdgeInsets.all(24.0),
// // // // //                   child: Column(
// // // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                     children: [
// // // // //                       const Text(
// // // // //                         "Fill Product Details",
// // // // //                         style: TextStyle(
// // // // //                           fontSize: 20,
// // // // //                           fontWeight: FontWeight.bold,
// // // // //                           color: Colors.black87,
// // // // //                         ),
// // // // //                       ),
// // // // //                       const SizedBox(height: 24),
// // // // //                       _buildInputField("Order ID", orderIdController, "e.g. ORD1023"),
// // // // //                       _buildInputField("Product ID", productIdController, "e.g. PRD4507"),
// // // // //                       _buildInputField("Quantity", quantityController, "e.g. 3"),
// // // // //                       const SizedBox(height: 30),
// // // // //                       SizedBox(
// // // // //                         width: double.infinity,
// // // // //                         child: ElevatedButton.icon(
// // // // //                           onPressed: () {
// // // // //                             final orderId = orderIdController.text.trim();
// // // // //                             final productId = productIdController.text.trim();
// // // // //                             final quantity = quantityController.text.trim();

// // // // //                             if (orderId.isNotEmpty &&
// // // // //                                 productId.isNotEmpty &&
// // // // //                                 quantity.isNotEmpty) {
// // // // //                               ScaffoldMessenger.of(context).showSnackBar(
// // // // //                                 const SnackBar(content: Text('Product added to order successfully')),
// // // // //                               );
// // // // //                               Navigator.pop(context);
// // // // //                             } else {
// // // // //                               ScaffoldMessenger.of(context).showSnackBar(
// // // // //                                 const SnackBar(content: Text('Please fill all fields')),
// // // // //                               );
// // // // //                             }
// // // // //                           },
// // // // //                           icon: const Icon(Icons.add_shopping_cart),
// // // // //                           label: const Text("Add to Order"),
// // // // //                           style: ElevatedButton.styleFrom(
// // // // //                             backgroundColor: AppColors.primaryBlue,
// // // // //                             foregroundColor: Colors.white,
// // // // //                             padding: const EdgeInsets.symmetric(vertical: 14),
// // // // //                             shape: RoundedRectangleBorder(
// // // // //                               borderRadius: BorderRadius.circular(12),
// // // // //                             ),
// // // // //                             textStyle: const TextStyle(
// // // // //                               fontSize: 16,
// // // // //                               fontWeight: FontWeight.w600,
// // // // //                             ),
// // // // //                           ),
// // // // //                         ),
// // // // //                       ),
// // // // //                     ],
// // // // //                   ),
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildInputField(String label, TextEditingController controller, String hintText) {
// // // // //     return Padding(
// // // // //       padding: const EdgeInsets.only(bottom: 18),
// // // // //       child: TextField(
// // // // //         controller: controller,
// // // // //         decoration: InputDecoration(
// // // // //           labelText: label,
// // // // //           hintText: hintText,
// // // // //           labelStyle: const TextStyle(fontWeight: FontWeight.w500),
// // // // //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
// // // // //           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildRecentProductCard(String orderId, String productId, String qty, String time) {
// // // // //     return Card(
// // // // //       color: Colors.orange.shade50,
// // // // //       elevation: 2,
// // // // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // // // //       margin: const EdgeInsets.only(bottom: 12),
// // // // //       child: ListTile(
// // // // //         leading: const Icon(Icons.inventory_2, color: Colors.orange),
// // // // //         title: Text('Order: $orderId'),
// // // // //         subtitle: Text('Product: $productId\n$qty'),
// // // // //         trailing: Text('Added: $time', style: const TextStyle(fontSize: 12, color: Colors.grey)),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // // import 'package:flutter/material.dart';
// // // // import '../../authpage/pages/auth_services.dart';
// // // // import 'package:dio/dio.dart';

// // // // class AddProductToOrderPage extends StatefulWidget {
// // // //   const AddProductToOrderPage({super.key});

// // // //   @override
// // // //   State<AddProductToOrderPage> createState() => _AddProductToOrderPageState();
// // // // }

// // // // class _AddProductToOrderPageState extends State<AddProductToOrderPage> {
// // // //   final TextEditingController orderIdController = TextEditingController();
// // // //   final TextEditingController productIdController = TextEditingController();
// // // //   final TextEditingController quantityController = TextEditingController();

// // // //   final authService = AuthService();
// // // //   bool loading = false;
// // // //   String? message;

// // // //   Future<void> addProductToOrder() async {
// // // //     setState(() {
// // // //       loading = true;
// // // //       message = null;
// // // //     });

// // // //     try {
// // // //       final token = await authService.getToken();
// // // //       if (token == null) {
// // // //         setState(() => message = "⚠️ Please login again.");
// // // //         return;
// // // //       }

// // // //       final response = await authService.dio.post(
// // // //         "/sales-executive/orders/add-product",
// // // //         data: {
// // // //           "orderId": orderIdController.text.trim(),
// // // //           "productId": productIdController.text.trim(),
// // // //           "quantity": int.tryParse(quantityController.text.trim()) ?? 1,
// // // //         },
// // // //         options: Options(headers: {"Authorization": "Bearer $token"}),
// // // //       );

// // // //       setState(() => message = "✅ Product added successfully!");
// // // //     } catch (e) {
// // // //       setState(() => message = "❌ Error adding product: $e");
// // // //     } finally {
// // // //       setState(() => loading = false);
// // // //     }
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(title: const Text("Add Product to Order")),
// // // //       body: Padding(
// // // //         padding: const EdgeInsets.all(16),
// // // //         child: Column(
// // // //           children: [
// // // //             TextField(controller: orderIdController, decoration: const InputDecoration(labelText: "Order ID")),
// // // //             TextField(controller: productIdController, decoration: const InputDecoration(labelText: "Product ID")),
// // // //             TextField(controller: quantityController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Quantity")),
// // // //             const SizedBox(height: 20),
// // // //             ElevatedButton(
// // // //               onPressed: loading ? null : addProductToOrder,
// // // //               child: loading
// // // //                   ? const CircularProgressIndicator(color: Colors.white)
// // // //                   : const Text("Add Product"),
// // // //             ),
// // // //             if (message != null)
// // // //               Padding(
// // // //                 padding: const EdgeInsets.only(top: 16),
// // // //                 child: Text(message!,
// // // //                     style: TextStyle(color: message!.contains("✅") ? Colors.green : Colors.red)),
// // // //               ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // import 'package:flutter/material.dart';
// // // import 'package:dio/dio.dart';
// // // import '../../authpage/pages/auth_services.dart';

// // // class AddProductToOrderPage extends StatefulWidget {
// // //   const AddProductToOrderPage({super.key});

// // //   @override
// // //   State<AddProductToOrderPage> createState() => _AddProductToOrderPageState();
// // // }

// // // class _AddProductToOrderPageState extends State<AddProductToOrderPage> {
// // //   final TextEditingController orderIdController = TextEditingController();
// // //   final TextEditingController productIdController = TextEditingController();
// // //   final TextEditingController quantityController = TextEditingController();

// // //   final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));
// // //   bool loading = false;
// // //   String? message;

// // //   Future<void> addProductToOrder() async {
// // //     setState(() {
// // //       loading = true;
// // //       message = null;
// // //     });

// // //     try {
// // //       final authService = AuthService();
// // //       final token = await authService.getToken();

// // //       if (token == null) {
// // //         setState(() => message = "⚠️ Please log in again.");
// // //         return;
// // //       }

// // //       final response = await dio.post(
// // //         "/field-executive/orders/${orderIdController.text.trim()}/products",
// // //         data: {
// // //           "productId": productIdController.text.trim(),
// // //           "quantity": int.tryParse(quantityController.text.trim()) ?? 1,
// // //         },
// // //         options: Options(headers: {"Authorization": "Bearer $token"}),
// // //       );

// // //       if (response.statusCode == 200 || response.statusCode == 201) {
// // //         setState(() => message = "✅ Product added to order successfully!");
// // //       } else {
// // //         setState(() => message = "⚠️ Unexpected response: ${response.statusCode}");
// // //       }
// // //     } catch (e) {
// // //       setState(() => message = "❌ Error: $e");
// // //     } finally {
// // //       setState(() => loading = false);
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text("Add Product to Order")),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Column(
// // //           children: [
// // //             TextField(
// // //               controller: orderIdController,
// // //               decoration: const InputDecoration(labelText: "Order ID"),
// // //             ),
// // //             TextField(
// // //               controller: productIdController,
// // //               decoration: const InputDecoration(labelText: "Product ID"),
// // //             ),
// // //             TextField(
// // //               controller: quantityController,
// // //               decoration: const InputDecoration(labelText: "Quantity"),
// // //               keyboardType: TextInputType.number,
// // //             ),
// // //             const SizedBox(height: 20),
// // //             ElevatedButton(
// // //               onPressed: loading ? null : addProductToOrder,
// // //               child: loading
// // //                   ? const CircularProgressIndicator(color: Colors.white)
// // //                   : const Text("Add Product"),
// // //             ),
// // //             const SizedBox(height: 20),
// // //             if (message != null)
// // //               Text(
// // //                 message!,
// // //                 style: TextStyle(
// // //                   color: message!.contains("✅") ? Colors.green : Colors.red,
// // //                 ),
// // //               ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:dio/dio.dart';
// // import '../../authpage/pages/auth_services.dart';

// // class AddProductToOrderPage extends StatefulWidget {
// //   const AddProductToOrderPage({super.key});

// //   @override
// //   State<AddProductToOrderPage> createState() => _AddProductToOrderPageState();
// // }

// // class _AddProductToOrderPageState extends State<AddProductToOrderPage> {
// //   final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));
// //   final TextEditingController orderIdController = TextEditingController();
// //   final TextEditingController productIdController = TextEditingController();
// //   final TextEditingController quantityController = TextEditingController();
// //   bool loading = false;
// //   String? message;

// //   Future<void> addProduct() async {
// //     final orderId = orderIdController.text;
// //     final productId = int.tryParse(productIdController.text);
// //     final quantity = int.tryParse(quantityController.text);

// //     if (orderId.isEmpty || productId == null || quantity == null) return;

// //     setState(() {
// //       loading = true;
// //       message = null;
// //     });

// //     try {
// //       final authService = AuthService();
// //       final token = await authService.getToken();
// //       if (token == null) {
// //         setState(() => message = "⚠️ No token found. Please login again.");
// //         return;
// //       }

// //       final response = await dio.put(
// //         "/fieldExecutive/orders/$orderId/add-product",
// //         data: {"productId": productId, "quantity": quantity},
// //         options: Options(headers: {"Authorization": "Bearer $token"}),
// //       );

// //       setState(() {
// //         message = "✅ Product added successfully!";
// //       });
// //     } catch (e) {
// //       setState(() {
// //         message = "❌ Error: $e";
// //       });
// //     } finally {
// //       setState(() => loading = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Add Product to Order")),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             TextField(
// //               controller: orderIdController,
// //               decoration: const InputDecoration(labelText: "Order ID"),
// //             ),
// //             TextField(
// //               controller: productIdController,
// //               keyboardType: TextInputType.number,
// //               decoration: const InputDecoration(labelText: "Product ID"),
// //             ),
// //             TextField(
// //               controller: quantityController,
// //               keyboardType: TextInputType.number,
// //               decoration: const InputDecoration(labelText: "Quantity"),
// //             ),
// //             const SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: loading ? null : addProduct,
// //               child: loading
// //                   ? const CircularProgressIndicator(color: Colors.white)
// //                   : const Text("Add Product"),
// //             ),
// //             const SizedBox(height: 20),
// //             if (message != null)
// //               Text(
// //                 message!,
// //                 style: TextStyle(
// //                     color: message!.contains("✅") ? Colors.green : Colors.red,
// //                     fontWeight: FontWeight.w500),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import '../../authpage/pages/auth_services.dart';

// class AddProductToOrderPage extends StatefulWidget {
//   const AddProductToOrderPage({super.key});

//   @override
//   State<AddProductToOrderPage> createState() => _AddProductToOrderPageState();
// }

// class _AddProductToOrderPageState extends State<AddProductToOrderPage> {
//   final TextEditingController orderIdController = TextEditingController();
//   final TextEditingController productIdController = TextEditingController();
//   final TextEditingController quantityController = TextEditingController();

//   final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001")); // Change for deployed backend

//   bool loading = false;
//   String? message;
//   Map<String, dynamic>? updatedOrder;

//   Future<void> addProduct() async {
//     final orderId = orderIdController.text.trim();
//     final productId = int.tryParse(productIdController.text.trim());
//     final quantity = int.tryParse(quantityController.text.trim());

//     if (orderId.isEmpty || productId == null || quantity == null || quantity <= 0) {
//       setState(() => message = "⚠️ Enter valid Order ID, Product ID and Quantity");
//       return;
//     }

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

//       final response = await dio.put(
//         "/fieldExecutive/orders/$orderId/add-product",
//         data: {
//           "productId": productId,
//           "quantity": quantity,
//         },
//         options: Options(
//           headers: {"Authorization": "Bearer $token"},
//         ),
//       );

//       setState(() {
//         message = "✅ Product added successfully!";
//         updatedOrder = response.data['order'];
//       });
//     } catch (e) {
//       setState(() {
//         message = "❌ Error adding product: $e";
//       });
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Product to Order")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: orderIdController,
//               decoration: const InputDecoration(labelText: "Order ID"),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: productIdController,
//               decoration: const InputDecoration(labelText: "Product ID"),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: quantityController,
//               decoration: const InputDecoration(labelText: "Quantity"),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: loading ? null : addProduct,
//               child: loading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text("Add Product"),
//             ),
//             if (message != null) ...[
//               const SizedBox(height: 20),
//               Text(
//                 message!,
//                 style: TextStyle(
//                   color: message!.contains("✅") ? Colors.green : Colors.red,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//             if (updatedOrder != null) ...[
//               const SizedBox(height: 20),
//               Text(
//                 "Updated Order Items:",
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               ...List<Widget>.from(
//                 (updatedOrder!['orderItems'] as List<dynamic>).map(
//                   (item) => ListTile(
//                     title: Text(item['product']['name']),
//                     subtitle: Text(
//                         "Quantity: ${item['quantity']} | Unit Price: \$${item['unitPrice']}"),
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class AddProductToOrderPage extends StatefulWidget {
  const AddProductToOrderPage({super.key});

  @override
  State<AddProductToOrderPage> createState() => _AddProductToOrderPageState();
}

class _AddProductToOrderPageState extends State<AddProductToOrderPage> {
  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));

  final TextEditingController orderIdController = TextEditingController();
  final TextEditingController productIdController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  bool loading = false;
  String? message;
  Map<String, dynamic>? updatedOrder;

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  Future<void> addProductToOrder() async {
    final orderId = orderIdController.text.trim();
    final productId = productIdController.text.trim();
    final quantityText = quantityController.text.trim();

    if (orderId.isEmpty || productId.isEmpty || quantityText.isEmpty) {
      setState(() => message = "⚠️ All fields are required");
      return;
    }

    final quantity = int.tryParse(quantityText);
    if (quantity == null || quantity <= 0) {
      setState(() => message = "⚠️ Quantity must be a positive integer");
      return;
    }

    setState(() {
      loading = true;
      message = null;
      updatedOrder = null;
    });

    try {
      final token = await _getToken();

      final response = await dio.put(
        "/fieldExecutive/orders/$orderId/add-product",
        data: {
          "productId": productId,
          "quantity": quantity,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        updatedOrder = response.data['order'];
        message = response.data['message'];
        // Clear inputs
        productIdController.clear();
        quantityController.clear();
      });
    } catch (e) {
      String errorMessage = "❌ Failed to add product to order";
      if (e is DioError && e.response != null) {
        errorMessage = "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
      }
      setState(() => message = errorMessage);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    orderIdController.dispose();
    productIdController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product to Order")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (loading) const LinearProgressIndicator(),
            if (message != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  message!,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            TextField(controller: orderIdController, decoration: const InputDecoration(labelText: "Order ID")),
            TextField(controller: productIdController, decoration: const InputDecoration(labelText: "Product ID")),
            TextField(controller: quantityController, decoration: const InputDecoration(labelText: "Quantity"), keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: addProductToOrder, child: const Text("Add Product")),

            const SizedBox(height: 20),
            if (updatedOrder != null) ...[
              const Text("Updated Order", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Order ID: ${updatedOrder!['_id']}"),
              Text("Status: ${updatedOrder!['status']}"),
              Text("Order Items:", style: const TextStyle(fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: updatedOrder!['orderItems'].length,
                itemBuilder: (context, index) {
                  final item = updatedOrder!['orderItems'][index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text("${item['product']['name']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Quantity: ${item['quantity']}"),
                          Text("Unit Price: \$${item['unitPrice']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
