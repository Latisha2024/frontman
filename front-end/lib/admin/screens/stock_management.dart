import 'package:flutter/material.dart';
import 'package:role_based_app/admin/controllers/stock_controller.dart';
import '../../constants/colors.dart';
import '../../sales_manager/screens/sales_manager_drawer.dart';
import 'admin_drawer.dart';
import 'company_selection.dart';

class StockManagementScreen extends StatefulWidget {
  final String role;
  final Company? company;
  const StockManagementScreen({super.key, this.company,required this.role});



  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  List<Map<String, dynamic>> stockEntries = [];
  bool isLoading = true;
  String? error;

  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final List<String> statusOptions = [
    'Available',
    'Assigned',
    'Distributed',
    'Sold',
    'Damaged',
    'Returned'
  ];

  @override
  void initState() {
    super.initState();
    _loadStockEntries();
  }

  Future<void> _loadStockEntries() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final entries = await StockController.getAllStock();
      setState(() {
        stockEntries = entries;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _createStock() async {
    if (_productIdController.text.isEmpty ||
        _statusController.text.isEmpty ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      await StockController.createStock(
        productId: _productIdController.text,
        status: _statusController.text,
        location: _locationController.text,
      );
      
      _productIdController.clear();
      _statusController.clear();
      _locationController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock entry created successfully')),
      );
      
      _loadStockEntries();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating stock: $e')),
      );
    }
  }

  Future<void> _updateStock(String id, String status, String location) async {
    try {
      await StockController.updateStock(
        id: id,
        status: status,
        location: location,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock updated successfully')),
      );
      
      _loadStockEntries();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating stock: $e')),
      );
    }
  }

  Future<void> _cleanupBrokenStock() async {
    try {
      final result = await StockController.cleanupBrokenStock();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Cleanup completed')),
      );
      _loadStockEntries();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during cleanup: $e')),
      );
    }
  }

  void _showEditDialog(Map<String, dynamic> stock) {
    final statusController = TextEditingController(text: stock['status']);
    final locationController = TextEditingController(text: stock['location']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Stock Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Product: ${stock['product']?['name'] ?? 'Unknown'}'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: statusController.text,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: statusOptions.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                statusController.text = value ?? '';
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateStock(
                stock['id'],
                statusController.text,
                locationController.text,
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Stock Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _productIdController,
              decoration: const InputDecoration(
                labelText: 'Product ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: statusOptions.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                _statusController.text = value ?? '';
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _createStock();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stocks'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            onPressed: _cleanupBrokenStock,
            tooltip: 'Cleanup Broken Stock',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStockEntries,
            tooltip: 'Refresh',
          ),
           IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateDialog,
            tooltip: 'Add Stock',
          ),
        ],
      ),
      drawer: widget.role == "admin" ? AdminDrawer(company: widget.company) : SalesManagerDrawer(company: widget.company),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
                  children: [
                    // Summary Cards
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    const Icon(Icons.inventory, size: 32, color: AppColors.primaryBlue),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${stockEntries.length}',
                                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                    ),
                                    const Text('Total Stock'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    const Icon(Icons.check_circle, size: 32, color: AppColors.primaryBlue),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${stockEntries.where((s) => s['status'] == 'Available').length}',
                                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                    ),
                                    const Text('Available'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Stock List
                    Expanded(
                      child: stockEntries.isEmpty
                          ? const Center(
                              child: Text(
                                'No stock entries found',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: stockEntries.length,
                              itemBuilder: (context, index) {
                                final stock = stockEntries[index];
                                final product = stock['product'];
                                
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: _getStatusColor(stock['status']),
                                      child: Text(
                                        stock['status'][0].toUpperCase(),
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    title: Text(
                                      product != null ? product['name'] : 'Unknown Product',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Status: ${stock['status']}'),
                                        Text('Location: ${stock['location']}'),
                                        if (product != null) ...[
                                          Text('Price: ₹${product['price']}'),
                                          Text('Warranty: ${product['warrantyPeriodInMonths']} months'),
                                        ],
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => _showEditDialog(stock),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'assigned':
        return Colors.blue;
      case 'distributed':
        return Colors.orange;
      case 'sold':
        return Colors.purple;
      case 'damaged':
        return Colors.red;
      case 'returned':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _productIdController.dispose();
    _statusController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
