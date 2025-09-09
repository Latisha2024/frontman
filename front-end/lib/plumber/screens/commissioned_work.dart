import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'qr_scanner_widget.dart';

class CommissionedWorkScreen extends StatefulWidget {
  const CommissionedWorkScreen({super.key});

  @override
  State<CommissionedWorkScreen> createState() => _CommissionedWorkScreenState();
}

class _CommissionedWorkScreenState extends State<CommissionedWorkScreen> {
  File? _image;
  String? _location;
  String? _qrCode;
  bool _isLoadingLocation = false;

  final ImagePicker _picker = ImagePicker();
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://frontman-backend-2.onrender.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
  ));

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? prefs.getString('jwt_token');
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> getLocation() async {
    setState(() => _isLoadingLocation = true);

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❗ Location permission is required')),
        );
        setState(() => _isLoadingLocation = false);
        return;
      }
    }

    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _location = '${pos.latitude}, ${pos.longitude}';
      _isLoadingLocation = false;
    });
  }

  Future<void> scanQRCode(BuildContext context) async {
    final scannedCode = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const QRCodeCommissionedWork(),
      ),
    );

    if (scannedCode != null) {
      setState(() => _qrCode = scannedCode);
    }
  }

  String _formatQrCode(String code) {
    try {
      final jsonObj = jsonDecode(code);
      if (jsonObj is Map<String, dynamic>) {
        return jsonObj.entries
            .map((e) => "${_capitalize(e.key)}: ${e.value}")
            .join("\n");
      }
    } catch (_) {}
    return code;
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  Future<void> submitToAdmin() async {
    final token = await _getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❗ Authentication token is required')),
      );
      return;
    }

    if (_image == null || _location == null || _qrCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("❗ Please complete all steps: image, location, QR code"),
        ),
      );
      return;
    }

    try {
      final lat = double.parse(_location!.split(",")[0].trim());
      final lng = double.parse(_location!.split(",")[1].trim());

      final formData = FormData.fromMap({
        "latitude": lat,
        "longitude": lng,
        "qrCode": _qrCode!,
        "qrImage": await MultipartFile.fromFile(
          _image!.path,
          filename: "qr_selfie.jpg",
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      final response = await _dio.post(
        "/user/commissioned-work",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully submitted")),
        );
        setState(() {
          _image = null;
          _location = null;
          _qrCode = null;
        });
      } else {
        final msg = response.data['message'] ?? "Unknown error from server";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: $msg")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Submission failed: $e")),
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
            if (_isLoadingLocation)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: CircularProgressIndicator(),
              )
            else if (_location != null)
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
              child: const Text(
                "Submit to Admin",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
