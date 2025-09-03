import '../../constants/colors.dart';
import 'package:flutter/material.dart';
import '../controllers/manage_users.dart';

class UserList extends StatelessWidget {
  final AdminManageUsersController controller;
  
  const UserList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Column(
          children: [
            // Search and Filter Section
            buildSearchAndFilter(),
            const SizedBox(height: 20),
            if (controller.successMessage != null) ...[
              Container(
                width: double.infinity,
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
              const SizedBox(height: 12),
            ],
            
            // Users List
            Expanded(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : controller.filteredUsers.isEmpty
                      ? buildEmptyState()
                      : ListView.builder(
                          itemCount: controller.filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = controller.filteredUsers[index];
                            return buildUserCard(context, user);
                          },
                        ),
            ),
          ],
        );
      },
    );
  }

  Widget buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: controller.searchUsers,
            decoration: InputDecoration(
              hintText: 'Search users by name, email, or phone...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.textPrimary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.textPrimary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.textPrimary),
              ),
              filled: true,
            ),
          ),
          const SizedBox(height: 16),
          
          // Filter Row 1
          Row(
            children: [
              Expanded(
                child: buildFilterDropdown(
                  value: controller.selectedRole,
                  items: ['All', ...controller.availableRoles],
                  label: 'Role',
                  onChanged: controller.filterByRole,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildFilterDropdown(
                  value: controller.selectedStatus,
                  items: ['All', ...controller.availableStatuses],
                  label: 'Status',
                  onChanged: controller.filterByStatus,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
        ],
      ),
    );
  }

  Widget buildFilterDropdown({
    required String value,
    required List<String> items,
    required String label,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              item == 'All' ? 'All $label' : item.replaceAll('_', ' ').toUpperCase(),
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue != null) onChanged(newValue);
        },
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        dropdownColor: Colors.white,
        style: const TextStyle(color: Colors.black87, fontSize: 14),
      ),
    );
  }

  Widget buildUserCard(BuildContext context, User user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.backgroundGray.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.secondaryBlue,
                  radius: 25,
                  child: Text(
                    user.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox.shrink(),
                    ],
                  ),
                ),
                Column(
                  children: [
                    buildRoleChip(user.role),
                    const SizedBox(height: 4),
                    buildStatusChip(user.status),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // User Details
            buildDetailRow(Icons.work, 'Role', user.role),
            if (user.phone != null) buildDetailRow(Icons.phone, 'Phone', user.phone!),
            if (user.address != null) buildDetailRow(Icons.location_on, 'Address', user.address!),
            buildDetailRow(Icons.calendar_today, 'Joined', formatDate(user.createdAt)),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.isLoading ? null : () => controller.editUser(user),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.textPrimary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.isLoading ? null : () => showDeleteDialog(context, user),
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textPrimary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRoleChip(String role) {
    Color color;
    IconData icon;
    
    switch (role) {
      case 'Admin':
        color = Colors.red;
        icon = Icons.admin_panel_settings;
        break;
      case 'SalesManager':
        color = Colors.blue;
        icon = Icons.sell;
        break;
      case 'Worker':
        color = Colors.green;
        icon = Icons.work;
        break;
      case 'Accountant':
        color = Colors.orange;
        icon = Icons.account_balance;
        break;
      case 'Distributor':
        color = Colors.purple;
        icon = Icons.local_shipping;
        break;
      case 'FieldExecutive':
        color = Colors.teal;
        icon = Icons.person_pin_circle;
        break;
      case 'Plumber':
        color = Colors.indigo;
        icon = Icons.storefront;
        break;
      default:
        color = AppColors.textSecondary;
        icon = Icons.person;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 2),
          Text(
            role.toUpperCase(),
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget buildStatusChip(String status) {
    Color color;
    IconData icon;
    
    switch (status) {
      case 'active':
        color = AppColors.success;
        icon = Icons.check_circle;
        break;
      case 'inactive':
        color = AppColors.textSecondary;
        icon = Icons.circle;
        break;
      case 'suspended':
        color = AppColors.error;
        icon = Icons.block;
        break;
      case 'pending':
        color = AppColors.warning;
        icon = Icons.schedule;
        break;
      default:
        color = AppColors.textSecondary;
        icon = Icons.circle;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 2),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16),
          Text(
            'No users found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }


  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void showDeleteDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              controller.clearForm()
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteUser(user.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
} 