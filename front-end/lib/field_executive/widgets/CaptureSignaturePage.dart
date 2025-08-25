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
  final signatureController = TextEditingController(); // Base64 placeholder
  String message = '';
  bool isSubmitting = false;

  Future<void> submitSignature() async {
    final orderId = int.tryParse(orderIdController.text);
    final signature = signatureController.text;

    if (orderId == null || signature.isEmpty) {
      setState(() {
        message = "Please enter a valid Order ID and Signature.";
      });
      return;
    }

    setState(() {
      isSubmitting = true;
      message = '';
    });

    try {
      final response = await http.post(
        Uri.parse("https://yourapi.com/api/orders/signature"), // Replace with your API
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "orderId": orderId,
          "signature": signature,
        }),
      );

      setState(() {
        message = response.statusCode == 200
            ? "✅ Signature submitted successfully!"
            : "❌ Submission failed. (${response.statusCode})";
      });
    } catch (e) {
      setState(() {
        message = "❌ Error submitting signature: $e";
      });
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Order Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildTextField("Order ID", orderIdController, TextInputType.number),
              const SizedBox(height: 16),
              const Text("Signature Placeholder", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Signature Canvas\n(Base64 text manually entered below)",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildTextField("Signature (base64 string)", signatureController, TextInputType.text, maxLines: 4),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isSubmitting ? null : submitSignature,
                  icon: const Icon(Icons.upload),
                  label: isSubmitting
                      ? const Text("Submitting...")
                      : const Text("Submit Signature"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (message.isNotEmpty)
                Text(
                  message,
                  style: TextStyle(
                    color: message.contains("✅") ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
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
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
