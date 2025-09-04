// // import 'package:flutter/material.dart';
// // import '../../constants/colors.dart';

// // class IncentivesList extends StatelessWidget {
// //   final List<dynamic> incentives;
// //   const IncentivesList({super.key, required this.incentives});

// //   @override
// //   Widget build(BuildContext context) {
// //     if (incentives.isEmpty) {
// //       return const Center(child: Text('No incentives.'));
// //     }
// //     return ListView.separated(
// //       itemCount: incentives.length,
// //       separatorBuilder: (_, __) => const SizedBox(height: 8),
// //       itemBuilder: (context, index) {
// //         final incentive = incentives[index];
// //         return Card(
// //           color: AppColors.backgroundGray,
// //           child: ListTile(
// //             title: Text(
// //               incentive['description']?.toString() ?? '',
// //               style: const TextStyle(
// //                   color: AppColors.textPrimary, fontWeight: FontWeight.bold),
// //             ),
// //             subtitle: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text('Points: ${incentive['points']?.toString() ?? ''}',
// //                     style: const TextStyle(color: AppColors.textPrimary)),
// //                 if (incentive['assignedAt'] != null)
// //                   Text('Assigned At: ${incentive['assignedAt']}',
// //                       style: const TextStyle(color: AppColors.textPrimary)),
// //                 if (incentive['assignedAt'] != null)
// //                   Text('Assigned At: ${incentive['assignedAt']}',
// //                       style: const TextStyle(color: AppColors.textPrimary)),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import '../../constants/colors.dart';

// class IncentivesList extends StatelessWidget {
//   final List<dynamic> incentives;
//   const IncentivesList({super.key, required this.incentives});

//   @override
//   Widget build(BuildContext context) {
//     if (incentives.isEmpty) {
//       return const Center(child: Text('No incentives.'));
//     }
//     return ListView.separated(
//       itemCount: incentives.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 8),
//       itemBuilder: (context, index) {
//         final incentive = incentives[index];
//         return Card(
//           color: AppColors.backgroundGray,
//           child: ListTile(
//             title: Text(
//               incentive['description']?.toString() ?? '',
//               style: const TextStyle(
//                 color: AppColors.textPrimary,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Points: ${incentive['points']?.toString() ?? ''}',
//                     style: const TextStyle(color: AppColors.textPrimary)),
//                 if (incentive['assignedAt'] != null)
//                   Text('Assigned At: ${incentive['assignedAt']}',
//                       style: const TextStyle(color: AppColors.textPrimary)),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ✅ added for date formatting
import '../../constants/colors.dart';

class IncentivesList extends StatelessWidget {
  final List<dynamic> incentives;
  const IncentivesList({super.key, required this.incentives});

  @override
  Widget build(BuildContext context) {
    if (incentives.isEmpty) {
      return const Center(child: Text('No incentives.'));
    }

    return ListView.separated(
      itemCount: incentives.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final incentive = incentives[index];

        // ✅ Format assignedAt properly
        String? assignedAtFormatted;
        if (incentive['assignedAt'] != null) {
          try {
            final dt = DateTime.parse(incentive['assignedAt'].toString());
            assignedAtFormatted = DateFormat.yMMMd().add_jm().format(dt);
          } catch (_) {
            assignedAtFormatted = incentive['assignedAt'].toString();
          }
        }

        return Card(
          color: AppColors.backgroundGray,
          child: ListTile(
            title: Text(
              incentive['description']?.toString() ?? '',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Points: ${incentive['points']?.toString() ?? ''}',
                    style: const TextStyle(color: AppColors.textPrimary)),
                if (assignedAtFormatted != null)
                  Text('Assigned At: $assignedAtFormatted',
                      style: const TextStyle(color: AppColors.textPrimary)),
              ],
            ),
          ),
        );
      },
    );
  }
}
