// get_catalog_page.dart
import 'package:flutter/material.dart';
import 'package:role_based_app/constants/colors.dart';

class GetCatalogPage extends StatefulWidget {
  const GetCatalogPage({super.key});

  @override
  State<GetCatalogPage> createState() => _GetCatalogPageState();
}

class _GetCatalogPageState extends State<GetCatalogPage> {
  List<String> catalogItems = [];
  bool fetched = false;

  void fetchCatalog() {
    setState(() {
      catalogItems = [
        'Product ID: 1 - Water Tank',
        'Product ID: 2 - Solar Panel',
        'Product ID: 3 - Pipe Set',
      ];
      fetched = true;
    });
  }

  Widget buildCatalogList() {
    if (!fetched) {
      return const Center(
        child: Text(
          "📦 Tap the button above to fetch product catalog.",
          style: TextStyle(fontSize: 16, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (catalogItems.isEmpty) {
      return const Center(
        child: Text(
          "🚫 No catalog items found.",
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      );
    }

    return ListView.builder(
      itemCount: catalogItems.length,
      itemBuilder: (context, index) => Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          leading: const Icon(Icons.shopping_bag_outlined),
          title: Text(catalogItems[index]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Get Product Catalog"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: fetchCatalog,
                icon: const Icon(Icons.download),
                label: const Text("Fetch Catalog"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: buildCatalogList()),
          ],
        ),
      ),
    );
  }
}
