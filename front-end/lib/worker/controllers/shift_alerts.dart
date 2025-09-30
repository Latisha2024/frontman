import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class ShiftAlert {
  final String id;
  final String message;
  final DateTime createdAt;
  bool acknowledged;

  ShiftAlert({
    required this.id,
    required this.message,
    required this.createdAt,
    this.acknowledged = false,
  });

  factory ShiftAlert.fromJson(Map<String, dynamic> json) {
    return ShiftAlert(
      id: json['_id'] ?? json['id'],
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      acknowledged: json['acknowledged'] ?? false,
    );
  }
}

class WorkerShiftAlertsController extends ChangeNotifier {
  List<ShiftAlert> shiftAlerts = [];
  bool loading = true;
  late Dio dio;
  Timer? _timer;

  WorkerShiftAlertsController() {
    _init();
  }

  Future<void> _init() async {
    loading = true;
    notifyListeners();

    try {
      final token = await AuthService().getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Auth token not found');
      }

      dio = Dio(BaseOptions(
        baseUrl: 'https://frontman-backend-2.onrender.com', // backend URL
        headers: {'Authorization': 'Bearer $token'},
      ));

      await fetchAlerts();

      // Auto-refresh every 30 seconds
      _timer = Timer.periodic(const Duration(seconds: 30), (_) async {
        await fetchAlerts();
      });
    } catch (e) {
      print('Error initializing ShiftAlertsController: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAlerts() async {
    try {
      final token = await AuthService().getToken();
      if (token == null || token.isEmpty) {
        print('No token found for fetching alerts');
        return;
      }

      dio.options.headers['Authorization'] = 'Bearer $token';

      loading = true;
      notifyListeners();

      final response = await dio.get('/worker/shift-alerts');
      shiftAlerts =
          (response.data as List).map((e) => ShiftAlert.fromJson(e)).toList();
    } on DioException catch (e) {
      print(
          'Error fetching shift alerts: ${e.response?.statusCode} ${e.response?.data}');
    } catch (e) {
      print('Unexpected error fetching shift alerts: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> acknowledgeAlert(String id) async {
    try {
      final token = await AuthService().getToken();
      if (token == null || token.isEmpty) return;

      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put('/worker/shift-alerts/$id/acknowledge');

      final index = shiftAlerts.indexWhere((element) => element.id == id);
      if (index != -1) {
        shiftAlerts[index].acknowledged = true;
        notifyListeners();
      }
    } catch (e) {
      print('Error acknowledging alert: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
