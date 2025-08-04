import 'package:role_based_app/sales_manager/screens/sales_manager_drawer.dart';

import './admin_drawer.dart';
import 'package:flutter/material.dart';
import '../controllers/manage_products.dart';
import '../widgets/product_list.dart';
import '../widgets/product_form.dart';
import '../../constants/colors.dart';
import 'company_selection.dart';

class ManageProductsScreen extends StatefulWidget {
  final Company? company;
  final String role;
  const ManageProductsScreen({super.key, this.company, required this.role});


  @override
  State<ManageProductsScreen> createState() => ManageProductsScreenState();
}

class ManageProductsScreenState extends State<ManageProductsScreen> {
  late AdminManageProductsController controller;
  bool showForm = false;

  @override
  void initState() {
    super.initState();
    final company = widget.company ?? CompanySelection.selectedCompany;
    controller = AdminManageProductsController(companyId: company?.id);
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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manage Products',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (widget.company != null)
                  Text(
                    widget.company!.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.white70,
                    ),
                  ),
              ],
            ),
            backgroundColor: AppColors.primaryBlue,
            elevation: 0,
                      actions: [
            IconButton(
              onPressed: () => _showCategoryManagementDialog(context),
              icon: const Icon(
                Icons.category,
                color: Colors.white,
              ),
              tooltip: 'Manage Categories',
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
          drawer: widget.role == "admin" ? AdminDrawer(company: widget.company) : SalesManagerDrawer(company: widget.company),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Expanded(
              child: (showForm || controller.isEditMode)
                ? ProductForm(controller: controller)
                : ProductList(controller: controller),
              ),
          ),
        );
      },
    );
  }

  void _showCategoryManagementDialog(BuildContext context) {
    final categoryController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manage Categories'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add Category Section
              const Text(
                'Add New Category:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(
                        hintText: 'Enter category name',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) {
                        controller.addCategory(value);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (categoryController.text.isNotEmpty) {
                        controller.addCategory(categoryController.text);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Existing Categories
              const Text(
                'Existing Categories:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...controller.availableCategories
                  .where((cat) => cat != 'All')
                  .map((category) => ListTile(
                        title: Text(category),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showRenameCategoryDialog(context, category),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _showDeleteCategoryDialog(context, category),
                            ),
                          ],
                        ),
                      )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showRenameCategoryDialog(BuildContext context, String oldName) {
    final newNameController = TextEditingController(text: oldName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Category'),
        content: TextField(
          controller: newNameController,
          decoration: const InputDecoration(
            labelText: 'New Category Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.renameCategory(oldName, newNameController.text);
              Navigator.pop(context);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteCategoryDialog(BuildContext context, String categoryName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete the category "$categoryName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteCategory(categoryName);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}