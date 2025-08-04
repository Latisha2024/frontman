import 'package:flutter/material.dart';
import '../controllers/warranty_database.dart';
import '../../../constants/colors.dart';
import '../widgets/warranty_form.dart';
import '../widgets/warranty_list.dart';
import 'admin_drawer.dart';

class WarrantyDatabaseScreen extends StatefulWidget {
  const WarrantyDatabaseScreen({super.key});

  @override
  State<WarrantyDatabaseScreen> createState() => _WarrantyDatabaseScreenState();
}

class _WarrantyDatabaseScreenState extends State<WarrantyDatabaseScreen> {
  late AdminWarrantyDatabaseController controller;
  bool showForm = false;

  @override
  void initState() {
    super.initState();
    controller = AdminWarrantyDatabaseController();
    controller.applyFilters();
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
              'Manage Warranty Database',
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
                tooltip: showForm ? 'View Warranties' : 'Add Warranty',
              ),
            ],
          ),
          drawer: AdminDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: (showForm || controller.isEditMode)
                      ? WarrantyForm(controller: controller)
                      : WarrantyList(controller: controller),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 