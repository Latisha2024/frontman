import 'package:role_based_app/sales_manager/screens/sales_manager_drawer.dart';

import './admin_drawer.dart';
import 'package:flutter/material.dart';
import '../controllers/manage_products.dart';
import '../widgets/product_list.dart';
import '../widgets/product_form.dart';
import '../../constants/colors.dart';

class ManageProductsScreen extends StatefulWidget {
  final String role;
  const ManageProductsScreen({super.key, required this.role});

  @override
  State<ManageProductsScreen> createState() => ManageProductsScreenState();
}

class ManageProductsScreenState extends State<ManageProductsScreen> {
  late AdminManageProductsController controller;
  bool showForm = false;

  @override
  void initState() {
    super.initState();
    controller = AdminManageProductsController();
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
              'Manage Products',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.primaryBlue,
            elevation: 0,
            actions: [
              PopupMenuButton<
                String>(
                onSelected: (value) {
                  if (value == 'import') {
                    controller.importProducts();
                  } else if (value == 'export') {
                    controller.exportProducts();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'import',
                    child: Text('Import'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'export',
                    child: Text('Export'),
                  ),
                ],
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.fetchProducts();
                },
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                tooltip: 'Refresh Products',
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    showForm = !showForm;
                    if (!showForm) {
                      controller.clearForm();
                    }
                  });
                },
                icon: Icon(
                  showForm ? Icons.list : Icons.add,
                  color: Colors.white,
                ),
                tooltip: showForm ? 'View Products' : 'Add Product',
              ),
            ],
          ),
          drawer: widget.role == "admin" ? const AdminDrawer() : const SalesManagerDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Show error or success messages
                if (controller.error != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
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
                            controller.error!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                        IconButton(
                          onPressed: controller.clearMessages,
                          icon: Icon(Icons.close, color: Colors.red.shade700),
                        ),
                      ],
                    ),
                  ),
                if (controller.successMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
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
                            controller.successMessage!,
                            style: TextStyle(color: Colors.green.shade700),
                          ),
                        ),
                        IconButton(
                          onPressed: controller.clearMessages,
                          icon: Icon(Icons.close, color: Colors.green.shade700),
                        ),
                      ],
                    ),
                  ),
                // Main content
                Expanded(
                  child: (showForm || controller.isEditMode)
                      ? ProductForm(controller: controller)
                      : ProductList(controller: controller),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}