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
  final Dio dio = Dio(BaseOptions(baseUrl: "https://frontman-1.onrender.com"));

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

