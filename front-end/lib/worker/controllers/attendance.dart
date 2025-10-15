// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import '../../authpage/pages/auth_services.dart';

// class AttendanceRecord {
//   final DateTime date;
//   final DateTime checkIn;
//   final DateTime? checkOut;
//   final String totalHours;

//   AttendanceRecord({
//     required this.date,
//     required this.checkIn,
//     this.checkOut,
//     required this.totalHours,
//   });

//   factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
//     DateTime checkInTime = DateTime.parse(json['checkIn']);
//     DateTime? checkOutTime =
//         json['checkOut'] != null ? DateTime.parse(json['checkOut']) : null;
//     String total = checkOutTime != null
//         ? "${checkOutTime.difference(checkInTime).inHours} hrs ${checkOutTime.difference(checkInTime).inMinutes % 60} mins"
//         : "-";
//     return AttendanceRecord(
//       date: DateTime.parse(json['date']),
//       checkIn: checkInTime,
//       checkOut: checkOutTime,
//       totalHours: total,
//     );
//   }
// }

// class AttendanceController extends ChangeNotifier {
//   DateTime? checkInTime;
//   DateTime? checkOutTime;
//   String? totalHoursToday;
//   int attendanceStreak = 0;
//   String? nextBreakInfo;

//   List<AttendanceRecord> pastRecords = [];

//   bool loading = true;
//   late Dio dio;
//   Timer? _timer;

//   AttendanceController() {
//     _init();
//   }

//   Future<void> _init() async {
//     loading = true;
//     notifyListeners();

//     try {
//       final token = await AuthService().getToken();
//       if (token == null || token.isEmpty) throw Exception('Auth token not found');

//       dio = Dio(BaseOptions(
//         baseUrl: 'http://localhost:5001', // replace with your backend
//         headers: {'Authorization': 'Bearer $token'},
//       ));

//       await fetchTodayAttendance();
//       await fetchAttendanceHistory();

//       _timer = Timer.periodic(const Duration(seconds: 60), (_) async {
//         await fetchTodayAttendance();
//         await fetchAttendanceHistory();
//       });
//     } catch (e) {
//       print('Error initializing AttendanceController: $e');
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> fetchTodayAttendance() async {
//     try {
//       final token = await AuthService().getToken();
//       if (token == null || token.isEmpty) return;

//       dio.options.headers['Authorization'] = 'Bearer $token';
//       final response = await dio.get('/worker/attendance/today');

//       if (response.statusCode == 200) {
//         final data = response.data;
//         checkInTime = DateTime.parse(data['checkIn']);
//         if (data['checkOut'] != null) {
//           checkOutTime = DateTime.parse(data['checkOut']);
//           final diff = checkOutTime!.difference(checkInTime!);
//           totalHoursToday = "${diff.inHours} hrs ${diff.inMinutes % 60} mins";
//         }
//       }
//     } catch (e) {
//       print('Error fetching today attendance: $e');
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> markAttendance() async {
//     try {
//       final token = await AuthService().getToken();
//       if (token == null || token.isEmpty) return;

//       dio.options.headers['Authorization'] = 'Bearer $token';
//       final response = await dio.post('/worker/attendance');

//       if (response.statusCode == 201 || response.statusCode == 200) {
//         await fetchTodayAttendance();
//         await fetchAttendanceHistory();
//       }
//     } catch (e) {
//       print('Error marking attendance: $e');
//     }
//   }

//   Future<void> fetchAttendanceHistory() async {
//     try {
//       final token = await AuthService().getToken();
//       if (token == null || token.isEmpty) return;

//       dio.options.headers['Authorization'] = 'Bearer $token';
//       final response = await dio.get('/worker/attendance');

//       if (response.statusCode == 200) {
//         final records = response.data as List;
//         attendanceStreak = records.where((r) => r['checkIn'] != null).length;

//         pastRecords = records.map((e) => AttendanceRecord.fromJson(e)).toList();
//       }
//     } catch (e) {
//       print('Error fetching attendance history: $e');
//     } finally {
//       notifyListeners();
//     }
//   }

//   bool get isCheckedIn => checkInTime != null && checkOutTime == null;
//   bool get isCheckedOut => checkInTime != null && checkOutTime != null;

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class AttendanceRecord {
  final DateTime date;
  final DateTime checkIn;
  final DateTime? checkOut;
  final String totalHours;

  AttendanceRecord({
    required this.date,
    required this.checkIn,
    this.checkOut,
    required this.totalHours,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    DateTime checkInTime = DateTime.parse(json['checkIn']);
    DateTime? checkOutTime =
        json['checkOut'] != null ? DateTime.parse(json['checkOut']) : null;
    String total = checkOutTime != null
        ? "${checkOutTime.difference(checkInTime).inHours} hrs ${checkOutTime.difference(checkInTime).inMinutes % 60} mins"
        : "-";
    return AttendanceRecord(
      date: DateTime.parse(json['date']),
      checkIn: checkInTime,
      checkOut: checkOutTime,
      totalHours: total,
    );
  }
}

class AttendanceController extends ChangeNotifier {
  DateTime? checkInTime;
  DateTime? checkOutTime;
  String? totalHoursToday;
  int attendanceStreak = 0;
  String? nextBreakInfo;

  List<AttendanceRecord> pastRecords = [];

  bool loading = true;
  late Dio dio;
  Timer? _timer;

  AttendanceController() {
    _init();
  }

  Future<void> _init() async {
    loading = true;
    notifyListeners();

    try {
      final token = await AuthService().getToken();
      if (token == null || token.isEmpty)
        throw Exception('Auth token not found');

      dio = Dio(BaseOptions(
        baseUrl: 'http://localhost:5001', // replace with your backend
        headers: {'Authorization': 'Bearer $token'},
      ));

      await fetchTodayAttendance();
      await fetchAttendanceHistory();

      _timer = Timer.periodic(const Duration(seconds: 60), (_) async {
        await fetchTodayAttendance();
        await fetchAttendanceHistory();
      });
    } catch (e) {
      print('Error initializing AttendanceController: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTodayAttendance() async {
    try {
      final token = await AuthService().getToken();
      if (token == null || token.isEmpty) return;

      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get('/worker/attendance/today');

      if (response.statusCode == 200) {
        final data = response.data;
        checkInTime = DateTime.parse(data['checkIn']);
        if (data['checkOut'] != null) {
          checkOutTime = DateTime.parse(data['checkOut']);
          final diff = checkOutTime!.difference(checkInTime!);
          totalHoursToday = "${diff.inHours} hrs ${diff.inMinutes % 60} mins";
        }
      }
    } catch (e) {
      print('Error fetching today attendance: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> markAttendance() async {
    try {
      final token = await AuthService().getToken();
      if (token == null || token.isEmpty) return;

      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.post('/worker/attendance');

      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchTodayAttendance();
        await fetchAttendanceHistory();
      }
    } catch (e) {
      print('Error marking attendance: $e');
    }
  }

  Future<void> fetchAttendanceHistory() async {
    try {
      final token = await AuthService().getToken();
      if (token == null || token.isEmpty) return;

      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get('/worker/attendance');

      if (response.statusCode == 200) {
        final records = response.data as List;
        attendanceStreak = records.where((r) => r['checkIn'] != null).length;

        pastRecords = records.map((e) => AttendanceRecord.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error fetching attendance history: $e');
    } finally {
      notifyListeners();
    }
  }

  bool get isCheckedIn => checkInTime != null && checkOutTime == null;
  bool get isCheckedOut => checkInTime != null && checkOutTime != null;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
