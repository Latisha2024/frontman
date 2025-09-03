// stock_page.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  // Controllers for adding/updating a new product
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockQuantityController = TextEditingController();
  final TextEditingController warrantyPeriodController = TextEditingController();
  final TextEditingController categoryIdController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  // Controller for updating/deleting existing stock items
  final TextEditingController stockItemIdController = TextEditingController();
  final TextEditingController updateStatusController = TextEditingController();

  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5000"));

  bool loading = false;
  String? message;
  List<dynamic> stockList = []; // To store the fetched stock items

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
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

      final response = await dio.post(
        "/distributor/stock/items",
        data: {
          "name": nameController.text,
          "price": double.tryParse(priceController.text) ?? 0,
          "stockQuantity": int.tryParse(stockQuantityController.text) ?? 0,
          "warrantyPeriodInMonths": int.tryParse(warrantyPeriodController.text) ?? 0,
          "categoryId": categoryIdController.text.isNotEmpty ? categoryIdController.text : null,
          "location": locationController.text.isNotEmpty ? locationController.text : null,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        message = "✅ Stock item added successfully!";
        // Clear text fields after successful creation
        nameController.clear();
        priceController.clear();
        stockQuantityController.clear();
        warrantyPeriodController.clear();
        categoryIdController.clear();
        locationController.clear();
      });
      _getAssignedStock(); // Refresh the list
    } catch (e) {
      String errorMessage = "❌ Error adding stock item. Please check your input.";
      if (e is DioError && e.response != null) {
        errorMessage = "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
      }
      setState(() => message = errorMessage);
    } finally {
      setState(() => loading = false);
    }
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
      String errorMessage = "❌ Error fetching stock.";
      if (e is DioError && e.response != null) {
        errorMessage = "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
      }
      setState(() => message = errorMessage);
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

      final response = await dio.put(
        "/distributor/stock/${stockItemIdController.text}",
        data: {
          "status": updateStatusController.text,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        message = "🔄 Stock status updated successfully!";
        updateStatusController.clear();
        stockItemIdController.clear();
      });
      _getAssignedStock(); // Refresh the list
    } catch (e) {
      String errorMessage = "❌ Error updating status. Please check the Item ID and status.";
      if (e is DioError && e.response != null) {
        errorMessage = "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
      }
      setState(() => message = errorMessage);
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

      final response = await dio.delete(
        "/distributor/stock/items/${stockItemIdController.text}",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        message = "🗑️ Stock item deleted successfully!";
        stockItemIdController.clear();
      });
      _getAssignedStock(); // Refresh the list
    } catch (e) {
      String errorMessage = "❌ Error removing stock item. Please check the Item ID.";
      if (e is DioError && e.response != null) {
        errorMessage = "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
      }
      setState(() => message = errorMessage);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _getAssignedStock(); // Fetch stock on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Distributor Stock Management")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (loading) const LinearProgressIndicator(),
            if (message != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(message!, style: const TextStyle(fontSize: 16, color: Colors.red)),
              ),

            // --- Section for adding a new product/stock item ---
            const Divider(),
            const Text("Add New Stock Item", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Product Name")),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
            TextField(controller: stockQuantityController, decoration: const InputDecoration(labelText: "Stock Quantity"), keyboardType: TextInputType.number),
            TextField(controller: warrantyPeriodController, decoration: const InputDecoration(labelText: "Warranty Period (Months)"), keyboardType: TextInputType.number),
            TextField(controller: categoryIdController, decoration: const InputDecoration(labelText: "Category ID (Optional)")),
            TextField(controller: locationController, decoration: const InputDecoration(labelText: "Location (Optional)")),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: loading ? null : _addStockItem,
              child: const Text("➕ Add Stock Item"),
            ),
            
            // --- Section for updating/deleting existing items ---
            const Divider(),
            const Text("Manage Existing Stock Item", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(controller: stockItemIdController, decoration: const InputDecoration(labelText: "Enter Stock Item ID")),
            TextField(controller: updateStatusController, decoration: const InputDecoration(labelText: "New Status (e.g., 'Sold', 'Dispatched')")),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: loading ? null : _updateStockStatus,
                    child: const Text("🔄 Update Status"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: loading ? null : _removeStockItem,
                    child: const Text("🗑️ Remove Item"),
                  ),
                ),
              ],
            ),
            
            // --- Section for displaying fetched stock ---
            const Divider(),
            const Text("Current Assigned Stock", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (stockList.isEmpty && !loading) const Text("No stock items found."),
            ...stockList.map((stock) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(stock['product']?['name'] ?? 'No Product Name'),
                  subtitle: Text(
                    "ID: ${stock['id']}\n"
                    "Status: ${stock['status']}\n"
                    "Location: ${stock['location']}\n"
                    "Price: \$${stock['product']?['price'] ?? 'N/A'}"
                  ),
                  isThreeLine: true,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}