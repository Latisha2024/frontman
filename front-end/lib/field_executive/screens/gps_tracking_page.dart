import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:role_based_app/authpage/config/app_colors.dart';
import '../../constants/colors.dart';

// Import the separate navigation pages
import '../widgets/status_page.dart';
import '../widgets/tasks_page.dart';
import '../widgets/chat_page.dart';
import '../widgets/camera_page.dart';

class GpsTrackingPage extends StatefulWidget {
  const GpsTrackingPage({super.key});

  @override
  State<GpsTrackingPage> createState() => _GpsTrackingPageState();
}

class _GpsTrackingPageState extends State<GpsTrackingPage> {
  bool isGpsEnabled = false;
  String trackingStatus = "Tracking is stopped";
  String? startedAt;
  String? currentLocation;
  final int userId = 101;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => currentLocation = "Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => currentLocation = "Location permissions are denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => currentLocation = "Location permissions are permanently denied.");
      return;
    }

    final Position pos = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = "Lat: ${pos.latitude}, Lon: ${pos.longitude}";
    });
  }

  Future<void> enableGps() async {
    final response = await http.post(
      Uri.parse('https://yourapi.com/api/field-executive/gps/enable'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"userId": userId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == "success" && data["gps"] == true) {
        setState(() => isGpsEnabled = true);
        _getCurrentLocation();
      }
    }
  }

  Future<void> startLiveTracking() async {
    final response = await http.post(
      Uri.parse('https://yourapi.com/api/field-executive/gps/start-tracking'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"userId": userId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == "tracking") {
        setState(() {
          trackingStatus = "Tracking started at: ${data["startedAt"]}";
          startedAt = data["startedAt"];
        });
        _getCurrentLocation();
      }
    }
  }

  void navigateTo(String title) {
    Widget page;
    switch (title) {
      case "Status":
        page = const StatusPage();
        break;
      case "Tasks":
        page = const TasksPage();
        break;
      case "Chat":
        page = const ChatPage();
        break;
      case "Camera":
        page = const CameraPage();
        break;
      default:
        page = Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Center(child: Text("Page not found")),
        );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: AppBar(
        backgroundColor: AuthColors.textDark,
        title: const Text('Tracking', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.power_settings_new, color: AuthColors.primaryBlue, size: 32),
              title: const Text("Start tracking"),
              subtitle: Text(trackingStatus),
              trailing: Switch(
                value: isGpsEnabled,
                onChanged: (val) {
                  if (!isGpsEnabled) enableGps();
                },
              ),
              onTap: startLiveTracking,
            ),
          ),
          if (currentLocation != null) ...[
            const SizedBox(height: 8),
            Text("Current Location: $currentLocation", style: const TextStyle(fontSize: 14))
          ],
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.location_on, color: AuthColors.primaryBlue, size: 30),
              title: const Text("Status"),
              subtitle: const Text("View status and latest location data"),
              onTap: () => navigateTo("Status_page"),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.task_alt, color: AuthColors.primaryBlue, size: 30),
              title: const Text("Tasks"),
              subtitle: const Text("Perform tasks"),
              onTap: () => navigateTo("Tasks_page"),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.chat_bubble, color: AuthColors.primaryBlue, size: 30),
              title: const Text("Chat"),
              subtitle: const Text("Communicate with main account"),
              onTap: () => navigateTo("Chat_page"),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.camera_alt, color: AuthColors.primaryBlue, size: 30),
              title: const Text("Camera"),
              subtitle: const Text("Send photo with location"),
              onTap: () => navigateTo("Camera_page"),
            ),
          ),
        ],
      ),
    );
  }
}
