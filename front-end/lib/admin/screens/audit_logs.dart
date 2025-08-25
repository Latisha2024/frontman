import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../sales_manager/screens/sales_manager_drawer.dart';
import '../controllers/audit_logs.dart';
import '../widgets/audit_log_form.dart';
import 'admin_drawer.dart';

class AuditLogsScreen extends StatefulWidget {
  final String role;
  const AuditLogsScreen({super.key, required this.role});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  late AdminAuditLogsController controller;

  @override
  void initState() {
    super.initState();
    controller = AdminAuditLogsController();
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
              'Audit Logs',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.primaryBlue,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () => controller.fetchAuditLogs(),
                tooltip: 'Refresh Logs',
              ),
               IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () => _showCreateLogDialog(),
                tooltip: 'Create Log',
              ),
            ],
          ),
          drawer: widget.role == "admin" ? AdminDrawer() : SalesManagerDrawer(),
          body: Column(
            children: [
              if (controller.error != null)
                _buildBanner(controller.error!, Colors.red.shade100, Colors.red),
              if (controller.successMessage != null)
                _buildBanner(controller.successMessage!, Colors.green.shade100, Colors.green),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: buildSearchAndFilter(),
              ),
              Expanded(
                child: controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : controller.filteredLogs.isEmpty
                        ? const Center(child: Text('No logs found.'))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: controller.filteredLogs.length,
                            itemBuilder: (context, index) {
                              final log = controller.filteredLogs[index];
                              return buildLogCard(log);
                            },
                          ),
              ),
            ],
          ),
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
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            onChanged: controller.searchLogs,
            decoration: InputDecoration(
              hintText: 'Search logs by user, action, or details...',
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
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: controller.selectedAction,
                    items: controller.availableActions.map((action) {
                      return DropdownMenuItem(
                        value: action,
                        child: Text(
                          action == 'All' ? 'All' : action,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) controller.filterByAction(newValue);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Action',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      labelStyle: TextStyle(color: AppColors.textPrimary, fontSize: 12),
                    ),
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLogCard(AuditLog log) {
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
            Row(
              children: [
                const Icon(Icons.history, color: AppColors.secondaryBlue, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${log.action}: ${log.resource}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        log.user.name ?? log.user.email,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                buildTimestampChip(log.timestamp),
              ],
            ),
            if (log.details != null && log.details!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  log.details!,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTimestampChip(DateTime timestamp) {
    String formatted = '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondaryBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        formatted,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
      ),
    );
  }

  void _showCreateLogDialog() {
    showDialog(
      context: context,
      builder: (context) => AuditLogForm(controller: controller),
    );
  }

  Widget _buildBanner(String message, Color color, Color textColor) {
    return Container(
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.all(12),
      child: Text(
        message,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}