import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'qr_scanner_widget.dart'; // ✅ Correct import for QR scanner

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

  // ✅ Pick Image from Camera
  Future<void> pickImage() async {
    final pickedFile =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  // ✅ Get Location with Permission
  Future<void> getLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required')),
      );
      return;
    }

    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() => _location = '${pos.latitude}, ${pos.longitude}');
  }

  // ✅ Launch QR Scanner
  void scanQRCode(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRViewExample(onScan: (code) {
          setState(() => _qrCode = code);
          Navigator.pop(context);
        }),
      ),
    );
  }

  // ✅ Submit Form (Currently mock)
  void submitToAdmin() {
    if (_image != null && _location != null && _qrCode != null) {
      // TODO: Replace with API call to send data to backend
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
        const SnackBar(
            content: Text("❗ Please complete all 3 steps before submitting")),
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
                child: Image.file(_image!, fit: BoxFit.cover),
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
                child: Text("📍 $_location",
                    style: const TextStyle(fontSize: 16)),
              ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => scanQRCode(context),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Scan Product QR Code"),
            ),
            if (_qrCode != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text("✅ QR Code: $_qrCode",
                    style: const TextStyle(fontSize: 16)),
              ),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: submitToAdmin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Submit to Admin",
                  style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
