import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class DVRPage extends StatefulWidget {
  const DVRPage({super.key});

  @override
  State<DVRPage> createState() => _DVRPageState();
}

class _DVRPageState extends State<DVRPage> {
  final TextEditingController feedbackController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));
  bool loading = false;
  String? message;
  List<dynamic> myDVRs = [];

  // ✅ Submit DVR
  Future<void> submitDVR() async {
    setState(() {
      loading = true;
      message = null;
    });

    try {
      final authService = AuthService();
      final token = await authService.getToken();
      if (token == null) {
        setState(() => message = "⚠️ No token found. Please login again.");
        return;
      }

      final response = await dio.post(
        "/fieldExecutive/dvr",
        data: {
          "feedback": feedbackController.text,
          "location": locationController.text,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        message = "✅ DVR Submitted Successfully!";
      });

      feedbackController.clear();
      locationController.clear();
      await fetchMyDVRs(); // refresh list
    } catch (e) {
      setState(() {
        message = "❌ Error submitting DVR: $e";
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // ✅ Fetch user's DVR list
  Future<void> fetchMyDVRs() async {
    setState(() => loading = true);
    try {
      final authService = AuthService();
      final token = await authService.getToken();
      if (token == null) {
        setState(() => message = "⚠️ No token found. Please login again.");
        return;
      }

      final response = await dio.get(
        "/fieldExecutive/dvr",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        myDVRs = response.data;
        message = null;
      });
    } catch (e) {
      setState(() {
        message = "❌ Failed to load DVRs: $e";
      });
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMyDVRs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Visit Report")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- DVR Input Fields ---
            TextField(
              controller: feedbackController,
              decoration: const InputDecoration(labelText: "Feedback / Notes"),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: "Location"),
            ),
            const SizedBox(height: 20),

            // --- Submit Button ---
            ElevatedButton(
              onPressed: loading ? null : submitDVR,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Submit DVR"),
            ),
            const SizedBox(height: 20),

            if (message != null) Text(message!, style: const TextStyle(color: Colors.red)),

            const Divider(height: 40),
            const Text(
              "My DVR Reports",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // --- DVR List ---
            loading
                ? const Center(child: CircularProgressIndicator())
                : myDVRs.isEmpty
                    ? const Text("No DVR reports yet.")
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: myDVRs.length,
                        itemBuilder: (context, index) {
                          final dvr = myDVRs[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 3,
                            child: ListTile(
                              title: Text(
                                "📍 ${dvr['location'] ?? 'Unknown Location'}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text("Feedback: ${dvr['feedback'] ?? 'N/A'}"),
                                  Text("Status: ${dvr['status'] ?? 'Pending'}"),
                                  if (dvr['executiveName'] != null)
                                    Text("Executive: ${dvr['executiveName']}"),
                                  if (dvr['approvedAt'] != null)
                                    Text("Approved At: ${dvr['approvedAt']}"),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}

