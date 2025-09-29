// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../controllers/attendance.dart';

// class WorkerAttendanceScreen extends StatelessWidget {
//   const WorkerAttendanceScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => AttendanceController(),
//       child: Consumer<AttendanceController>(
//         builder: (context, controller, _) {
//           final todayDateFormatted =
//               DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Worker Attendance'),
//               centerTitle: true,
//             ),
//             body: controller.loading
//                 ? const Center(child: CircularProgressIndicator())
//                 : RefreshIndicator(
//                     onRefresh: () async {
//                       await controller.fetchTodayAttendance();
//                       await controller.fetchAttendanceHistory();
//                     },
//                     child: SingleChildScrollView(
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Attendance for $todayDateFormatted',
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           if (controller.checkInTime != null)
//                             Text(
//                               "Checked in at: ${DateFormat('hh:mm a').format(controller.checkInTime!)}",
//                               style: const TextStyle(
//                                 color: Colors.green,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           if (controller.checkOutTime != null)
//                             Text(
//                               "Checked out at: ${DateFormat('hh:mm a').format(controller.checkOutTime!)}",
//                               style: const TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           if (controller.totalHoursToday != null)
//                             Text(
//                               "Total worked: ${controller.totalHoursToday}",
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                           const SizedBox(height: 20),
//                           Text(
//                             'Attendance streak: ${controller.attendanceStreak} days',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 16,
//                             ),
//                           ),
//                           const SizedBox(height: 40),
//                           ElevatedButton(
//                             onPressed: controller.isCheckedOut
//                                 ? null
//                                 : () async {
//                                     try {
//                                       await controller.markAttendance();
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(SnackBar(
//                                               content: Text(controller
//                                                       .isCheckedIn
//                                                   ? 'Checked in successfully!'
//                                                   : 'Checked out successfully!')));
//                                     } catch (e) {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(SnackBar(
//                                               content: Text('Error: $e')));
//                                     }
//                                   },
//                             style: ElevatedButton.styleFrom(
//                               minimumSize: const Size(180, 50),
//                             ),
//                             child: Text(
//                               controller.isCheckedOut
//                                   ? "Already Checked Out"
//                                   : controller.isCheckedIn
//                                       ? "Check Out"
//                                       : "Check In",
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/attendancE.dart';

class WorkerAttendanceScreen extends StatelessWidget {
  const WorkerAttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AttendanceController(),
      child: Consumer<AttendanceController>(
        builder: (context, controller, _) {
          final todayDateFormatted =
              DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

          return Scaffold(
            appBar: AppBar(
              title: const Text('Worker Attendance'),
              centerTitle: true,
            ),
            body: controller.loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchTodayAttendance();
                      await controller.fetchAttendanceHistory();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Attendance for $todayDateFormatted',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (controller.checkInTime != null)
                            Text(
                              "Checked in at: ${DateFormat('hh:mm a').format(controller.checkInTime!)}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          if (controller.checkOutTime != null)
                            Text(
                              "Checked out at: ${DateFormat('hh:mm a').format(controller.checkOutTime!)}",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          if (controller.totalHoursToday != null)
                            Text(
                              "Total worked: ${controller.totalHoursToday}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          const SizedBox(height: 16),
                          Text(
                            'Attendance streak: ${controller.attendanceStreak} days',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: controller.isCheckedOut
                                ? null
                                : () async {
                                    try {
                                      await controller.markAttendance();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(controller.isCheckedIn
                                            ? 'Checked in successfully!'
                                            : 'Checked out successfully!'),
                                      ));
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text('Error: $e')));
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(180, 50),
                            ),
                            child: Text(
                              controller.isCheckedOut
                                  ? "Already Checked Out"
                                  : controller.isCheckedIn
                                      ? "Check Out"
                                      : "Check In",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Divider(),
                          const SizedBox(height: 10),
                          Text(
                            'Past Attendance Records',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.pastRecords.length,
                            itemBuilder: (context, index) {
                              final record = controller.pastRecords[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  title: Text(
                                      "${DateFormat('dd MMM yyyy').format(record.date)}"),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Check In: ${DateFormat('hh:mm a').format(record.checkIn)}"),
                                      Text(record.checkOut != null
                                          ? "Check Out: ${DateFormat('hh:mm a').format(record.checkOut!)}"
                                          : "Check Out: -"),
                                      Text("Total: ${record.totalHours}"),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
