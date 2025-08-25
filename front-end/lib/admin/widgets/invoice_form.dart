
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

  // Controllers for line item fields
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final unitPriceController = TextEditingController();
  final gstRateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
    gstRateController.dispose();
    super.dispose();
  }

  void addLineItem() {
    final desc = descriptionController.text.trim();
    final qty = int.tryParse(quantityController.text.trim()) ?? 0;
    final price = double.tryParse(unitPriceController.text.trim()) ?? 0.0;
    final gst = double.tryParse(gstRateController.text.trim()) ?? 0.0;
    if (desc.isEmpty || qty <= 0 || price <= 0) return;
    final amount = qty * price;
    setState(() {
      controller.formItems.add(LineItem(
        description: desc,
        quantity: qty,
        unitPrice: price,
        amount: amount,
        gstRate: gst,
      ));
      descriptionController.clear();
      quantityController.clear();
      unitPriceController.clear();
      gstRateController.clear();
    });
  }

  void removeLineItem(int index) {
    setState(() {
      controller.formItems.removeAt(index);
    });
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
              Text(
                controller.isEditMode ? 'Edit Invoice' : 'Add New Invoice',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),
              buildTextField(
                controller: controller.invoiceNumberController,
                label: 'Invoice Number',
                icon: Icons.confirmation_number,
                isRequired: true,
              ),
              const SizedBox(height: 16),
              buildTextField(
                controller: controller.dueDateController,
                label: 'Due Date (YYYY-MM-DD)',
                icon: Icons.event,
                isRequired: true,
              ),
              const SizedBox(height: 16),
              buildTextField(
                controller: controller.referenceController,
                label: 'Reference',
                icon: Icons.receipt,
                isRequired: true,
              ),
              const SizedBox(height: 16),
              buildTextField(
                controller: controller.billToController,
                label: 'Bill To (Client & Address)',
                icon: Icons.person,
                isRequired: true,
              ),
              const SizedBox(height: 20),
              const Text('Items', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Column(
                children: [
                  SizedBox(
                    child: buildTextField(
                      controller: descriptionController,
                      label: 'Description',
                      icon: Icons.description,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    child: buildTextField(
                      controller: quantityController,
                      label: 'Quantity',
                      icon: Icons.format_list_numbered,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    child: buildTextField(
                      controller: unitPriceController,
                      label: 'Unit Price',
                      icon: Icons.currency_rupee_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    child: buildTextField(
                      controller: gstRateController,
                      label: 'GST %',
                      icon: Icons.percent,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: addLineItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Add'),
                  )
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.formItems.length,
                itemBuilder: (context, index) {
                  final item = controller.formItems[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.secondaryBlue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(item.description),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quantity: ${item.quantity}'),
                          Text('Unit Price: ${item.unitPrice.toStringAsFixed(2)}'),
                          Text('GST : ${item.gstRate.toStringAsFixed(2)}%'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Amount: ${item.amount.toStringAsFixed(2)}'),
                              Expanded(
                                child: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => removeLineItem(index),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text('Subtotal:  ${controller.calculateSubtotal().toStringAsFixed(2)}',style: const TextStyle(color: AppColors.textPrimary, fontSize: 18),),
              Text('GST Total: ${controller.calculateGstTotal().toStringAsFixed(2)}',style: const TextStyle(color: AppColors.textPrimary, fontSize: 18),),
              Text('Total Due: ${controller.calculateTotalDue().toStringAsFixed(2)}',style: const TextStyle(color: AppColors.textPrimary, fontSize: 18),),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isLoading 
                          ? null 
                          : (controller.isEditMode ? controller.updateInvoice : controller.createManualInvoice),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              controller.isEditMode ? 'Update Invoice' : 'Create Invoice',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => controller.clearForm(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
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
