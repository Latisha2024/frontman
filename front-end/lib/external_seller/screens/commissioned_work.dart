import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';

import 'qr_scanner_widget.dart'; // ✅ Updated import for MobileScanner

class CommissionedWorkScreen extends StatefulWidget {
  const CommissionedWorkScreen({super.key});

  @override
  State<CommissionedWorkScreen> createState() => _CommissionedWorkScreenState();
}

class _CommissionedWorkScreenState extends State<CommissionedWorkScreen> {
  File? _image;
  String? _location;
  String? _qrCode;

  final ImagePicker _picker = ImagePicker();
  final Dio _dio = Dio();

  // ✅ Pick image from camera
  Future<void> pickImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  // ✅ Get location with permission check
  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❗ Location permission is required')),
        );
        return;
      }
    }

    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() => _location = '${pos.latitude}, ${pos.longitude}');
  }

  // ✅ Scan QR code
  void scanQRCode(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerWidget(onScan: (code) {
          setState(() => _qrCode = code);
        }),
      ),
    );
  }

  // ✅ Format QR content neatly if JSON
  String _formatQrCode(String code) {
    try {
      final jsonObj = jsonDecode(code);
      if (jsonObj is Map<String, dynamic>) {
        final formatted = jsonObj.entries
            .map((e) => "${_capitalize(e.key)}: ${e.value}")
            .join("\n");
        return "✅ QR Code:\n$formatted";
      }
    } catch (_) {
      // Not a JSON string, just return plain
    }
    return "✅ QR Code: $code";
  }

  // Helper to capitalize first letter
  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  // ✅ Submit button logic (with Dio)
  Future<void> submitToAdmin() async {
    if (_image != null && _location != null && _qrCode != null) {
      try {
        final lat = double.parse(_location!.split(",").first.trim());
        final lng = double.parse(_location!.split(",").last.trim());

        final formData = FormData.fromMap({
          "latitude": lat,
          "longitude": lng,
          "qrCode": _qrCode,
          "qrImage": await MultipartFile.fromFile(_image!.path,
              filename: "qr_selfie.jpg"),
        });

        // ✅ Assumption: Backend endpoint exists at /commissionedWork
        final response = await _dio.post(
          "https://your-backend.com/api/commissionedWork",
          data: formData,
          options: Options(headers: {"Content-Type": "multipart/form-data"}),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Submitted to Admin")),
          );

          setState(() {
            _image = null;
            _location = null;
            _qrCode = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ Failed: ${response.data}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error submitting: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❗ Please complete all 3 steps before submitting"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Commissioned Work')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Capture Selfie with Product"),
            ),
            if (_image != null)
              Container(
                margin: const EdgeInsets.only(top: 16),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: getLocation,
              icon: const Icon(Icons.location_on),
              label: const Text("Get Current Location"),
            ),
            if (_location != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "📍 $_location",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => scanQRCode(context),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Scan Product QR Code"),
            ),
            if (_qrCode != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _formatQrCode(_qrCode!),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: submitToAdmin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size.fromHeight(50),
              ),
              child:
                  const Text("Submit to Admin", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
