import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class SyncOfflineDataPage extends StatefulWidget {
  const SyncOfflineDataPage({super.key});

  @override
  State<SyncOfflineDataPage> createState() => _SyncOfflineDataPageState();
}

class _SyncOfflineDataPageState extends State<SyncOfflineDataPage> {
  final Dio dio = Dio(BaseOptions(baseUrl: "https://frontman-1.onrender.com"));
  List<Map<String, dynamic>> offlineData = [];
  bool loading = false;
  String? message;

  @override
  void initState() {
    super.initState();
    fetchOfflineData();
  }

  // Fetch offline data from backend
  Future<void> fetchOfflineData() async {
    setState(() => loading = true);
    try {
      final token = await AuthService().getToken();
      final response = await dio.get(
        '/fieldExecutive/operations/sync',
        queryParameters: {'synced': false},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          offlineData = List<Map<String, dynamic>>.from(response.data);
        });
      } else {
        setState(() => message = "⚠️ Failed to fetch offline data");
      }
    } catch (e) {
      setState(() => message = "❌ Error fetching data: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  // Sync offline data to server
  Future<void> syncOfflineData() async {
    if (offlineData.isEmpty) {
      setState(() => message = "No offline data to sync.");
      return;
    }

    setState(() {
      loading = true;
      message = null;
    });

    try {
      final token = await AuthService().getToken();
      final response = await dio.post(
        '/fieldExecutive/operations/sync',
        data: {'offlineData': offlineData},
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Cache-Control': 'no-cache',
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          message = "✅ Offline data synced successfully!";
          offlineData = [];
        });
      } else {
        setState(() => message =
            "⚠️ Sync failed (${response.statusCode}): ${response.data}");
      }
    } catch (e) {
      setState(() => message = "❌ Error during sync: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sync Offline Data")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: loading ? null : syncOfflineData,
              icon: const Icon(Icons.sync),
              label: loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ))
                  : const Text("Sync All Offline Data"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : offlineData.isEmpty
                      ? const Center(child: Text("No offline data"))
                      : ListView.builder(
                          itemCount: offlineData.length,
                          itemBuilder: (context, index) {
                            final item = offlineData[index];
                            return Card(
                              child: ListTile(
                                title: Text(item['dataType'] ?? 'Unknown'),
                                subtitle: Text(
                                  item['data'] != null
                                      ? item['data'].toString()
                                      : '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          },
                        ),
            ),
            if (message != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  message!,
                  style: TextStyle(
                    color: message!.contains("✅") ? Colors.green : Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
