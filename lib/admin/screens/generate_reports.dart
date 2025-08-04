import './admin_drawer.dart';
import 'package:flutter/material.dart';
import '../controllers/generate_reports.dart';
import '../../../constants/colors.dart';

class GenerateReportsScreen extends StatefulWidget {
  const GenerateReportsScreen({super.key});

  @override
  State<GenerateReportsScreen> createState() => _GenerateReportsScreenState();
}

class _GenerateReportsScreenState extends State<GenerateReportsScreen> {
  late AdminGenerateReportsController controller;

  @override
  void initState() {
    super.initState();
    controller = AdminGenerateReportsController();
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
          drawer: AdminDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Report type selector
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
                  ],
                ),
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
                                  subtitle: Text(report.description),
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
}