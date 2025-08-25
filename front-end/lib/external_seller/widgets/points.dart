import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class PointsDisplay extends StatelessWidget {
  final dynamic points;
  const PointsDisplay({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points == null) {
      return const Center(child: Text('No points data.'));
    }
    if (points is List) {
      if (points.isEmpty) {
        return const Center(child: Text('No points entries.'));
      }
      return ListView.separated(
        itemCount: points.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final entry = points[index];
          return Card(
            color: AppColors.backgroundGray,
            child: ListTile(
              title: Text(
                'Points: ${entry['points']?.toString() ?? ''}',
                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (entry['convertedAmount'] != null)
                    Text('Converted Amount: ${entry['convertedAmount']}', style: const TextStyle(color: AppColors.textPrimary)),
                  if (entry['date'] != null)
                    Text('Date: ${entry['date']}', style: const TextStyle(color: AppColors.textPrimary)),
                  if (entry['reason'] != null)
                    Text('Reason: ${entry['reason']}', style: const TextStyle(color: AppColors.textPrimary)),
                  if (entry['type'] != null)
                    Text('Type: ${entry['type']}', style: const TextStyle(color: AppColors.textPrimary)),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return Card(
        color: AppColors.backgroundGray,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Text(
              points.toString(),
              style: const TextStyle(fontSize: 32, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }
  }
} 