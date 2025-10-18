import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';
import '../../constants/colors.dart';

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({super.key});

  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen>
    with SingleTickerProviderStateMixin {
  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));

  bool loading = false;
  String? message;
  List<dynamic> stockList = [];

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockQuantityController = TextEditingController();
  final TextEditingController warrantyPeriodController = TextEditingController();
  final TextEditingController categoryIdController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController stockItemIdController = TextEditingController();
  final TextEditingController updateStatusController = TextEditingController();

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  Future<void> _getAssignedStock() async {
    setState(() {
      loading = true;
      message = null;
      stockList = [];
    });
    try {
      final token = await _getToken();
      if (token == null) {
        setState(() {
          message = "⚠️ Please login again.";
          loading = false;
        });
        return;
      }
      final response = await dio.get(
        "/distributor/stock",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      setState(() {
        stockList = response.data;
        message = "📦 ${stockList.length} stock items found.";
      });
    } catch (e) {
      setState(() => message = "❌ Error fetching stock.");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _addStockItem() async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final token = await _getToken();
      if (token == null) {
        setState(() => message = "⚠️ Please login again.");
        return;
      }
      await dio.post(
        "/distributor/stock/items",
        data: {
          "name": nameController.text,
          "price": double.tryParse(priceController.text) ?? 0,
          "stockQuantity": int.tryParse(stockQuantityController.text) ?? 0,
          "warrantyPeriodInMonths":
              int.tryParse(warrantyPeriodController.text) ?? 0,
          "categoryId": categoryIdController.text.isNotEmpty
              ? categoryIdController.text
              : null,
          "location": locationController.text.isNotEmpty
              ? locationController.text
              : null,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      setState(() {
        message = "✅ Stock item added successfully!";
        nameController.clear();
        priceController.clear();
        stockQuantityController.clear();
        warrantyPeriodController.clear();
        categoryIdController.clear();
        locationController.clear();
      });
      _getAssignedStock();
    } catch (e) {
      setState(() => message = "❌ Error adding stock item.");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _updateStockStatus() async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final token = await _getToken();
      if (token == null) {
        setState(() => message = "⚠️ Please login again.");
        return;
      }
      await dio.put(
        "/distributor/stock/${stockItemIdController.text}",
        data: {"status": updateStatusController.text},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      setState(() {
        message = "🔄 Stock status updated successfully!";
        updateStatusController.clear();
        stockItemIdController.clear();
      });
      _getAssignedStock();
    } catch (e) {
      setState(() => message = "❌ Error updating status.");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _removeStockItem() async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final token = await _getToken();
      if (token == null) {
        setState(() => message = "⚠️ Please login again.");
        return;
      }
      await dio.delete(
        "/distributor/stock/items/${stockItemIdController.text}",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      setState(() {
        message = "🗑️ Stock item deleted successfully!";
        stockItemIdController.clear();
      });
      _getAssignedStock();
    } catch (e) {
      setState(() => message = "❌ Error removing stock item.");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _getAssignedStock();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundGray,
        appBar: AppBar(
          title: const Text("Stock Management"),
          backgroundColor: AppColors.primaryBlue,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _getAssignedStock,
            )
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Manage Stock", icon: Icon(Icons.inventory)),
              Tab(text: "Add Stock", icon: Icon(Icons.add_box)),
            ],
          ),
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildManageStockTab(),
                  _buildAddStockTab(),
                ],
              ),
      ),
    );
  }

  Widget _buildManageStockTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (message != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(message!,
                style: const TextStyle(fontSize: 16, color: Colors.red)),
          ),
        Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                    controller: stockItemIdController,
                    decoration: const InputDecoration(labelText: "Stock Item ID")),
                TextField(
                    controller: updateStatusController,
                    decoration: const InputDecoration(
                        labelText: "New Status (e.g. Sold, Dispatched)")),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _updateStockStatus,
                        icon: const Icon(Icons.update),
                        label: const Text("Update Status"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _removeStockItem,
                        icon: const Icon(Icons.delete),
                        label: const Text("Remove Item"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (stockList.isEmpty)
          const Center(child: Text("No stock items found"))
        else
          ...stockList.map((stock) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(stock['product']?['name'] ?? 'No Product Name'),
                subtitle: Text(
                  "ID: ${stock['id']}\n"
                  "Status: ${stock['status']}\n"
                  "Location: ${stock['location']}\n"
                  "Price: \$${stock['product']?['price'] ?? 'N/A'}",
                ),
                isThreeLine: true,
              ),
            );
          }),
      ],
    );
  }

  Widget _buildAddStockTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Product Name")),
              TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: stockQuantityController,
                  decoration:
                      const InputDecoration(labelText: "Stock Quantity"),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: warrantyPeriodController,
                  decoration: const InputDecoration(
                      labelText: "Warranty Period (Months)"),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: categoryIdController,
                  decoration:
                      const InputDecoration(labelText: "Category ID (Optional)")),
              TextField(
                  controller: locationController,
                  decoration:
                      const InputDecoration(labelText: "Location (Optional)")),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _addStockItem,
                icon: const Icon(Icons.add),
                label: const Text("Add Stock Item"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
