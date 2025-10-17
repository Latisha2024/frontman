// import 'package:flutter/material.dart';
// import '../../constants/colors.dart';

// class GetProductDetailsPage extends StatelessWidget {
//   const GetProductDetailsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final productIdController = TextEditingController();

//     // Mock function to simulate backend data
//     Map<String, dynamic>? getProductById(String id) {
//       const mockProductData = {
//         "P123": {"name": "Wireless Mouse", "price": 499.0, "stock": 12},
//         "P456": {"name": "Bluetooth Speaker", "price": 999.0, "stock": 5},
//         "P789": {"name": "Gaming Keyboard", "price": 1299.0, "stock": 0},
//       };
//       return mockProductData[id];
//     }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Get Product Details"),
//         backgroundColor: AppColors.primary,
//         elevation: 2,
//         foregroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Card(
//           elevation: 4,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           margin: const EdgeInsets.all(24),
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   "Product Lookup",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: productIdController,
//                   decoration: InputDecoration(
//                     labelText: "Enter Product ID",
//                     hintText: "e.g. P123",
//                     border: const OutlineInputBorder(),
//                     filled: true,
//                     fillColor: AppColors.inputFill,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       String productId = productIdController.text.trim();
//                       if (productId.isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Please enter a Product ID")),
//                         );
//                         return;
//                       }

//                       final product = getProductById(productId);

//                       showDialog(
//                         context: context,
//                         builder: (_) => AlertDialog(
//                           title: const Text("Product Details"),
//                           content: product != null
//                               ? Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text("Name: ${product['name']}"),
//                                     Text("Price: ₹${product['price']}"),
//                                     Text("Stock: ${product['stock']}"),
//                                   ],
//                                 )
//                               : const Text("Product not found!"),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context),
//                               child: const Text("OK"),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.search),
//                     label: const Text("Fetch Product Info"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));
  bool loading = true;
  String? message;
  List orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() {
      loading = true;
      message = null;
    });

    try {
      final authService = AuthService();
      final token = await authService.getToken();
      if (token == null) {
        setState(() => message = "⚠️ No token found. Please login again.");
        return;
      }

      final response = await dio.get(
        "/fieldExecutive/orders",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        orders = response.data;
      });
    } catch (e) {
      setState(() {
        message = "❌ Error: $e";
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
      appBar: AppBar(title: const Text("My Orders")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : message != null
              ? Center(child: Text(message!))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ExpansionTile(
                        title: Text(
                          "Order ID: ${order['id']} | Total: \$${order['totalAmount']}",
                        ),
                        subtitle: Text(
                            "Status: ${order['status']} | Date: ${order['orderDate'].split('T')[0]}"),
                        children: order['items']
                            .map<Widget>((item) => ListTile(
                                  title: Text(item['productName']),
                                  subtitle: Text(
                                      "Quantity: ${item['quantity']} | Unit Price: \$${item['unitPrice']}"),
                                ))
                            .toList(),
                      ),
                    );
                  },
                ),
    );
  }
}
