import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart'; // <-- For Clipboard
import 'package:role_based_app/distributor/screens/distributorsUI.dart';
import '../../authpage/pages/auth_services.dart';
import '../../constants/colors.dart';

class GetCatalogPage extends StatefulWidget {
  const GetCatalogPage({super.key});

  @override
  State<GetCatalogPage> createState() => _GetCatalogPageState();
}

class _GetCatalogPageState extends State<GetCatalogPage> {
  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));

  List<Map<String, dynamic>> catalogItems = [];
  bool loading = false;
  String? message;

  @override
  void initState() {
    super.initState();
    fetchCatalog(); // Auto-fetch on page load
  }

  Future<void> fetchCatalog() async {
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

      final response = await dio.get(
        "/distributor/catalog",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      List data = response.data;
      setState(() {
        catalogItems = data.map((item) => item as Map<String, dynamic>).toList();
        message = "✅ Catalog fetched successfully";
      });
    } catch (e) {
      setState(() {
        message = "❌ Failed to fetch catalog: $e";
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("📋 Product ID $text copied to clipboard"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget buildCatalogList() {
    if (loading) return const Center(child: CircularProgressIndicator());

    if (catalogItems.isEmpty) {
      return Center(
        child: Text(
          message ?? "🚫 No catalog items found.",
          style: const TextStyle(fontSize: 16, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      itemCount: catalogItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = catalogItems[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "${item['title']}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => copyToClipboard(item['id'].toString()),
                  child: Row(
                    children: [
                      const Icon(Icons.copy, size: 16, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(
                        "📦 Product ID: ${item['id']}",
                        style: const TextStyle(
                          color: Colors.black87,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                Text("💰 Price: ₹${item['price'] ?? 'N/A'}", style: const TextStyle(color: Colors.black87)),
                Text("📊 Stock: ${item['stock'] ?? 'N/A'}", style: const TextStyle(color: Colors.black87)),
                if (item['description'] != null && item['description'].toString().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text("📝 ${item['description']}", style: const TextStyle(color: Colors.black54)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Product Catalog", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, size: 26),
            tooltip: "Back to Dashboard",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DistributorHomePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (message != null)
              Card(
                color: message!.startsWith("✅") ? Colors.green[50] : Colors.red[50],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        message!.startsWith("✅") ? Icons.check_circle : Icons.error,
                        color: message!.startsWith("✅") ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          message!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: message!.startsWith("✅") ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(child: buildCatalogList()),
          ],
        ),
      ),
    );
  }
}
