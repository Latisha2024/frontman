import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/colors.dart'; // Ensure this has AppColors.primaryBlue

class CaptureSignaturePage extends StatefulWidget {
  const CaptureSignaturePage({super.key});

  @override
  State<CaptureSignaturePage> createState() => _CaptureSignaturePageState();
}

class _CaptureSignaturePageState extends State<CaptureSignaturePage> {
  final orderIdController = TextEditingController();
  final signatureController = TextEditingController(); // For base64 signature
  String message = '';

  Future<void> submitSignature() async {
    final response = await http.post(
      Uri.parse("https://yourapi.com/api/orders/signature"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "orderId": int.tryParse(orderIdController.text),
        "signature": signatureController.text,
      }),
    );

    setState(() {
      message = response.statusCode == 200 ? "Signature submitted successfully!" : "Submission failed. Try again.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Capture Signature"),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Order Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTextField("Order ID", orderIdController, TextInputType.number),
            const SizedBox(height: 12),
            _buildTextField("Signature (base64 encoded)", signatureController, TextInputType.text, maxLines: 3),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: submitSignature,
                icon: const Icon(Icons.edit),
                label: const Text("Submit Signature"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (message.isNotEmpty)
              Text(
                message,
                style: TextStyle(
                  color: message.contains("success") ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType inputType,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
