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

  void fetchCatalog() {
    setState(() {
      catalogItems = [
        'Product ID: 1 - Water Tank',
        'Product ID: 2 - Solar Panel',
        'Product ID: 3 - Pipe Set',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Product Catalog"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: fetchCatalog,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text("Fetch Catalog"),
            ),
            const SizedBox(height: 16),
            if (catalogItems.isNotEmpty)
              const Text("Catalog Items:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: catalogItems.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.shopping_bag),
                  title: Text(catalogItems[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
