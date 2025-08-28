import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class PointsDisplay extends StatelessWidget {
  final List<dynamic>? points;

  const PointsDisplay({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points == null || points!.isEmpty) {
      return const Center(child: Text('No points transactions found.'));
    }

    return ListView.separated(
      itemCount: points!.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final txn = points![index];

        final txnPoints = txn['points']?.toString() ?? '';
        final creditAmount = txn['creditAmount']?.toString() ?? '0';
        final reason = txn['reason'] ?? 'No reason provided';
        final date = txn['date'] != null
            ? DateTime.parse(txn['date']).toLocal().toString()
            : 'Unknown date';
        final type = txn['type'] ?? 'Unknown type';

        return Card(
          color: AppColors.backgroundGray,
          child: ListTile(
            title: Text(
              'Points: $txnPoints',
              style: const TextStyle(
                  color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Converted Amount: $creditAmount',
                    style: const TextStyle(color: AppColors.textPrimary)),
                Text('Date: $date',
                    style: const TextStyle(color: AppColors.textPrimary)),
                Text('Reason: $reason',
                    style: const TextStyle(color: AppColors.textPrimary)),
                Text('Type: $type',
                    style: const TextStyle(color: AppColors.textPrimary)),
              ],
            ),
          ),
        );
      },
    );
  }
}
