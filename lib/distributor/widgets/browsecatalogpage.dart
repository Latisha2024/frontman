// browse_catalog_page.dart
import 'package:flutter/material.dart';
import 'package:role_based_app/constants/colors.dart';

class BrowseCatalogPage extends StatelessWidget {
  const BrowseCatalogPage({super.key});

  final List<Map<String, String>> demoProducts = const [
    {"id": "1", "name": "Water Tank", "desc": "1000L durable plastic tank"},
    {"id": "2", "name": "Solar Panel", "desc": "150W monocrystalline solar panel"},
    {"id": "3", "name": "Pipe Set", "desc": "PVC pipe set for plumbing"},
    {"id": "4", "name": "Motor Pump", "desc": "1.5HP water motor pump"},
    {"id": "5", "name": "Garden Hose", "desc": "25m flexible hose with nozzle"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Browse Product Catalog"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Available Products:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: demoProducts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final product = demoProducts[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        child: Text(product["id"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      title: Text(product["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(product["desc"]!),
                      trailing: Icon(Icons.shopping_cart_outlined, color: AppColors.primary),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
