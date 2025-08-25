import 'package:flutter/material.dart';

class ManageStockPage extends StatefulWidget {
  const ManageStockPage({Key? key}) : super(key: key);

  @override
  State<ManageStockPage> createState() => _ManageStockPageState();
}

class _ManageStockPageState extends State<ManageStockPage> {
  // Sample data
  Map<String, List<Map<String, dynamic>>> stockData = {
    "Electronics": [
      {"name": "Laptop", "qty": 10},
      {"name": "Smartphone", "qty": 25}
    ],
    "Groceries": [
      {"name": "Rice Bag", "qty": 50},
      {"name": "Sugar", "qty": 30}
    ],
  };

  void _addCategory() {
    // TODO: Implement add category functionality
  }

  void _renameCategory(String oldName) {
    // TODO: Implement rename category functionality
  }

  void _addItem(String category) {
    // TODO: Implement add item functionality
  }

  void _updateStock(String category, String item) {
    // TODO: Implement update stock functionality
  }

  void _deleteItem(String category, String item) {
    setState(() {
      stockData[category]?.removeWhere((i) => i["name"] == item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Stock"),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Add Category",
            onPressed: _addCategory,
          ),
        ],
      ),
      body: ListView(
        children: stockData.keys.map((category) {
          return Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: ExpansionTile(
              title: Text(
                category,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'rename') {
                    _renameCategory(category);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'rename',
                    child: Text('Rename Category'),
                  ),
                ],
              ),
              children: [
                ...stockData[category]!.map((item) {
                  return ListTile(
                    title: Text(item["name"]),
                    subtitle: Text("Quantity: ${item["qty"]}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _updateStock(category, item["name"]),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteItem(category, item["name"]),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Add Item"),
                    onPressed: () => _addItem(category),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
