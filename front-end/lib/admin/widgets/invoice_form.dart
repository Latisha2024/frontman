
import 'package:flutter/material.dart';
import '../controllers/invoices.dart';
import '../../constants/colors.dart';

class InvoiceForm extends StatefulWidget {
  final AdminInvoicesController controller;
  const InvoiceForm({super.key, required this.controller});

  @override
  State<InvoiceForm> createState() => _InvoiceFormState();
}

class _InvoiceFormState extends State<InvoiceForm> {
  AdminInvoicesController get controller => widget.controller;
  // Controller for generating invoice by Order ID
  final orderIdController = TextEditingController();

  // Controllers for manual invoice creation
  final userIdController = TextEditingController();
  final productNameController = TextEditingController();
  final quantityController = TextEditingController();
  final unitPriceController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? selectedDueDate;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    orderIdController.dispose();
    userIdController.dispose();
    productNameController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

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
                color: AppColors.primaryBlue.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Generate by Order ID section (Admin uses Accountant endpoint)
              const Text(
                'Generate Invoice by Order ID',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              buildTextField(
                controller: orderIdController,
                label: 'Order ID',
                icon: Icons.tag,
                isRequired: true,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: controller.isLoading
                    ? null
                    : () async {
                        final id = orderIdController.text.trim();
                        final result = await controller.generateInvoiceFromOrder(id);
                        if (result != null) {
                          orderIdController.clear();
                        }
                      },
                icon: const Icon(Icons.receipt_long),
                label: controller.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Generate Invoice'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
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
                      IconButton(
                        tooltip: 'Dismiss',
                        onPressed: () {
                          controller.successMessage = null;
                          controller.notifyListeners();
                        },
                        icon: const Icon(Icons.close),
                        color: Colors.green.shade700,
                      )
                    ],
                  ),
                ),
              ],

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
                      Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.error!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Dismiss',
                        onPressed: () {
                          controller.error = null;
                          controller.notifyListeners();
                        },
                        icon: const Icon(Icons.close),
                        color: Colors.red.shade700,
                      )
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),

              // Manual Invoice Creation Section
              const Text(
                'Create Manual Invoice',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              buildTextField(
                controller: userIdController,
                label: 'User Name',
                icon: Icons.person,
                isRequired: true,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                      controller: productNameController,
                      label: 'Item Name',
                      icon: Icons.shopping_bag,
                      isRequired: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                      controller: quantityController,
                      label: 'Quantity',
                      icon: Icons.numbers,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildTextField(
                      controller: unitPriceController,
                      label: 'Unit Price',
                      icon: Icons.currency_rupee,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              buildTextField(
                controller: descriptionController,
                label: 'Description (optional)',
                icon: Icons.notes,
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDueDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDueDate = picked;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.secondaryBlue.withOpacity(0.3)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.secondaryBlue),
                      const SizedBox(width: 12),
                      Text(
                        selectedDueDate == null
                            ? 'Select Due Date (optional)'
                            : 'Due: ${selectedDueDate!.year}-${selectedDueDate!.month.toString().padLeft(2, '0')}-${selectedDueDate!.day.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: controller.isLoading
                    ? null
                    : () async {
                        final userId = userIdController.text.trim();
                        final name = productNameController.text.trim();
                        final qty = int.tryParse(quantityController.text.trim());
                        final price = double.tryParse(unitPriceController.text.trim());

                        if (userId.isEmpty || name.isEmpty || qty == null || qty <= 0 || price == null || price <= 0) {
                          controller.error = 'Please fill User ID, Item Name, positive Quantity and Unit Price.';
                          controller.notifyListeners();
                          return;
                        }

                        final item = LineItem(
                          description: name,
                          quantity: qty,
                          unitPrice: price,
                          amount: qty * price,
                          gstRate: 0,
                        );

                        final created = await controller.createManualInvoice(
                          userId: userId,
                          items: [item],
                          description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
                          dueDate: selectedDueDate,
                        );

                        if (created != null) {
                          // Clear local fields
                          userIdController.clear();
                          productNameController.clear();
                          quantityController.clear();
                          unitPriceController.clear();
                          descriptionController.clear();
                          setState(() => selectedDueDate = null);
                        }
                      },
                icon: const Icon(Icons.playlist_add_check),
                label: controller.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Create Manual Invoice'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
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
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          prefixIcon: Icon(icon, color: AppColors.secondaryBlue),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
} 
