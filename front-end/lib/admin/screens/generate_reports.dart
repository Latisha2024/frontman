import '../../sales_manager/screens/sales_manager_drawer.dart';
import './admin_drawer.dart';
import 'package:flutter/material.dart';
import '../controllers/generate_reports.dart';
import '../../constants/colors.dart';
import 'report_details.dart';

class GenerateReportsScreen extends StatefulWidget {
  final String role;
  const GenerateReportsScreen({super.key, required this.role});

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

  // Render a structured, line-by-line view of the report details (Map/List/primitive)
  Widget _buildDetailsSection(dynamic data, {int indent = 0}) {
    if (data == null) {
      return const Text('No details available');
    }

    if (data is Map) {
      final entries = data.entries.toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: entries.map((e) {
          final key = e.key?.toString() ?? '';
          final value = e.value;
          final isComplex = value is Map || value is List;
          return Padding(
            padding: EdgeInsets.only(left: (indent > 0 ? 12.0 : 0.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isComplex)
                  _labelValue(key, _primitiveToString(value))
                else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Text(
                      _titleCase(key),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildDetailsSection(value, indent: indent + 1),
                  const SizedBox(height: 6),
                ],
              ],
            ),
          );
        }).toList(),
      );
    }

    if (data is List) {
      if (data.isEmpty) return const Text('—');
      // If list of maps, render each item as a card-like block
      final isListOfMaps = data.every((el) => el is Map);
      if (isListOfMaps) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(data.length, (index) {
            final map = Map<String, dynamic>.from(data[index] as Map);
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildDetailsSection(map, indent: indent + 1),
            );
          }),
        );
      }
      // Otherwise render as bullet list
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.map<Widget>((el) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• '),
                Expanded(child: Text(_primitiveToString(el))),
              ],
            ),
          );
        }).toList(),
      );
    }

    // Primitive
    return Text(_primitiveToString(data));
  }

  Widget _labelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              _titleCase(label),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _primitiveToString(dynamic v) {
    if (v == null) return '—';
    if (v is num || v is bool) return v.toString();
    return v.toString();
  }

  String _titleCase(String input) {
    if (input.isEmpty) return input;
    return input.replaceAllMapped(RegExp(r'(^|_|-|\s)([a-z])'), (m) => '${m[1] ?? ''}${m[2]!.toUpperCase()}')
        .replaceAll('_', ' ')
        .replaceAll('-', ' ');
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
            title: const Text('Reports'),
            backgroundColor: AppColors.primaryBlue,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'Refresh',
                icon: const Icon(Icons.refresh),
                onPressed: controller.isLoading ? null : () => controller.loadAllReports(),
              ),
            ],
          ),
          drawer: widget.role == "admin" ? const AdminDrawer() : const SalesManagerDrawer(),
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            controller.selectedType == 'sales'
                                ? 'Revenue: ₹${controller.totalAmount.toStringAsFixed(2)}'
                                : 'Total: ₹${controller.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Individual report filters
                if (controller.selectedType == 'individual')
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // User ID
                            Expanded(
                              child: TextField(
                                controller: controller.individualUserIdController,
                                decoration: const InputDecoration(
                                  labelText: 'User Name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Report type
                            DropdownButton<String>(
                              value: controller.individualReportType,
                              items: const [
                                DropdownMenuItem(value: 'performance', child: Text('Performance')),
                                DropdownMenuItem(value: 'sales', child: Text('Sales')),
                                DropdownMenuItem(value: 'attendance', child: Text('Attendance')),
                                DropdownMenuItem(value: 'points', child: Text('Points')),
                              ],
                              onChanged: (val) {
                                if (val == null) return;
                                setState(() {
                                  controller.individualReportType = val;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: controller.isLoading
                              ? null
                              : () {
                            controller.fetchIndividualReport();
                          },
                          child: const Text('Fetch Report'),
                        ),
                      ],
                    ),
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
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ReportDetailsScreen(report: report),
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