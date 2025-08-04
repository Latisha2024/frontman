import '../../constants/colors.dart';
import 'package:flutter/material.dart';
import '../controllers/manage_users.dart';
import '../widgets/user_form.dart';
import '../widgets/user_list.dart';
import 'admin_drawer.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => ManageUsersScreenState();
}

class ManageUsersScreenState extends State<ManageUsersScreen> {
  late AdminManageUsersController controller;
  bool showForm = false;

  @override
  void initState() {
    super.initState();
    controller = AdminManageUsersController();
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
              'Manage Users',
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
                tooltip: showForm ? 'View Users' : 'Add User',
              ),
            ],
          ),
          drawer: const AdminDrawer(),
          body: Column(
            children: [
              // Header with stats
              buildStatsHeader(),

              // Main content
              Expanded(
                child: (showForm || controller.isEditMode)
                    ? buildFormView()
                    : buildListView(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildStatsHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildStatCard(
                'Total Users',
                controller.users.length.toString(),
                Icons.people,
              ),
              buildStatCard(
                'Active',
                controller.users.where((u) => u.status == 'active').length.toString(),
                Icons.check_circle,
              ),
              buildStatCard(
                'Inactive',
                controller.users.where((u) => u.status == 'inactive').length.toString(),
                Icons.close,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildStatCard(
                'Suspended',
                controller.users.where((u) => u.status == 'suspended').length.toString(),
                Icons.block,
              ),
              buildStatCard(
                'Pending',
                controller.users.where((u) => u.status == 'pending').length.toString(),
                Icons.schedule,
              ),
              buildStatCard(
                'Filtered',
                controller.filteredUsers.length.toString(),
                Icons.filter_list,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.secondaryBlue.withOpacity(0.15),
        border: Border.all(color: AppColors.secondaryBlue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFormView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: UserForm(controller: controller),

    );
  }

  Widget buildListView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: UserList(controller: controller),
    );
  }
}