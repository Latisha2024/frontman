import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:role_based_app/admin/widgets/user_list.dart';
import '../controllers/manage_users.dart';
import '../../constants/colors.dart';

class UserForm extends StatelessWidget {
  final AdminManageUsersController controller;
  final VoidCallback onCancel;
  const UserForm({super.key, required this.controller, required this.onCancel});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                controller.isEditMode ? 'Edit User' : 'Add New User',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),
              buildTextField(
                controller: controller.nameController,
                label: 'Full Name',
                icon: Icons.person,
                isRequired: true,
              ),
              const SizedBox(height: 16),
              buildTextField(
                controller: controller.emailController,
                label: 'Email Address',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                isRequired: true,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: IntlPhoneField(
                    initialCountryCode: 'IN',
                    decoration: const InputDecoration(
                      labelText: 'Phone Number *',
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    ),
                    onChanged: (phone) {
                      controller.phoneController.text = phone.countryCode+phone.number;
                    },
                  ),
                ),
              ),
              if (controller.phoneError != null) ...[
                const SizedBox(height: 6),
                Text(
                  controller.phoneError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              const SizedBox(height: 16),
              buildTextField(
                controller: controller.addressController,
                label: 'Address (Optional)',
                icon: Icons.location_on,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              buildTextField(
                controller: controller.passwordController,
                label: controller.isEditMode
                    ? 'Password (leave empty to keep current)'
                    : 'Password',
                icon: Icons.lock,
                obscureText: true,
                isRequired: !controller.isEditMode,
              ),
              if (controller.passwordError != null) ...[
                const SizedBox(height: 6),
                Text(
                  controller.passwordError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              const SizedBox(height: 16),
              buildDropdown(
                value: controller.selectedUserRole,
                items: controller.availableRoles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role.replaceAll('_', ' ').toUpperCase()),
                  );
                }).toList(),
                label: 'Role',
                icon: Icons.work,
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedUserRole = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              buildDropdown(
                value: controller.selectedUserStatus,
                items: controller.availableStatuses.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.toUpperCase()),
                  );
                }).toList(),
                label: 'Status',
                icon: Icons.circle,
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedUserStatus = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isLoading
                          ? null
                          : () {
                              if (controller.isEditMode) {
                                controller.updateUser();
                              } else {
                                controller.addUser();
                              }
                            },
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
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              controller.isEditMode
                                  ? 'Update User'
                                  : 'Add User',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary),
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
    bool obscureText = false,
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
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          prefixIcon: Icon(icon, color: AppColors.secondaryBlue),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
    required Function(String?) onChanged,
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle: TextStyle(color: AppColors.textSecondary),
        ),
        dropdownColor: Colors.white,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
