// // // import 'package:flutter/material.dart';
// // // import '../../constants/colors.dart';

// // // class AssignedCustomersPage extends StatelessWidget {
// // //   const AssignedCustomersPage({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final customers = [
// // //       {
// // //         "id": "CUST101",
// // //         "name": "Dairybelle",
// // //         "location": "Pinetown",
// // //         "contact": "1234567890",
// // //         "email": "dairy@example.com"
// // //       },
// // //       {
// // //         "id": "CUST102",
// // //         "name": "MilkMart",
// // //         "location": "Durban",
// // //         "contact": "9876543210",
// // //         "email": "milk@example.com"
// // //       },
// // //       {
// // //         "id": "CUST103",
// // //         "name": "Creamy Lane",
// // //         "location": "Umhlanga",
// // //         "contact": "9988776655",
// // //         "email": "creamy@example.com"
// // //       },
// // //     ];

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text("Assigned Customers"),
// // //         backgroundColor: AppColors.primaryBlue,
// // //       ),
// // //       body: Container(
// // //         color: Colors.grey.shade100,
// // //         padding: const EdgeInsets.all(12),
// // //         child: ListView.builder(
// // //           itemCount: customers.length,
// // //           itemBuilder: (context, index) {
// // //             final customer = customers[index];
// // //             return Card(
// // //               elevation: 4,
// // //               margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
// // //               shape: RoundedRectangleBorder(
// // //                 borderRadius: BorderRadius.circular(12),
// // //               ),
// // //               child: Padding(
// // //                 padding: const EdgeInsets.all(16),
// // //                 child: Row(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     const Icon(Icons.person_pin, size: 40, color: AppColors.primaryBlue),
// // //                     const SizedBox(width: 16),
// // //                     Expanded(
// // //                       child: Column(
// // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // //                         children: [
// // //                           Text(
// // //                             customer["name"] ?? '',
// // //                             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //                           ),
// // //                           const SizedBox(height: 6),
// // //                           Text("ID: ${customer["id"]}", style: const TextStyle(fontSize: 14)),
// // //                           Text("Location: ${customer["location"]}", style: const TextStyle(fontSize: 14)),
// // //                           Text("Contact: ${customer["contact"]}", style: const TextStyle(fontSize: 14)),
// // //                           Text("Email: ${customer["email"]}", style: const TextStyle(fontSize: 14)),
// // //                           const SizedBox(height: 10),
// // //                           Row(
// // //                             children: [
// // //                               ElevatedButton.icon(
// // //                                 onPressed: () {
// // //                                   // Add call logic or link with dialer
// // //                                 },
// // //                                 icon: const Icon(Icons.phone),
// // //                                 label: const Text("Call"),
// // //                                 style: ElevatedButton.styleFrom(
// // //                                   backgroundColor: Colors.green,
// // //                                   foregroundColor: Colors.white,
// // //                                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // //                                   shape: RoundedRectangleBorder(
// // //                                     borderRadius: BorderRadius.circular(8),
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                               const SizedBox(width: 12),
// // //                               ElevatedButton.icon(
// // //                                 onPressed: () {
// // //                                   // Add email logic or mailto:
// // //                                 },
// // //                                 icon: const Icon(Icons.email),
// // //                                 label: const Text("Email"),
// // //                                 style: ElevatedButton.styleFrom(
// // //                                   backgroundColor: Colors.blueGrey,
// // //                                   foregroundColor: Colors.white,
// // //                                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // //                                   shape: RoundedRectangleBorder(
// // //                                     borderRadius: BorderRadius.circular(8),
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           )
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             );
// // //           },
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import '../../authpage/pages/auth_services.dart';
// // import 'package:dio/dio.dart';

// // class AssignCustomerPage extends StatefulWidget {
// //   const AssignCustomerPage({super.key});

// //   @override
// //   State<AssignCustomerPage> createState() => _AssignCustomerPageState();
// // }

// // class _AssignCustomerPageState extends State<AssignCustomerPage> {
// //   final TextEditingController customerIdController = TextEditingController();
// //   final TextEditingController executiveIdController = TextEditingController();
// //   final authService = AuthService();
// //   bool loading = false;
// //   String? message;

// //   Future<void> assignCustomer() async {
// //     setState(() => loading = true);
// //     try {
// //       final token = await authService.getToken();
// //       if (token == null) {
// //         setState(() => message = "⚠️ Please login again.");
// //         return;
// //       }

// //       final response = await authService.dio.post(
// //         "/sales-executive/customers/assign",
// //         data: {
// //           "customerId": customerIdController.text.trim(),
// //           "executiveId": executiveIdController.text.trim(),
// //         },
// //         options: Options(headers: {"Authorization": "Bearer $token"}),
// //       );

// //       setState(() => message = "✅ Customer assigned successfully!");
// //     } catch (e) {
// //       setState(() => message = "❌ Error assigning customer: $e");
// //     } finally {
// //       setState(() => loading = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Assign Customer")),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             TextField(controller: customerIdController, decoration: const InputDecoration(labelText: "Customer ID")),
// //             TextField(controller: executiveIdController, decoration: const InputDecoration(labelText: "Sales Executive ID")),
// //             const SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: loading ? null : assignCustomer,
// //               child: loading
// //                   ? const CircularProgressIndicator(color: Colors.white)
// //                   : const Text("Assign"),
// //             ),
// //             if (message != null)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 16),
// //                 child: Text(message!,
// //                     style: TextStyle(color: message!.contains("✅") ? Colors.green : Colors.red)),
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

// class AssignCustomersPage extends StatefulWidget {
//   const AssignCustomersPage({super.key});

//   @override
//   State<AssignCustomersPage> createState() => _AssignCustomersPageState();
// }

// class _AssignCustomersPageState extends State<AssignCustomersPage> {
//   final TextEditingController customerIdController = TextEditingController();
//   final TextEditingController executiveIdController = TextEditingController();

//   final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));
//   bool loading = false;
//   String? message;

//   Future<void> assignCustomer() async {
//     setState(() {
//       loading = true;
//       message = null;
//     });

//     try {
//       final authService = AuthService();
//       final token = await authService.getToken();

//       if (token == null) {
//         setState(() => message = "⚠️ Please log in again.");
//         return;
//       }

//       final response = await dio.post(
//         "/fieldExecutive/customers/assign",
//         data: {
//           "customerId": customerIdController.text.trim(),
//           "executiveId": executiveIdController.text.trim(),
//         },
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         setState(() => message = "✅ Customer assigned successfully!");
//       } else {
//         setState(() => message = "⚠️ Unexpected response: ${response.statusCode}");
//       }
//     } catch (e) {
//       setState(() => message = "❌ Error: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Assign Customer")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: customerIdController,
//               decoration: const InputDecoration(labelText: "Customer ID"),
//             ),
//             TextField(
//               controller: executiveIdController,
//               decoration: const InputDecoration(labelText: "Executive ID"),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: loading ? null : assignCustomer,
//               child: loading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text("Assign Customer"),
//             ),
//             const SizedBox(height: 20),
//             if (message != null)
//               Text(
//                 message!,
//                 style: TextStyle(
//                   color: message!.contains("✅") ? Colors.green : Colors.red,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// field_executive_customers_page.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class FieldExecutiveCustomersPage extends StatefulWidget {
  const FieldExecutiveCustomersPage({super.key});

  @override
  State<FieldExecutiveCustomersPage> createState() =>
      _FieldExecutiveCustomersPageState();
}

class _FieldExecutiveCustomersPageState
    extends State<FieldExecutiveCustomersPage> {
  final Dio dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));

  bool loading = false;
  String? message;
  List<dynamic> customerList = [];

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  Future<void> _getAssignedCustomers() async {
    setState(() {
      loading = true;
      message = null;
      customerList = [];
    });

    try {
      final token = await _getToken();
      if (token == null) {
        setState(() {
          message = "⚠️ Please login again.";
          loading = false;
        });
        return;
      }

      final response = await dio.get(
        "/fieldExecutive/customers",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        customerList = response.data;
        message = "👥 ${customerList.length} customers found.";
      });
    } catch (e) {
      String errorMessage = "❌ Error fetching customers.";
      if (e is DioError && e.response != null) {
        errorMessage =
            "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
      }
      setState(() => message = errorMessage);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _getAssignedCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assigned Customers")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (loading) const LinearProgressIndicator(),
            if (message != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  message!,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            const Divider(),
            const Text(
              "My Customers",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (customerList.isEmpty && !loading)
              const Text("No customers assigned."),
            ...customerList.map((customer) {
              final lastVisit =
                  customer['visits'] != null && customer['visits'].isNotEmpty
                      ? customer['visits'][0]
                      : null;

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(customer['name'] ?? 'No Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ID: ${customer['id']}"),
                      if (customer['email'] != null)
                        Text("Email: ${customer['email']}"),
                      if (customer['phone'] != null)
                        Text("Phone: ${customer['phone']}"),
                      if (customer['location'] != null)
                        Text("Location: ${customer['location']}"),
                      if (lastVisit != null)
                        Text(
                          "Last Visit: ${lastVisit['visitDate'] ?? 'N/A'} - Reason: ${lastVisit['reasonForVisit'] ?? 'N/A'}",
                        ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

