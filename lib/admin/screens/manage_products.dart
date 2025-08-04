import './admin_drawer.dart';
import 'package:flutter/material.dart';
import '../controllers/manage_products.dart';
import '../widgets/product_list.dart';
import '../widgets/product_form.dart';
import '../../../constants/colors.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

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
          drawer: const AdminDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
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