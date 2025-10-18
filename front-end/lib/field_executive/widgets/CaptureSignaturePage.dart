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

