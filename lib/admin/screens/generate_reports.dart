import '../../sales_manager/screens/sales_manager_drawer.dart';
import './admin_drawer.dart';
import 'package:flutter/material.dart';
import '../controllers/generate_reports.dart';
import '../../constants/colors.dart';
import 'company_selection.dart';

class GenerateReportsScreen extends StatefulWidget {
  final Company? company;
  final String role;
  const GenerateReportsScreen({super.key, this.company, required this.role});

  @override
  State<GenerateReportsScreen> createState() => _GenerateReportsScreenState();
}

class _GenerateReportsScreenState extends State<GenerateReportsScreen> {
  late AdminGenerateReportsController controller;

  @override
  void initState() {
    super.initState();
    controller = AdminGenerateReportsController(companyId: widget.company?.id);
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
            title: const Text('Generate Reports'),
            backgroundColor: AppColors.primaryBlue,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          drawer: widget.role == "admin" ? AdminDrawer() : SalesManagerDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Report type selector and total amount
                Row(
                  children: [
                    const Text('Report Type:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: controller.selectedType,
                      items: controller.availableTypes
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type[0].toUpperCase() + type.substring(1)),
                              ))
                          .toList(),
                      onChanged: (type) {
                        if (type != null) controller.selectType(type);
                      },
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Total: \n₹${controller.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Simple Chart
                if (!controller.isLoading && controller.error == null && controller.filteredReports.isNotEmpty)
                  _buildSimpleChart(),
                const SizedBox(height: 16),
                // Loading/Error
                if (controller.isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (controller.error != null)
                  Center(child: Text(controller.error!, style: const TextStyle(color: Colors.red))),
                // Reports List
                if (!controller.isLoading && controller.error == null)
                  Expanded(
                    child: controller.filteredReports.isEmpty
                        ? const Center(child: Text('No reports available.'))
                        : ListView.builder(
                            itemCount: controller.filteredReports.length,
                            itemBuilder: (context, index) {
                              final report = controller.filteredReports[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(report.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(report.description),
                                      if (report.userName != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          'User: ${report.userName}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primaryBlue,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  trailing: Text(
                                    '${report.date.year}-${report.date.month.toString().padLeft(2, '0')}-${report.date.day.toString().padLeft(2, '0')}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text(report.title),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(report.description),
                                          if (report.userName != null) ...[
                                            const SizedBox(height: 8),
                                            Text(
                                              'User: ${report.userName}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryBlue,
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 12),
                                          ...report.details.entries.map((e) => Text('${e.key}: ${e.value}')),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSimpleChart() {
    if (controller.filteredReports.isEmpty) return const SizedBox.shrink();
    
    final report = controller.filteredReports.first;
    final details = report.details;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${controller.selectedType[0].toUpperCase() + controller.selectedType.substring(1)} Overview',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: details.entries.take(4).map((entry) {
                return Row(
                  children: [
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 150,
                      child: Text(
                        '${entry.key}:',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Center(
                        child: Text(
                          entry.value.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10,)
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}