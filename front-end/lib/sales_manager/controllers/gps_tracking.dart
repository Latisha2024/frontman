import 'package:flutter/material.dart';

class SalesManagerGpsTrackingController extends ChangeNotifier {
  List<Map<String, dynamic>> executives = [
    {'id': '1', 'name': 'Abi', 'location': 'Lat: 12.97, Lon: 77.59', 'lastUpdated': DateTime.now()},
    {'id': '2', 'name': 'Rahul', 'location': 'Lat: 13.01, Lon: 77.60', 'lastUpdated': DateTime.now()},
    {'id': '3', 'name': 'Vimal', 'location': 'Lat: 12.99, Lon: 77.58', 'lastUpdated': DateTime.now()},
  ];
} 