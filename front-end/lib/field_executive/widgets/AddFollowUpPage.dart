import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class AddFollowUpPage extends StatefulWidget {
  const AddFollowUpPage({super.key});

  @override
  State<AddFollowUpPage> createState() => _AddFollowUpPageState();
}

class _AddFollowUpPageState extends State<AddFollowUpPage> {
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController contactDetailsController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  DateTime? selectedDate;

  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));
  bool loading = false;
  String? message;

  Future<void> createFollowUp() async {
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

      if (selectedDate == null) {
        setState(() => message = "⚠️ Please select a next follow-up date.");
        return;
      }

      final response = await dio.post(
        "/field-executive/followups",
        data: {
          "customerName": customerNameController.text.trim(),
          "contactDetails": contactDetailsController.text.trim(),
          "feedback": feedbackController.text.trim(),
          "status": statusController.text.trim(),
          "nextFollowUpDate": selectedDate!.toIso8601String(),
        },
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      setState(() {
        message = "✅ Follow-up created successfully!";
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

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Follow-Up")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: customerNameController,
                decoration: const InputDecoration(labelText: "Customer Name"),
              ),
              TextField(
                controller: contactDetailsController,
                decoration: const InputDecoration(labelText: "Contact Details (Phone / Email)"),
              ),
              TextField(
                controller: feedbackController,
                decoration: const InputDecoration(labelText: "Feedback / Remarks"),
              ),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: "Status (e.g., Pending, Completed)"),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? "Next Follow-Up Date: Not selected"
                          : "Next Follow-Up: ${selectedDate!.toLocal().toString().split(' ')[0]}",
                    ),
                  ),
                  TextButton.icon(
                    onPressed: pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text("Pick Date"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : createFollowUp,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit Follow-Up"),
              ),
              const SizedBox(height: 20),
              if (message != null)
                Text(
                  message!,
                  style: TextStyle(
                    color: message!.contains("✅")
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
