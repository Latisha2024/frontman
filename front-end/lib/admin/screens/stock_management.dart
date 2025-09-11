import 'package:flutter/material.dart';
import 'package:role_based_app/admin/controllers/stock_controller.dart';
import '../../constants/colors.dart';
import '../../sales_manager/screens/sales_manager_drawer.dart';
import 'admin_drawer.dart';
 

class StockManagementScreen extends StatefulWidget {
  final String role;
  const StockManagementScreen({super.key, required this.role});



  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  List<Map<String, dynamic>> stockEntries = [];
  bool isLoading = true;
  String? error;
  String? successMessage;

  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final List<String> statusOptions = [
    // Restricted to backend-supported enum values
    'Available',
    'Moved',
    'Missing'
  ];

  @override
  void initState() {
    super.initState();
    _loadStockEntries();
  }

  Future<void> _deleteStock(String id) async {
    // Optimistic update: remove immediately, revert on error
    final previous = List<Map<String, dynamic>>.from(stockEntries);
    setState(() {
      stockEntries = stockEntries.where((e) => e['id'] != id).toList();
      successMessage = null;
      error = null;
    });
    try {
      final res = await StockController.deleteStock(id: id);
      setState(() {
        successMessage = (res['message'] ?? 'Stock deleted successfully').toString();
      });
      _scheduleAutoHideMessages();
    } catch (e) {
      // Revert list and show error
      setState(() {
        stockEntries = previous;
        error = 'Error deleting stock: $e';
        successMessage = null;
      });
      _scheduleAutoHideMessages();
    }
  }

  void _confirmDelete(Map<String, dynamic> stock) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Stock'),
        content: Text(
          'Are you sure you want to delete this stock for "${stock['product']?['name'] ?? 'Unknown Product'}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteStock(stock['id']);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _scheduleAutoHideMessages() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      if (error != null || successMessage != null) {
        setState(() {
          error = null;
          successMessage = null;
        });
      }
    });
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
      _scheduleAutoHideMessages();
    }
  }

  Future<void> _createStock() async {
    if (_productIdController.text.isEmpty ||
        _statusController.text.isEmpty ||
        _locationController.text.isEmpty) {
      setState(() {
        error = 'Please fill all fields';
        successMessage = null;
      });
      _scheduleAutoHideMessages();
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
      setState(() {
        successMessage = 'Stock entry created successfully';
        error = null;
      });
      _scheduleAutoHideMessages();
      
      _loadStockEntries();
    } catch (e) {
      setState(() {
        error = 'Error creating stock: $e';
        successMessage = null;
      });
      _scheduleAutoHideMessages();
    }
  }

  Future<void> _updateStock(String id, String status, String location) async {
    try {
      await StockController.updateStock(
        id: id,
        status: status,
        location: location,
      );
      setState(() {
        successMessage = 'Stock updated successfully';
        error = null;
      });
      _scheduleAutoHideMessages();
      
      _loadStockEntries();
    } catch (e) {
      setState(() {
        error = 'Error updating stock: $e';
        successMessage = null;
      });
      _scheduleAutoHideMessages();
    }
  }

  Future<void> _cleanupBrokenStock() async {
    try {
      final result = await StockController.cleanupBrokenStock();
      setState(() {
        successMessage = (result['message'] ?? 'Cleanup completed').toString();
        error = null;
      });
      _scheduleAutoHideMessages();
      _loadStockEntries();
    } catch (e) {
      setState(() {
        error = 'Error during cleanup: $e';
        successMessage = null;
      });
      _scheduleAutoHideMessages();
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
      drawer: widget.role == "admin" ? const AdminDrawer() : const SalesManagerDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                  if (error != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              error!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (error != null) const SizedBox(height: 16),
                  if (successMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              successMessage!,
                              style: TextStyle(color: Colors.green.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (successMessage != null) const SizedBox(height: 16),
                  // Summary Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  const SizedBox(height: 16),
                  if (stockEntries.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'No stock entries found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...[
                      for (final stock in stockEntries)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(
                                stock['product'] != null ? stock['product']['name'] : 'Unknown Product',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Status: ${stock['status']}'),
                                  Text('Location: ${stock['location']}'),
                                  if (stock['product'] != null) ...[
                                    Text('Price: ₹${stock['product']['price']}'),
                                    Text('Warranty: ${stock['product']['warrantyPeriodInMonths']} months'),
                                  ],
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Edit',
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _showEditDialog(stock),
                                  ),
                                  IconButton(
                                    tooltip: 'Delete',
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () => _confirmDelete(stock),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
              ],
            ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'moved':
        return Colors.blue;
      case 'missing':
        return Colors.redAccent;
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
