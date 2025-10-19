import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  DateTime? selectedDueDate;

  final dio = Dio(BaseOptions(baseUrl: "https://frontman-1.onrender.com"));
  bool loading = false;
  String? message;

  // ====================
  // CREATE TASK METHOD
  // ====================
  Future<void> createTask() async {
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

      if (titleController.text.trim().isEmpty ||
          descriptionController.text.trim().isEmpty) {
        setState(() => message = "⚠️ Please fill all required fields.");
        return;
      }

      final response = await dio.post(
        "/fieldExecutive/task",
        data: {
          "title": titleController.text.trim(),
          "description": descriptionController.text.trim(),
          "status": statusController.text.trim().isEmpty
              ? "Pending"
              : statusController.text.trim(),
          "dueDate": selectedDueDate?.toIso8601String(),
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        message = "✅ Task created successfully!";
      });
    } catch (e) {
      setState(() {
        message = "❌ Error: $e";
      });
    } finally {
      setState(() => loading = false);
    }
  }

  // ====================
  // PICK DUE DATE
  // ====================
  Future<void> pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Task Title",
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Task Description",
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(
                  labelText: "Status (Pending / InProgress / Completed)",
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDueDate == null
                          ? "Due Date: Not selected"
                          : "Due Date: ${selectedDueDate!.toLocal().toString().split(' ')[0]}",
                    ),
                  ),
                  TextButton.icon(
                    onPressed: pickDueDate,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text("Pick Date"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : createTask,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit Task"),
              ),
              const SizedBox(height: 20),
              if (message != null)
                Text(
                  message!,
                  style: TextStyle(
                    color:
                        message!.contains("✅") ? Colors.green : Colors.redAccent,
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
 
