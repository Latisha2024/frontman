import 'package:flutter/material.dart';

class UpdateStockPage extends StatefulWidget {
  const UpdateStockPage({super.key});

  @override
  State<UpdateStockPage> createState() => _UpdateStockPageState();
}

class _UpdateStockPageState extends State<UpdateStockPage> {
  final List<String> categories = ["Electronics", "Groceries", "Clothing"];
  final Map<String, List<Map<String, dynamic>>> stock = {
    "Electronics": [
      {"name": "Laptop", "quantity": 10},
      {"name": "Mobile", "quantity": 25}
    ],
    "Groceries": [
      {"name": "Rice", "quantity": 50},
      {"name": "Sugar", "quantity": 30}
    ],
    "Clothing": [
      {"name": "T-shirt", "quantity": 40},
      {"name": "Jeans", "quantity": 15}
    ],
  };

  String? selectedCategory;

  void addCategory() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Category"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter category name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String newCat = controller.text.trim();
              if (newCat.isNotEmpty && !categories.contains(newCat)) {
                setState(() {
                  categories.add(newCat);
                  stock[newCat] = [];
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void renameCategory(String oldCategory) {
    TextEditingController controller =
        TextEditingController(text: oldCategory);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Rename Category"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter new category name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String newCat = controller.text.trim();
              if (newCat.isNotEmpty &&
                  !categories.contains(newCat) &&
                  newCat != oldCategory) {
                setState(() {
                  int index = categories.indexOf(oldCategory);
                  categories[index] = newCat;
                  stock[newCat] = stock.remove(oldCategory)!;
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Rename"),
          ),
        ],
      ),
    );
  }

  void UpdateStockPageQuantity(String category, int index, int change) {
    setState(() {
      stock[category]![index]["quantity"] += change;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Stock"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addCategory,
          )
        ],
      ),
      body: Row(
        children: [
          // Sidebar for categories
          Container(
            width: 150,
            color: Colors.grey.shade200,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String category = categories[index];
                return ListTile(
                  title: Text(category),
                  selected: selectedCategory == category,
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () => renameCategory(category),
                  ),
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                );
              },
            ),
          ),
          // Stock items
          Expanded(
            child: selectedCategory == null
                ? const Center(child: Text("Select a category"))
                : ListView.builder(
                    itemCount: stock[selectedCategory]!.length,
                    itemBuilder: (context, index) {
                      var item = stock[selectedCategory]![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: ListTile(
                          title: Text(item["name"]),
                          subtitle:
                              Text("Quantity: ${item["quantity"].toString()}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, color: Colors.red),
                                onPressed: () => UpdateStockPageQuantity(
                                    selectedCategory!, index, -1),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.green),
                                onPressed: () => UpdateStockPageQuantity(
                                    selectedCategory!, index, 1),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
