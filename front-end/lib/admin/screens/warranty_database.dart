import 'package:flutter/material.dart';
import '../../sales_manager/screens/sales_manager_drawer.dart';
import '../controllers/warranty_database.dart';
import '../../constants/colors.dart';
import '../widgets/warranty_list.dart';
import 'admin_drawer.dart';

class WarrantyDatabaseScreen extends StatefulWidget {
  final String role;
  const WarrantyDatabaseScreen({super.key, required this.role});

  @override
  State<WarrantyDatabaseScreen> createState() => _WarrantyDatabaseScreenState();
}

class _WarrantyDatabaseScreenState extends State<WarrantyDatabaseScreen> {
  late AdminWarrantyDatabaseController controller;

  @override
  void initState() {
    super.initState();
    controller = AdminWarrantyDatabaseController();
    // Load warranty cards from API on initialization
    _loadWarrantyCards();
  }
  
  Future<void> _loadWarrantyCards() async {
    await controller.fetchWarrantyCards();
  }
  
  Future<void> _refreshWarrantyCards() async {
    await controller.refreshWarrantyCards();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: const Text(
              'Warranty',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: controller.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : IconButton(
                        tooltip: 'Refresh',
                        onPressed: _refreshWarrantyCards,
                        icon: const Icon(Icons.refresh, color: Colors.white),
                      ),
              ),
            ],
            backgroundColor: AppColors.primaryBlue,
            elevation: 0,
          ),
          drawer: widget.role == "admin" ? const AdminDrawer() : const SalesManagerDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Error message display
                if (controller.error != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.error!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            controller.error = null;
                            controller.notifyListeners();
                          },
                          color: Colors.red.shade600,
                          iconSize: 20,
                        ),
                      ],
                    ),
                  ),
                // Success message display
                if (controller.successMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.green.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.successMessage!,
                            style: TextStyle(color: Colors.green.shade700),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            controller.successMessage = null;
                            controller.notifyListeners();
                          },
                          color: Colors.green.shade600,
                          iconSize: 20,
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: WarrantyList(
                    controller: controller,
                    onRefresh: _refreshWarrantyCards,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}