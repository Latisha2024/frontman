import 'package:flutter/material.dart';
import 'package:role_based_app/sales_manager/screens/sales_manager_drawer.dart';
import '../../constants/colors.dart';
import '../controllers/assign_incentive.dart';
import '../widgets/assign_incentive_form.dart';
import 'admin_drawer.dart';

class AssignIncentiveScreen extends StatefulWidget {
  final String role;
  const AssignIncentiveScreen({super.key, required this.role});
  @override
  State<AssignIncentiveScreen> createState() => _AssignIncentiveScreenState();
}

class _AssignIncentiveScreenState extends State<AssignIncentiveScreen> {
  late AdminAssignIncentiveController controller;

  @override
  void initState() {
    super.initState();
    controller = AdminAssignIncentiveController();
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
              'Assign Incentive',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.primaryBlue,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: controller.isLoading ? null : () => controller.fetchAllIncentives(),
                icon: const Icon(Icons.refresh, color: Colors.white),
                tooltip: 'Refresh Incentives',
              ),
            ],
          ),
          drawer: widget.role == "admin" ? AdminDrawer() : SalesManagerDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Error/Success Messages
                if (controller.error != null) ...[
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
                  const SizedBox(height: 16),
                ],
                if (controller.successMessage != null) ...[
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
                  const SizedBox(height: 16),
                ],
                
                // Main Content
                Expanded(
                  child: AssignIncentiveForm(controller: controller),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}