import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../controllers/manage_products.dart';

class ProductForm extends StatelessWidget {
  final AdminManageProductsController controller;
  const ProductForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  controller.isEditMode ? 'Edit Product' : 'Add New Product',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 26),
                // Name
                buildTextField(
                  controller: controller.nameController,
                  label: 'Product Name',
                  icon: Icons.label,
                  isRequired: true,
                ),
                const SizedBox(height: 16),
                // Description
                buildTextField(
                  controller: controller.descriptionController,
                  label: 'Description (Optional)',
                  icon: Icons.description,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                // Category
                buildDropdown(
                  value: controller.categoryController.text.isNotEmpty
                      ? controller.categoryController.text
                      : (controller.availableCategories.length > 1 ? controller.availableCategories[1] : ''),
                  items: controller.availableCategories
                      .where((cat) => cat != 'All')
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat, style: const TextStyle(color: AppColors.darkBlue)),
                          ))
                      .toList(),
                  label: 'Category',
                  icon: Icons.category,
                  onChanged: (value) {
                    if (value != null) {
                      controller.categoryController.text = value;
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Price
                buildTextField(
                  controller: controller.priceController,
                  label: 'Price',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  isRequired: true,
                ),
                const SizedBox(height: 16),
                // Stock
                buildTextField(
                  controller: controller.stockController,
                  label: 'Stock',
                  icon: Icons.storage,
                  keyboardType: TextInputType.number,
                  isRequired: true,
                ),
                const SizedBox(height: 16),
                // Status
                buildDropdown(
                  value: controller.selectedProductStatus,
                  items: controller.availableStatuses
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.toUpperCase(), style: const TextStyle(color: AppColors.darkBlue)),
                          ))
                      .toList(),
                  label: 'Status',
                  icon: Icons.circle,
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedProductStatus = value;
                    }
                  },
                ),
                const SizedBox(height: 24),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.isEditMode) {
                            controller.updateProduct();
                          } else {
                            controller.addProduct();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          controller.isEditMode ? 'Update Product' : 'Add Product',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => controller.clearForm(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.darkBlue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                // Error and Success Messages
                if (controller.error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red.shade600, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.error!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (controller.successMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.successMessage!,
                            style: TextStyle(color: Colors.green.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentBlue),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          prefixIcon: Icon(icon, color: AppColors.darkBlue),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle: TextStyle(color: AppColors.darkBlue),
        ),
      ),
    );
  }

  Widget buildDropdown({
    required String value,
    required List<DropdownMenuItem<String>> items,
    required String label,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentBlue),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.darkBlue),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle: TextStyle(color: AppColors.darkBlue),
        ),
        dropdownColor: Colors.white,
        style: const TextStyle(color: AppColors.darkBlue),
      ),
    );
  }
}
