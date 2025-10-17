// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../../constants/colors.dart';

// class SyncOfflinePage extends StatefulWidget {
//   const SyncOfflinePage({super.key});

//   @override
//   State<SyncOfflinePage> createState() => _SyncOfflinePageState();
// }

// class _SyncOfflinePageState extends State<SyncOfflinePage> {
//   final executiveIdController = TextEditingController(text: '101');
//   final offlineDataController = TextEditingController(
//     text: jsonEncode([
//       {
//         "customerId": 123,
//         "visitDate": "2025-08-04",
//         "feedback": "Interested in new offers",
//         "location": {"lat": 12.9716, "lng": 77.5946}
//       },
//       {
//         "customerId": 456,
//         "visitDate": "2025-08-03",
//         "feedback": "Requested follow-up next week",
//         "location": {"lat": 19.0760, "lng": 72.8777}
//       }
//     ]),
//   );

//   String message = '';
//   Color messageColor = Colors.green;

//   Future<void> syncData() async {
//     try {
//       final parsedId = int.tryParse(executiveIdController.text);
//       final parsedData = jsonDecode(offlineDataController.text);

//       if (parsedId == null) {
//         setState(() {
//           message = "❗ Invalid Executive ID.";
//           messageColor = Colors.red;
//         });
//         return;
//       }

//       final response = await http.post(
//         Uri.parse("https://yourapi.com/api/field-executive/sync-offline"),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "executiveId": parsedId,
//           "data": parsedData,
//         }),
//       );

//       setState(() {
//         if (response.statusCode == 200) {
//           message = "✅ Data synced successfully!";
//           messageColor = Colors.green;
//         } else {
//           message = "❌ Sync failed. Status: ${response.statusCode}";
//           messageColor = Colors.red;
//         }
//       });
//     } catch (e) {
//       setState(() {
//         message = "⚠️ Error: ${e.toString()}";
//         messageColor = Colors.red;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           "Sync Offline Data",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: AppColors.textLight,
//           ),
//         ),
//         backgroundColor: AppColors.primary,
//         iconTheme: const IconThemeData(color: AppColors.textLight),
//         elevation: 2,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Card(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           elevation: 4,
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: ListView(
//               children: [
//                 const Text(
//                   "Offline Data Sync",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.textColor,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: executiveIdController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: "Executive ID",
//                     hintText: "Enter Executive ID (e.g., 101)",
//                     labelStyle: const TextStyle(color: AppColors.textSecondary),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                     filled: true,
//                     fillColor: AppColors.inputFill,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: offlineDataController,
//                   maxLines: 10,
//                   decoration: InputDecoration(
//                     labelText: "Offline Data (JSON List/Map)",
//                     hintText: "Paste JSON-formatted offline data here",
//                     labelStyle: const TextStyle(color: AppColors.textSecondary),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                     filled: true,
//                     fillColor: AppColors.inputFill,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Center(
//                   child: ElevatedButton.icon(
//                     onPressed: syncData,
//                     icon: const Icon(Icons.sync, color: AppColors.textLight),
//                     label: const Text(
//                       "Sync Now",
//                       style: TextStyle(color: AppColors.textLight),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 if (message.isNotEmpty)
//                   Center(
//                     child: Text(
//                       message,
//                       style: TextStyle(
//                         color: messageColor,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class SyncOfflineDataPage extends StatefulWidget {
  const SyncOfflineDataPage({super.key});

  @override
  State<SyncOfflineDataPage> createState() => _SyncOfflineDataPageState();
}

class _SyncOfflineDataPageState extends State<SyncOfflineDataPage> {
  final Dio dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));
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
                    color:
                        message!.contains("✅") ? Colors.green : Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
