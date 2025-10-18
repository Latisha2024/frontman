// // // import 'package:flutter/material.dart';
// // // import '../../constants/colors.dart'; // Adjust path if needed

// // // class TasksPage extends StatelessWidget {
// // //   const TasksPage({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final tasks = [
// // //       {
// // //         'title': 'Visit Client A',
// // //         'description': 'Meet client A at 11:00 AM for product demo and feedback collection.',
// // //         'status': 'Pending'
// // //       },
// // //       {
// // //         'title': 'Collect Payment from Client B',
// // //         'description': 'Collect payment for invoice #234 from Client B by 2:00 PM.',
// // //         'status': 'In Progress'
// // //       },
// // //       {
// // //         'title': 'Update Inventory',
// // //         'description': 'Sync inventory data collected during the last visit with the warehouse server.',
// // //         'status': 'Completed'
// // //       },
// // //       {
// // //         'title': 'Deliver Order #4567',
// // //         'description': 'Deliver product package to Client C before 5:00 PM.',
// // //         'status': 'Pending'
// // //       },
// // //       {
// // //         'title': 'Schedule Next Visit with Client D',
// // //         'description': 'Call Client D and fix the appointment for next week.',
// // //         'status': 'Pending'
// // //       },
// // //     ];

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text(
// // //           "Assigned Tasks",
// // //           style: TextStyle(color: AppColors.textLight),
// // //         ),
// // //         backgroundColor: AppColors.primaryBlue,
// // //         elevation: 2,
// // //         iconTheme: const IconThemeData(color: AppColors.textLight),
// // //       ),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(12),
// // //         child: tasks.isEmpty
// // //             ? Center(
// // //                 child: Text(
// // //                   "No tasks assigned yet.",
// // //                   style: TextStyle(
// // //                     fontSize: 16,
// // //                     color: AppColors.textSecondary,
// // //                   ),
// // //                 ),
// // //               )
// // //             : ListView.builder(
// // //                 itemCount: tasks.length,
// // //                 itemBuilder: (context, index) {
// // //                   final task = tasks[index];
// // //                   final String status = task['status'] ?? '';

// // //                   Color statusColor;
// // //                   switch (status) {
// // //                     case 'Completed':
// // //                       statusColor = AppColors.success;
// // //                       break;
// // //                     case 'In Progress':
// // //                       statusColor = AppColors.warning;
// // //                       break;
// // //                     case 'Pending':
// // //                     default:
// // //                       statusColor = AppColors.error;
// // //                       break;
// // //                   }

// // //                   return Card(
// // //                     shape: RoundedRectangleBorder(
// // //                         borderRadius: BorderRadius.circular(12)),
// // //                     elevation: 3,
// // //                     margin: const EdgeInsets.symmetric(vertical: 8),
// // //                     child: Padding(
// // //                       padding: const EdgeInsets.all(16),
// // //                       child: Column(
// // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // //                         children: [
// // //                           Row(
// // //                             children: [
// // //                               const Icon(Icons.task_alt,
// // //                                   color: AppColors.primaryBlue),
// // //                               const SizedBox(width: 8),
// // //                               Expanded(
// // //                                 child: Text(
// // //                                   task['title'] ?? '',
// // //                                   style: const TextStyle(
// // //                                     fontSize: 18,
// // //                                     fontWeight: FontWeight.bold,
// // //                                     color: AppColors.textColor,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                           const SizedBox(height: 8),
// // //                           Text(
// // //                             task['description'] ?? '',
// // //                             style: const TextStyle(
// // //                               fontSize: 14,
// // //                               color: AppColors.textSecondary,
// // //                             ),
// // //                           ),
// // //                           const SizedBox(height: 12),
// // //                           Row(
// // //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                             children: [
// // //                               Chip(
// // //                                 label: Text(status),
// // //                                 backgroundColor: statusColor.withOpacity(0.15),
// // //                                 labelStyle: TextStyle(
// // //                                   color: statusColor,
// // //                                   fontWeight: FontWeight.w600,
// // //                                 ),
// // //                               ),
// // //                               ElevatedButton(
// // //                                 onPressed: () {
// // //                                   showDialog(
// // //                                     context: context,
// // //                                     builder: (ctx) => AlertDialog(
// // //                                       title: Text(task['title'] ?? 'Task'),
// // //                                       content: Text(
// // //                                           '${task['description']}\n\nStatus: $status'),
// // //                                       actions: [
// // //                                         TextButton(
// // //                                           onPressed: () => Navigator.pop(ctx),
// // //                                           child: const Text('Close'),
// // //                                         )
// // //                                       ],
// // //                                     ),
// // //                                   );
// // //                                 },
// // //                                 style: ElevatedButton.styleFrom(
// // //                                   backgroundColor: AppColors.primaryBlue,
// // //                                 ),
// // //                                 child: const Text(
// // //                                   "View Task",
// // //                                   style: TextStyle(color: AppColors.textLight),
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   );
// // //                 },
// // //               ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:dio/dio.dart';
// // import '../../authpage/pages/auth_services.dart';

// // class TaskAddPage extends StatefulWidget {
// //   const TaskAddPage({super.key});

// //   @override
// //   State<TaskAddPage> createState() => _TaskAddPageState();
// // }

// // class _TaskAddPageState extends State<TaskAddPage> {
// //   final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));
// //   bool loading = false;
// //   String? message;

// //   final TextEditingController titleController = TextEditingController();
// //   final TextEditingController descriptionController = TextEditingController();
// //   final TextEditingController assignedToController = TextEditingController();

// //   String priority = 'Normal';
// //   DateTime dueDate = DateTime.now();

// //   Future<void> submitTask() async {
// //     setState(() {
// //       loading = true;
// //       message = null;
// //     });

// //     try {
// //       final authService = AuthService();
// //       final token = await authService.getToken();
// //       if (token == null) return;

// //       final response = await dio.post(
// //         '/fieldExecutive/task/add',
// //         data: {
// //           'title': titleController.text.trim(),
// //           'description': descriptionController.text.trim(),
// //           'assignedTo': assignedToController.text.trim(),
// //           'priority': priority,
// //           'dueDate': dueDate.toIso8601String(),
// //         },
// //         options: Options(
// //           headers: {'Authorization': 'Bearer $token'},
// //         ),
// //       );

// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         setState(() {
// //           message = "✅ Task added successfully!";
// //         });
// //       } else {
// //         setState(() {
// //           message = "⚠️ Failed to add task (${response.statusCode})";
// //         });
// //       }
// //     } catch (e) {
// //       setState(() {
// //         message = "❌ Error: $e";
// //       });
// //     } finally {
// //       setState(() => loading = false);
// //     }
// //   }

// //   Future<void> pickDueDate() async {
// //     final picked = await showDatePicker(
// //       context: context,
// //       initialDate: dueDate,
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime(2030),
// //     );
// //     if (picked != null) setState(() => dueDate = picked);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Add Task")),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             TextField(
// //               controller: titleController,
// //               decoration: const InputDecoration(
// //                 labelText: "Task Title",
// //                 border: OutlineInputBorder(),
// //               ),
// //             ),
// //             const SizedBox(height: 10),
// //             TextField(
// //               controller: descriptionController,
// //               maxLines: 3,
// //               decoration: const InputDecoration(
// //                 labelText: "Description",
// //                 border: OutlineInputBorder(),
// //               ),
// //             ),
// //             const SizedBox(height: 10),
// //             TextField(
// //               controller: assignedToController,
// //               decoration: const InputDecoration(
// //                 labelText: "Assign To (optional)",
// //                 border: OutlineInputBorder(),
// //               ),
// //             ),
// //             const SizedBox(height: 10),
// //             DropdownButtonFormField<String>(
// //               value: priority,
// //               items: ['Low', 'Normal', 'High']
// //                   .map((e) => DropdownMenuItem(value: e, child: Text(e)))
// //                   .toList(),
// //               onChanged: (val) {
// //                 if (val != null) setState(() => priority = val);
// //               },
// //               decoration: const InputDecoration(
// //                 labelText: "Priority",
// //                 border: OutlineInputBorder(),
// //               ),
// //             ),
// //             const SizedBox(height: 10),
// //             Row(
// //               children: [
// //                 Expanded(child: Text("Due Date: ${dueDate.toLocal().toString().split(' ')[0]}")),
// //                 TextButton.icon(
// //                   icon: const Icon(Icons.calendar_today),
// //                   label: const Text("Pick Date"),
// //                   onPressed: pickDueDate,
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 16),
// //             ElevatedButton(
// //               onPressed: loading ? null : submitTask,
// //               child: loading
// //                   ? const CircularProgressIndicator(color: Colors.white)
// //                   : const Text("Add Task"),
// //             ),
// //             if (message != null) ...[
// //               const SizedBox(height: 16),
// //               Text(
// //                 message!,
// //                 style: TextStyle(
// //                   color: message!.contains("✅") ? Colors.green : Colors.red,
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //               ),
// //             ]
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
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

  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));
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
 
