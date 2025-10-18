// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../../constants/colors.dart'; // Ensure this has AppColors.primaryBlue

// class CaptureSignaturePage extends StatefulWidget {
//   const CaptureSignaturePage({super.key});

//   @override
//   State<CaptureSignaturePage> createState() => _CaptureSignaturePageState();
// }

// class _CaptureSignaturePageState extends State<CaptureSignaturePage> {
//   final orderIdController = TextEditingController();
//   final signatureController = TextEditingController(); // Base64 placeholder
//   String message = '';
//   bool isSubmitting = false;

//   Future<void> submitSignature() async {
//     final orderId = int.tryParse(orderIdController.text);
//     final signature = signatureController.text;

//     if (orderId == null || signature.isEmpty) {
//       setState(() {
//         message = "Please enter a valid Order ID and Signature.";
//       });
//       return;
//     }

//     setState(() {
//       isSubmitting = true;
//       message = '';
//     });

//     try {
//       final response = await http.post(
//         Uri.parse("https://yourapi.com/api/orders/signature"), // Replace with your API
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "orderId": orderId,
//           "signature": signature,
//         }),
//       );

//       setState(() {
//         message = response.statusCode == 200
//             ? "✅ Signature submitted successfully!"
//             : "❌ Submission failed. (${response.statusCode})";
//       });
//     } catch (e) {
//       setState(() {
//         message = "❌ Error submitting signature: $e";
//       });
//     } finally {
//       setState(() {
//         isSubmitting = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Capture Signature"),
//         backgroundColor: AppColors.primaryBlue,
//         foregroundColor: Colors.white,
//       ),
//       body: Container(
//         color: Colors.grey.shade100,
//         padding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text("Order Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 12),
//               _buildTextField("Order ID", orderIdController, TextInputType.number),
//               const SizedBox(height: 16),
//               const Text("Signature Placeholder", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//               const SizedBox(height: 8),
//               Container(
//                 height: 180,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(color: Colors.grey.shade400),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     "Signature Canvas\n(Base64 text manually entered below)",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               _buildTextField("Signature (base64 string)", signatureController, TextInputType.text, maxLines: 4),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: isSubmitting ? null : submitSignature,
//                   icon: const Icon(Icons.upload),
//                   label: isSubmitting
//                       ? const Text("Submitting...")
//                       : const Text("Submit Signature"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryBlue,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               if (message.isNotEmpty)
//                 Text(
//                   message,
//                   style: TextStyle(
//                     color: message.contains("✅") ? Colors.green : Colors.red,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller, TextInputType inputType,
//       {int maxLines = 1}) {
//     return TextField(
//       controller: controller,
//       keyboardType: inputType,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//         filled: true,
//         fillColor: Colors.white,
//       ),
//     );
//   }
// }
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class CaptureSignaturePage extends StatefulWidget {
  const CaptureSignaturePage({super.key});

  @override
  State<CaptureSignaturePage> createState() => _CaptureSignaturePageState();
}

class _CaptureSignaturePageState extends State<CaptureSignaturePage> {
  final SignatureController _controller = SignatureController(penStrokeWidth: 3);
  final TextEditingController contextController = TextEditingController();
  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));
  bool loading = false;
  String? message;

  Future<void> uploadSignature() async {
    final Uint8List? data = await _controller.toPngBytes();
    if (data == null || data.isEmpty) {
      setState(() => message = "⚠️ Please draw your signature first!");
      return;
    }

    setState(() => loading = true);

    try {
      final authService = AuthService();
      final token = await authService.getToken();

      final response = await dio.post(
        '/fieldExecutive/operations/signature',
        data: {
          "signatureData": data.toString(),
          "context": contextController.text.trim(),
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() => message = "✅ Signature uploaded successfully!");
      } else {
        setState(() => message = "⚠️ Upload failed (${response.statusCode})");
      }
    } catch (e) {
      setState(() => message = "❌ Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  void clearSignature() {
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Capture Signature")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Signature(
              controller: _controller,
              height: 200,
              backgroundColor: Colors.grey[200]!,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: clearSignature,
                  icon: const Icon(Icons.clear),
                  label: const Text("Clear"),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: loading ? null : uploadSignature,
                  icon: const Icon(Icons.upload),
                  label: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Upload"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: contextController,
              decoration:
                  const InputDecoration(labelText: "Context (e.g. Order Confirmation)"),
            ),
            if (message != null) ...[
              const SizedBox(height: 20),
              Text(
                message!,
                style: TextStyle(
                    color: message!.contains("✅") ? Colors.green : Colors.red),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

