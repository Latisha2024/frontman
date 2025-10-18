// import 'package:flutter/material.dart';
// import '../../constants/colors.dart';

// class AddFollowUpPage extends StatelessWidget {
//   const AddFollowUpPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // ✅ Pre-filled demo data
//     final TextEditingController customerController = TextEditingController(text: 'Priya Sharma');
//     final TextEditingController followUpDetailsController = TextEditingController(
//       text: 'Wants to reschedule delivery for next Monday',
//     );

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryBlue,
//         title: const Text('Add Follow-Up'),
//       ),
//       body: Container(
//         color: AppColors.backgroundGray,
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Recent Follow-Ups',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
//               _buildFollowUpCard('John Doe', 'Pending payment confirmation', '2:28'),
//               _buildFollowUpCard('Ayesha', 'Requested delivery status update', '2:28'),
//               _buildFollowUpCard('Ravi Kumar', 'Needs rescheduling of visit', '2:28'),
//               const SizedBox(height: 24),

//               _buildFormCard(
//                 icon: Icons.person,
//                 label: 'Customer Name',
//                 controller: customerController,
//                 hintText: 'Enter customer name',
//               ),
//               const SizedBox(height: 16),
//               _buildFormCard(
//                 icon: Icons.description,
//                 label: 'Follow-Up Details',
//                 controller: followUpDetailsController,
//                 hintText: 'Enter follow-up details',
//                 maxLines: 5,
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   icon: const Icon(Icons.save),
//                   label: const Text('Save Follow-Up'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryBlue,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: () {
//                     final customer = customerController.text.trim();
//                     final followUpDetails = followUpDetailsController.text.trim();
//                     if (customer.isNotEmpty && followUpDetails.isNotEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Follow-up saved successfully!')),
//                       );
//                       Navigator.pop(context);
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Please fill in all fields')),
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFormCard({
//     required IconData icon,
//     required String label,
//     required TextEditingController controller,
//     required String hintText,
//     int maxLines = 1,
//   }) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: AppColors.primaryBlue),
//                 const SizedBox(width: 8),
//                 Text(
//                   label,
//                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: controller,
//               maxLines: maxLines,
//               decoration: InputDecoration(
//                 hintText: hintText,
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFollowUpCard(String name, String details, String time) {
//     return Card(
//       color: Colors.purple.shade50,
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: const Icon(Icons.person_pin_circle, color: Colors.purple),
//         title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text(details),
//         trailing: Text('Updated: $time', style: const TextStyle(fontSize: 12, color: Colors.grey)),
//       ),
//     );
//   }
// }
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
