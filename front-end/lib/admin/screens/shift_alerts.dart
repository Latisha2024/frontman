import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/shift_alerts.dart';
import '../screens/admin_drawer.dart';
import '../../constants/colors.dart';
import '../../sales_manager/screens/sales_manager_drawer.dart';
 

class ShiftAlertsScreen extends StatefulWidget {
  final String role;
  const ShiftAlertsScreen({super.key, required this.role});

  @override
  State<ShiftAlertsScreen> createState() => _ShiftAlertsScreenState();
}

class _ShiftAlertsScreenState extends State<ShiftAlertsScreen> {
  late AdminShiftAlertsController controller;

  @override
  void initState() {
    super.initState();
    controller = AdminShiftAlertsController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Date/Time pickers removed – backend expects only userId and message

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
          appBar: AppBar(
            title: const Text('Shift Alerts'),
            backgroundColor: AppColors.primaryBlue,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'Refresh Alerts',
                onPressed: controller.isLoading ? null : controller.fetchAlerts,
                icon: const Icon(Icons.refresh, color: Colors.white),
              ),
            ],
          ),
          drawer: widget.role == "admin"
              ? const AdminDrawer()
              : const SalesManagerDrawer(),
          body: Column(
            children: [
              Container(
                color: Colors.white,
                child: TabBar(
                  labelColor: AppColors.primaryBlue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.primaryBlue,
                  tabs: [
                    Tab(text: 'Create Alert', icon: Icon(Icons.add_alert)),
                    Tab(text: 'Manage Alerts', icon: Icon(Icons.list_alt)),
                  ],
                ),
              ),
              // message banners
              Column(
                children: [
                  if (controller.error != null)
                    Container(
                      width: double.infinity,
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
                          IconButton(
                            onPressed: controller.clearMessages,
                            icon: const Icon(Icons.close),
                            color: Colors.red.shade700,
                          )
                        ],
                      ),
                    ),
                  if (controller.successMessage != null)
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
                          IconButton(
                            onPressed: controller.clearMessages,
                            icon: const Icon(Icons.close),
                            color: Colors.green.shade700,
                          )
                        ],
                      ),
                    ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildCreateTab(),
                    _buildManageTab(),
                  ],
                ),
              ),
            ],
          ),
        ));
      },
    );
  }

  Widget _buildCreateTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller.userIdController,
                decoration: InputDecoration(
                  labelText: 'User Name *',
                  hintText: 'Enter user name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.messageController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Alert Message *',
                  hintText: 'Enter detailed alert message',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.message),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isLoading ? null : controller.createShiftAlert,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: controller.isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Send Alert'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.clearForm,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Clear Form'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManageTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: controller.searchAlerts,
                      decoration: InputDecoration(
                        hintText: 'Search alerts...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: controller.selectedFilter,
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All')),
                      DropdownMenuItem(value: 'Acked', child: Text('Acknowledged')),
                      DropdownMenuItem(value: 'Unacked', child: Text('Unacknowledged')),
                    ],
                    onChanged: (val) {
                      if (val != null) controller.filterAlerts(val);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (controller.filteredAlerts.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text('No alerts found', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        ),
                      )
                    else ...[
                      for (final alert in controller.filteredAlerts) _buildAlertCard(alert),
                    ],
                  ],
                ),
        )
      ],
    );
  }

  Widget _buildAlertCard(AlertModel alert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: alert.acknowledged ? Colors.grey.shade300 : AppColors.primaryBlue,
            width: alert.acknowledged ? 1 : 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: alert.acknowledged ? Colors.green : AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      alert.acknowledged ? 'ACK' : 'NEW',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('MMM dd, HH:mm').format(alert.createdAt),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                alert.message,
                style: TextStyle(fontSize: 14, fontWeight: alert.acknowledged ? FontWeight.normal : FontWeight.w500),
              ),
              if (alert.userId != null) ...[
                const SizedBox(height: 8),
                Text('User ID: ${alert.userId}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
