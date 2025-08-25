import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class ExecutiveLocationTile extends StatelessWidget {
  final Map<String, dynamic> executive;
  const ExecutiveLocationTile({super.key, required this.executive});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: const Icon(Icons.person_pin_circle, color: AppColors.textPrimary),
        title: Text(executive['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(executive['location'] ?? 'No location'),
        trailing: Text(
          executive['lastUpdated'] != null ? 'Updated: ${executive['lastUpdated'].hour}:${executive['lastUpdated'].minute.toString().padLeft(2, '0')}' : '',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
} 