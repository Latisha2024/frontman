import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../admin/url.dart' as admin_url;
import '../../admin/user_lookup.dart';

class SalesManagerAssignTasksController extends ChangeNotifier {
  List<Map<String, dynamic>> tasks = [];

  void addTask({required String executiveId, required String title, required String description, required DateTime dueDate}) {
    tasks.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'executiveId': executiveId,
      'title': title,
      'description': description,
      'dueDate': dueDate,
    });
    notifyListeners();
  }

  Dio _buildDio() {
    return Dio(BaseOptions(
      baseUrl: admin_url.BaseUrl.b_url,
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  Future<void> _attachAuth(Dio dio) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null && token.isNotEmpty) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<void> submitTaskByExecutiveName({
    required String executiveName,
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    final userId = await UserLookup.resolveUserIdByName(executiveName);
    if (userId == null) {
      throw Exception('The given user name was not a Field Executive');
    }

    final dio = _buildDio();
    await _attachAuth(dio);

    final body = {
      'title': title,
      'description': description,
      'dueDate': dueDate.toUtc().toIso8601String(),
      'executiveUserId': userId,
    };

    try {
      final resp = await dio.post('/fieldExecutive/task', data: body);
      if (resp.statusCode != 201) {
        throw Exception('Failed to create task');
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final serverMsg = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message']?.toString())
          : null;
      if (status == 400 && (serverMsg?.contains('Invalid executiveUserId') ?? false)) {
        throw Exception('The given user name was not a Field Executive');
      }
      throw Exception(serverMsg ?? 'Failed to create task');
    }

    addTask(
      executiveId: userId,
      title: title,
      description: description,
      dueDate: dueDate,
    );
  }
  Future<void> loadAllTasks() async {
    final dio = _buildDio();
    await _attachAuth(dio);

    final resp = await dio.get('/fieldExecutive/task');
    if (resp.statusCode == 200 && resp.data is List) {
      final List list = resp.data as List;
      tasks
        ..clear()
        ..addAll(list.map<Map<String, dynamic>>((e) {
          final m = e as Map<String, dynamic>;
          return {
            'id': (m['id'] ?? '').toString(),
            'executiveId': (m['executiveId'] ?? '').toString(),
            'title': (m['title'] ?? '').toString(),
            'description': (m['description'] ?? '').toString(),
            'dueDate': m['dueDate'] != null
                ? DateTime.tryParse(m['dueDate'].toString()) ?? DateTime.now()
                : DateTime.now(),
            'priority': 'Normal',
            'status': (m['status'] ?? 'Pending').toString(),
          };
        }));
      notifyListeners();
    } else {
      throw Exception('Failed to load tasks (${resp.statusCode}): ${resp.data}');
    }
  }

  Future<void> updateTaskRemote({
    required String taskId,
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    final dio = _buildDio();
    await _attachAuth(dio);
    final resp = await dio.put(
      '/fieldExecutive/task/$taskId',
      data: {
        'title': title,
        'description': description,
        'dueDate': dueDate.toUtc().toIso8601String(),
      },
    );
    if (resp.statusCode == 200) {
      final idx = tasks.indexWhere((t) => t['id'] == taskId);
      if (idx != -1) {
        tasks[idx] = {
          ...tasks[idx],
          'title': title,
          'description': description,
          'dueDate': dueDate,
        };
        notifyListeners();
      }
    } else {
      throw Exception('Failed to update task (${resp.statusCode}): ${resp.data}');
    }
  }

  Future<void> deleteTaskRemote(String taskId) async {
    final dio = _buildDio();
    await _attachAuth(dio);
    final resp = await dio.delete('/fieldExecutive/task/$taskId');
    if (resp.statusCode == 200) {
      tasks.removeWhere((t) => t['id'] == taskId);
      notifyListeners();
    } else {
      throw Exception('Failed to delete task (${resp.statusCode}): ${resp.data}');
    }
  }

  Future<void> loadTasksByExecutiveName(String executiveName) async {
    final userId = await UserLookup.resolveUserIdByName(executiveName);
    if (userId == null) {
      throw Exception('Executive "$executiveName" not found');
    }

    final dio = _buildDio();
    await _attachAuth(dio);

    final resp = await dio.get(
      '/fieldExecutive/task',
      queryParameters: {'executiveUserId': userId},
    );

    if (resp.statusCode == 200 && resp.data is List) {
      final List list = resp.data as List;
      tasks
        ..clear()
        ..addAll(list.map<Map<String, dynamic>>((e) {
          final m = e as Map<String, dynamic>;
          return {
            'id': (m['id'] ?? '').toString(),
            'executiveId': userId,
            'title': (m['title'] ?? '').toString(),
            'description': (m['description'] ?? '').toString(),
            'dueDate': m['dueDate'] != null
                ? DateTime.tryParse(m['dueDate'].toString()) ?? DateTime.now()
                : DateTime.now(),
          };
        }));
      notifyListeners();
    } else {
      throw Exception('Failed to load tasks (${resp.statusCode}): ${resp.data}');
    }
  }
}