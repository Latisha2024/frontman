import 'package:flutter/material.dart';
import '../../constants/colors.dart'; // adjust import path as needed

class SubmitDvrPage extends StatefulWidget {
  const SubmitDvrPage({super.key});

  @override
  State<SubmitDvrPage> createState() => _SubmitDvrPageState();
}

class _SubmitDvrPageState extends State<SubmitDvrPage> {
  final feedbackController = TextEditingController();
  final locationController = TextEditingController();
  final executiveId = "101";

  void _submit() {
    String summary = '''
Executive ID: $executiveId
Location: ${locationController.text}
Feedback: ${feedbackController.text}
''';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "DVR Submitted",
          style: TextStyle(color: AppColors.primaryBlue),
        ),
        content: Text(
          summary,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: AppColors.primaryBlue)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Submit DVR",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
        ),
        backgroundColor: AppColors.primaryBlue,
        elevation: 2,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Daily Visit Report",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Executive ID: $executiveId",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: "Current Location",
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: feedbackController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Customer Feedback",
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.send, color: AppColors.textLight),
                    label: const Text(
                      "Submit DVR",
                      style: TextStyle(color: AppColors.textLight),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
