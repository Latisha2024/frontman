import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class CustomerVisitPage extends StatefulWidget {
  const CustomerVisitPage({super.key});

  @override
  State<CustomerVisitPage> createState() => _CustomerVisitPageState();
}

class _CustomerVisitPageState extends State<CustomerVisitPage> {
  final dio = Dio(BaseOptions(baseUrl: "https://frontman-1.onrender.com"));

  bool loading = false;
  String? message;

  Map<String, dynamic>? customer;
  List<dynamic> visits = [];
  List<dynamic> customers = [];
  String? selectedCustomerId;

  // Controllers
  final TextEditingController customerIdController = TextEditingController();
  final TextEditingController visitDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController peoplePresentController = TextEditingController();
  final TextEditingController productsDiscussedController =
      TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController concernsController = TextEditingController();
  final TextEditingController investigationController = TextEditingController();
  final TextEditingController rootCauseController = TextEditingController();
  final TextEditingController correctiveActionController =
      TextEditingController();
  final TextEditingController recommendationsController =
      TextEditingController();
  final TextEditingController feedbackController = TextEditingController();
  final TextEditingController reportCompletedByController =
      TextEditingController(); // NEW

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  // 0️⃣ Get Assigned Customers for dropdown
  Future<void> getAssignedCustomers() async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final token = await _getToken();
      final response = await dio.get(
        "/fieldExecutive/customers",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      final data = response.data;
      if (data is List) {
        customers = data;
      } else {
        customers = [];
      }
      if (customers.isNotEmpty) {
        selectedCustomerId = customers.first['id']?.toString();
        customerIdController.text = selectedCustomerId ?? '';
      }
      setState(() {});
    } catch (e) {
      String errorMessage = "❌ Failed to load customers";
      if (e is DioException && e.response != null) {
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
    getAssignedCustomers();
  }

  // 1️⃣ Get Customer By ID
  Future<void> getCustomerById() async {
    final id = customerIdController.text.trim();
    if (id.isEmpty) {
      setState(() => message = "⚠️ Enter Customer ID");
      return;
    }

    setState(() {
      loading = true;
      message = null;
      customer = null;
    });

    try {
      final token = await _getToken();
      final response = await dio.get(
        "/fieldExecutive/customers/$id",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      setState(() {
        customer = response.data;
        message = "✅ Customer fetched successfully";
        customerIdController.text = response.data['id'].toString();
      });
    } catch (e) {
      String errorMessage = "❌ Failed to fetch customer";
      if (e is DioException && e.response != null) {
        errorMessage =
            "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
      }
      setState(() => message = errorMessage);
    } finally {
      setState(() => loading = false);
    }
  }

  // 2️⃣ Create Visit Report
  Future<void> createVisitReport() async {
    final id = customerIdController.text.trim();
    if (id.isEmpty ||
        visitDateController.text.isEmpty ||
        locationController.text.isEmpty ||
        reportCompletedByController.text.isEmpty) {
      setState(() => message =
          "⚠️ Customer ID, Visit Date, Location & Completed By are required");
      return;
    }

    setState(() {
      loading = true;
      message = null;
    });

    try {
      final token = await _getToken();
      try {
        DateTime.parse(visitDateController.text);
      } catch (_) {
        setState(() => message = "⚠️ Invalid date format (use YYYY-MM-DD)");
        return;
      }
      await dio.post(
        "/fieldExecutive/customers/$id/visits",
        data: {
          "visitDate": visitDateController.text,
          "location": locationController.text,
          "peoplePresent": peoplePresentController.text,
          "productsDiscussed": productsDiscussedController.text,
          "reasonForVisit": reasonController.text,
          "customerConcerns": concernsController.text,
          "investigationStatus": investigationController.text,
          "rootCause": rootCauseController.text,
          "correctiveAction": correctiveActionController.text,
          "recommendations": recommendationsController.text,
          "feedback": feedbackController.text,
          "reportCompletedBy": reportCompletedByController.text, // NEW
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        message = "✅ Visit report created successfully!";
        // Clear form
        visitDateController.clear();
        locationController.clear();
        peoplePresentController.clear();
        productsDiscussedController.clear();
        reasonController.clear();
        concernsController.clear();
        investigationController.clear();
        rootCauseController.clear();
        correctiveActionController.clear();
        recommendationsController.clear();
        feedbackController.clear();
        reportCompletedByController.clear();
      });

      getVisitReports(); // Refresh visit list
    } catch (e) {
      String errorMessage = "❌ Failed to create visit report";
      if (e is DioException && e.response != null) {
        errorMessage =
            "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
      }
      setState(() => message = errorMessage);
    } finally {
      setState(() => loading = false);
    }
  }

  // 3️⃣ Get Visit Reports
  Future<void> getVisitReports() async {
    final id = customerIdController.text.trim();

    setState(() {
      loading = true;
      message = null;
      visits = [];
    });

    try {
      final token = await _getToken();
      Map<String, dynamic>? queryParams;
      if (id.isNotEmpty) queryParams = {"customerId": id};

      final response = await dio.get(
        "/fieldExecutive/customers/visits",
        queryParameters: queryParams,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        // Backend returns an array, not an object. Fall back to ['visits'] if shape changes.
        final data = response.data;
        if (data is List) {
          visits = data;
        } else if (data is Map && data['visits'] is List) {
          visits = data['visits'];
        } else {
          visits = [];
        }
        message = "📄 ${visits.length} visit reports found.";
      });
    } catch (e) {
      String errorMessage = "❌ Failed to fetch visit reports";
      if (e is DioException && e.response != null) {
        errorMessage =
            "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
      }
      setState(() => message = errorMessage);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    customerIdController.dispose();
    visitDateController.dispose();
    locationController.dispose();
    peoplePresentController.dispose();
    productsDiscussedController.dispose();
    reasonController.dispose();
    concernsController.dispose();
    investigationController.dispose();
    rootCauseController.dispose();
    correctiveActionController.dispose();
    recommendationsController.dispose();
    feedbackController.dispose();
    reportCompletedByController.dispose(); // NEW
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer Visits")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (loading) const LinearProgressIndicator(),
            if (message != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(message!,
                    style: const TextStyle(fontSize: 16, color: Colors.red)),
              ),

            DropdownButtonFormField<String>(
              value: selectedCustomerId,
              isExpanded: true,
              decoration: const InputDecoration(labelText: "Select Customer"),
              items: customers
                  .map<DropdownMenuItem<String>>((c) => DropdownMenuItem(
                        value: c['id']?.toString(),
                        child: Text(
                            (c['name'] ?? 'Unknown') +
                                (c['phone'] != null ? " (${c['phone']})" : ''),
                            overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCustomerId = value;
                  customerIdController.text = value ?? '';
                });
              },
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: getAssignedCustomers,
                        child: const Text("Refresh Customers"))),
                const SizedBox(width: 10),
                Expanded(
                    child: ElevatedButton(
                        onPressed: getVisitReports,
                        child: const Text("Get Visits"))),
              ],
            ),

            const SizedBox(height: 20),
            if (customer != null) ...[
              Text("Customer Info",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("Name: ${customer!['name']}"),
              Text("Email: ${customer!['email'] ?? '-'}"),
              Text("Phone: ${customer!['phone']}"),
              const Divider(),
            ],

            const Text("Create Visit Report",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
                controller: visitDateController,
                decoration: const InputDecoration(
                    labelText: "Visit Date (YYYY-MM-DD)")),
            TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "Location")),
            TextField(
                controller: peoplePresentController,
                decoration: const InputDecoration(labelText: "People Present")),
            TextField(
                controller: productsDiscussedController,
                decoration:
                    const InputDecoration(labelText: "Products Discussed")),
            TextField(
                controller: reasonController,
                decoration:
                    const InputDecoration(labelText: "Reason for Visit")),
            TextField(
                controller: concernsController,
                decoration:
                    const InputDecoration(labelText: "Customer Concerns")),
            TextField(
                controller: investigationController,
                decoration:
                    const InputDecoration(labelText: "Investigation Status")),
            TextField(
                controller: rootCauseController,
                decoration: const InputDecoration(labelText: "Root Cause")),
            TextField(
                controller: correctiveActionController,
                decoration:
                    const InputDecoration(labelText: "Corrective Action")),
            TextField(
                controller: recommendationsController,
                decoration:
                    const InputDecoration(labelText: "Recommendations")),
            TextField(
                controller: feedbackController,
                decoration: const InputDecoration(labelText: "Feedback")),
            TextField(
                controller: reportCompletedByController,
                decoration: const InputDecoration(
                    labelText: "Report Completed By")), // NEW
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: createVisitReport,
                child: const Text("Submit Visit Report")),

            const SizedBox(height: 20),
            if (visits.isNotEmpty) ...[
              const Text("Visit Reports",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visits.length,
                itemBuilder: (context, index) {
                  final visit = visits[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                          "Visit on ${visit['visitDate'].toString().split('T')[0]} at ${visit['location']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("People: ${visit['peoplePresent'] ?? '-'}"),
                          Text(
                              "Products: ${visit['productsDiscussed'] ?? '-'}"),
                          Text("Reason: ${visit['reasonForVisit'] ?? '-'}"),
                          Text("Feedback: ${visit['feedback'] ?? '-'}"),
                          Text(
                              "Completed By: ${visit['reportCompletedBy'] ?? '-'}"), // NEW
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
