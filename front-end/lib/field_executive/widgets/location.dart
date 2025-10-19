// update_location_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class UpdateLocationPage extends StatefulWidget {
  const UpdateLocationPage({super.key});

  @override
  State<UpdateLocationPage> createState() => _UpdateLocationPageState();
}

class _UpdateLocationPageState extends State<UpdateLocationPage> {
  final dio = Dio(BaseOptions(baseUrl: "https://frontman-1.onrender.com"));
  bool tracking = false;
  String? message;
  Timer? timer;

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  // Future<void> _checkPermission() async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //   }
  //   if (permission == LocationPermission.deniedForever ||
  //       permission == LocationPermission.denied) {
  //     setState(() => message = "Location permission denied");
  //     return;
  //   }
  // }

  Future<void> _sendLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final token = await _getToken();
      if (token == null) {
        setState(() => message = "⚠️ Please login again");
        return;
      }

      await dio.post(
        "/fieldExecutive/location",
        data: {
          "latitude": position.latitude,
          "longitude": position.longitude,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() => message =
          "📍 Location sent: (${position.latitude}, ${position.longitude})");
    } catch (e) {
      setState(() => message = "❌ Failed to send location: $e");
    }
  }

  void _startTracking() {
    //_checkPermission();
    timer = Timer.periodic(const Duration(minutes: 2), (_) => _sendLocation());
    setState(() => tracking = true);
  }

  void _stopTracking() {
    timer?.cancel();
    setState(() => tracking = false);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Field Executive Location Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (message != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(message!,
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: tracking ? null : _sendLocation,
              child: const Text("📍 Send Current Location Now"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: tracking ? null : _startTracking,
              child: const Text("▶️ Start Automatic Tracking"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: tracking ? _stopTracking : null,
              child: const Text("⏹️ Stop Tracking"),
            ),
          ],
        ),
      ),
    );
  }
}

