import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../controllers/generate_reports.dart';

class ReportDetailsScreen extends StatelessWidget {
  final ReportData report;
  const ReportDetailsScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(report.title),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              report.description,
              style: const TextStyle(fontSize: 16),
            ),
            if (report.userName != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, color: AppColors.primaryBlue, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'User: ${report.userName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  '${report.date.year}-${report.date.month.toString().padLeft(2, '0')}-${report.date.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildDetailsSection(report.details),
          ],
        ),
      ),
    );
  }

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

    return Text(_primitiveToString(data));
  }

  Widget _labelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              _titleCase(label),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
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
    return input
        .replaceAllMapped(RegExp(r'(^|_|-|\s)([a-z])'), (m) => '${m[1] ?? ''}${m[2]!.toUpperCase()}')
        .replaceAll('_', ' ')
        .replaceAll('-', ' ');
  }
}
