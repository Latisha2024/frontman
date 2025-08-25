import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class TaskForm extends StatelessWidget {
  final TextEditingController executiveIdController;
  final TextEditingController descriptionController;
  final TextEditingController dueDateController;
  final String selectedPriority;
  final ValueChanged<String> onPriorityChanged;
  final VoidCallback onSubmit;
  final bool isEditMode;
  final VoidCallback onCancel;
  final String? errorMessage;
  final String? successMessage;
  const TaskForm({
    super.key,
    required this.executiveIdController,
    required this.descriptionController,
    required this.dueDateController,
    required this.selectedPriority,
    required this.onPriorityChanged,
    required this.onSubmit,
    required this.isEditMode,
    required this.onCancel,
    this.errorMessage,
    this.successMessage,
  });

  @override
  Widget build(BuildContext context) {
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
              isEditMode ? 'Edit Task' : 'Add New Task',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 26),
            buildTextField(
              controller: executiveIdController,
              label: 'Executive ID',
              icon: Icons.person,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            buildTextField(
              controller: descriptionController,
              label: 'Task Description',
              icon: Icons.assignment,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            buildTextField(
              controller: dueDateController,
              label: 'Due Date (YYYY-MM-DD)',
              icon: Icons.date_range,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            buildDropdown(
              value: selectedPriority,
              items: const [
                DropdownMenuItem(value: 'High', child: Text('High', style: TextStyle(color: AppColors.textPrimary))),
                DropdownMenuItem(value: 'Normal', child: Text('Normal', style: TextStyle(color: AppColors.textPrimary))),
                DropdownMenuItem(value: 'Low', child: Text('Low', style: TextStyle(color: AppColors.textPrimary))),
              ],
              label: 'Priority',
              icon: Icons.flag,
              onChanged: (val) { if (val != null) onPriorityChanged(val); },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isEditMode ? 'Update Task' : 'Add Task',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
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
            if (errorMessage != null) ...[
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
                        errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (successMessage != null) ...[
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
                        successMessage!,
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
          labelStyle: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget buildDropdown({
    required String value,
    required List<DropdownMenuItem<String>> items,
    required String label,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.secondaryBlue),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle: TextStyle(color: AppColors.textSecondary),
        ),
        dropdownColor: Colors.white,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
} 