import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/attendance.dart';

class WorkerAttendanceScreen extends StatefulWidget {
  const WorkerAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<WorkerAttendanceScreen> createState() => _WorkerAttendanceScreenState();
}

class _WorkerAttendanceScreenState extends State<WorkerAttendanceScreen> {
  final AttendanceController _controller = AttendanceController();

  // Compute current formatted date dynamically using intl package
  String get todayDateFormatted =>
      DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

  // Dummy data for now; replace with API call responses
  final String totalHoursToday = "5 hrs 30 mins"; // Endpoint #2
  final String lastAttendanceSummary =
      "Last checked in on August 9, 2025 at 9:05 AM"; // Endpoint #3
  final int attendanceStreak = 4; // Endpoint #4
  final String nextBreakInfo = "Next break at 3:00 PM"; // Endpoint #7

  @override
  void initState() {
    super.initState();

    // Show a SnackBar on page load if user already checked in today
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.isCheckedIn) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Today's log recorded. System log resets next working day.",
            ),
            duration: Duration(seconds: 4),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Worker Attendance')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 2. Today's Date & Weekday
                Text(
                  'Attendance for $todayDateFormatted',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // 1. Total hours worked today (only if checked out)
                if (_controller.checkInTime != null &&
                    _controller.checkOutTime != null)
                  Text(
                    'Total hours worked: $totalHoursToday',
                    style: const TextStyle(fontSize: 16),
                  ),

                const SizedBox(height: 20),

                // 3. Last Attendance Summary
                Text(
                  lastAttendanceSummary,
                  style: const TextStyle(
                      fontSize: 14, fontStyle: FontStyle.italic),
                ),

                const SizedBox(height: 12),

                // 4. Attendance Streak
                Text(
                  'Attendance streak: $attendanceStreak days',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 20),

                // 7. Next Break Info
                Card(
                  color: Colors.blue.shade50,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          nextBreakInfo,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // 6. Buttons and Status Messages with updated UI
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _controller.isCheckedIn ? Colors.green : null,
                  ),
                  onPressed: () {
                    if (_controller.isCheckedIn) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'You have already checked in at ${_controller.formattedCheckInTime}'),
                        ),
                      );
                      return;
                    }
                    setState(() {
                      _controller.checkIn();
                    });
                  },
                  child: Text(
                    _controller.isCheckedIn ? 'Checked In' : 'Check In',
                    style: TextStyle(
                      color: _controller.isCheckedIn ? Colors.white : null,
                    ),
                  ),
                ),
                if (_controller.isCheckedIn) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Successfully checked in at ${_controller.formattedCheckInTime}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],

                const SizedBox(height: 40),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _controller.isCheckedOut ? Colors.black : null,
                  ),
                  onPressed: () {
                    if (!_controller.isCheckedIn) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('You need to check in first!'),
                        ),
                      );
                      return;
                    }
                    if (_controller.isCheckedOut) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'You have already checked out at ${_controller.formattedCheckOutTime}'),
                        ),
                      );
                      return;
                    }
                    setState(() {
                      _controller.checkOut();
                    });
                  },
                  child: Text(
                    _controller.isCheckedOut ? 'Checked Out' : 'Check Out',
                    style: TextStyle(
                      color: _controller.isCheckedOut ? Colors.white : null,
                    ),
                  ),
                ),
                if (_controller.isCheckedOut) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Successfully checked out at ${_controller.formattedCheckOutTime}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
