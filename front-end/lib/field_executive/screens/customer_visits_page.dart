import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:role_based_app/authpage/config/app_colors.dart';
import '../../constants/colors.dart';

// Import the form pages
import '../widgets/AssignedCustomersPage.dart';
import '../widgets/CustomerVisitReportFormPage.dart';
import '../widgets/SubmitDvrPage.dart';
import '../widgets/AddFollowUpPage.dart';

class CustomerVisitsPage extends StatefulWidget {
  const CustomerVisitsPage({super.key});

  @override
  State<CustomerVisitsPage> createState() => _CustomerVisitsPageState();
}

class _CustomerVisitsPageState extends State<CustomerVisitsPage> {
  final int userId = 101;
  List<Map<String, dynamic>> assignedCustomers = [];
  String message = '';

  Future<void> getAssignedCustomers() async {
    try {
      final response = await http.post(
        Uri.parse('https://yourapi.com/api/field-executive/customers/assigned'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"userId": userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          assignedCustomers = List<Map<String, dynamic>>.from(data['customers'] ?? []);
          message = 'Customers fetched successfully!';
        });
      } else {
        setState(() => message = 'Failed to fetch customers.');
      }
    } catch (e) {
      setState(() => message = 'Error: ${e.toString()}');
    }
  }

  Future<void> visitCustomer(int customerId) async {
    try {
      final response = await http.post(
        Uri.parse('https://yourapi.com/api/field-executive/customers/visit'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "customerId": customerId,
          "visitTime": DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => message = data['message']?.toString() ?? 'Visit recorded');
      } else {
        setState(() => message = 'Failed to record visit.');
      }
    } catch (e) {
      setState(() => message = 'Error: ${e.toString()}');
    }
  }

  Widget buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 36, color: const Color(0xFFA5C8D0)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getAssignedCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: AppBar(
        title: const Text("CUSTOMER VISITS", style: TextStyle(color: Colors.white)),
        backgroundColor: AuthColors.textDark,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildActionCard(
                    icon: Icons.group,
                    title: "Assigned Customers",
                    description: "View customers assigned to you.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AssignedCustomersPage()),
                      );
                    },
                  ),
                  buildActionCard(
                    icon: Icons.pin_drop,
                    title: "Visit Customer",
                    description: "Record a customer visit with timestamp.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CustomerVisitReportFormPage()),
                      );
                    },
                  ),
                  buildActionCard(
                    icon: Icons.assignment_turned_in,
                    title: "Submit DVR",
                    description: "Log customer feedback and location.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SubmitDvrPage()),
                      );
                    },
                  ),
                  buildActionCard(
                    icon: Icons.calendar_today,
                    title: "Add Follow-Up",
                    description: "Schedule next follow-up with feedback.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddFollowUpPage()),
                      );
                    },
                  ),
                  if (message.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(message, style: const TextStyle(color: Colors.green, fontSize: 14)),
                  ]
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black12)),
              color: Color(0xFFEFF6F8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.menu, size: 30, color: Color(0xFFA5C8D0)),
                Icon(Icons.arrow_back, size: 30, color: Color(0xFFA5C8D0)),
                Icon(Icons.settings, size: 30, color: Color(0xFFA5C8D0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
