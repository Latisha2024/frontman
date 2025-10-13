import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/colors.dart';
import '../url.dart';
import 'dart:math' as math;

class CompanyPerformanceCard extends StatefulWidget {
  const CompanyPerformanceCard({super.key});

  @override
  State<CompanyPerformanceCard> createState() => _CompanyPerformanceCardState();
}

class _CompanyPerformanceCardState extends State<CompanyPerformanceCard> {
  late final Dio _dio;
  bool _loading = true;
  String? _error;
  List<_BarDatum> _topProducts = [];

  @override
  void initState() {
    super.initState();
    _initDio();
    _load();
  }

  void _initDio() {
    _dio = Dio(BaseOptions(
      baseUrl: BaseUrl.b_url,
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      headers: {'Content-Type': 'application/json'},
    ));
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    }));
  }

  Future<void> _load() async {
    try {
      setState(() { _loading = true; _error = null; });
      final res = await _dio.get('/admin/reports/performance');
      final data = res.data as Map<String, dynamic>;
      final topProducts = (data['topProducts'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
      _topProducts = topProducts
          .map((e) => _BarDatum(
                label: (e['productName'] ?? 'Unknown') as String,
                value: (e['totalSold'] ?? 0).toDouble(),
              ))
          .toList();
    } catch (e) {
      _error = 'Failed to load performance';
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.accentBlue, width: 1.2),
      ),
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bar_chart, color: AppColors.primaryBlue),
                const SizedBox(width: 8),
                const Text(
                  'Company Performance',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Refresh',
                  onPressed: _load,
                  icon: const Icon(Icons.refresh),
                )
              ],
            ),
            const SizedBox(height: 12),
            if (_loading)
              const SizedBox(height: 160, child: Center(child: CircularProgressIndicator()))
            else if (_error != null)
              SizedBox(
                height: 160,
                child: Center(
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              )
            else if (_topProducts.isEmpty)
              const SizedBox(
                height: 160,
                child: Center(child: Text('No data yet')),
              )
            else
              SizedBox(height: 220, child: _buildBarChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    final peak = _topProducts
        .map((e) => e.value)
        .fold<double>(0.0, (p, c) => c > p ? c : p);
    final maxY = math.max(1.0, peak * 1.2);
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= _topProducts.length) return const SizedBox.shrink();
                final label = _topProducts[idx].label;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Flexible(
                    child: Text(
                      label,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (int i = 0; i < _topProducts.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: _topProducts[i].value,
                  color: AppColors.primaryBlue,
                  width: 18,
                  borderRadius: BorderRadius.circular(4),
                )
              ],
            )
        ],
        maxY: maxY,
      ),
    );
  }
}

class _BarDatum {
  final String label;
  final double value;
  _BarDatum({required this.label, required this.value});
}
