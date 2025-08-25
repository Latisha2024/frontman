import 'package:flutter/material.dart';
import '../../constants/colors.dart'; // Ensure this contains all the used AppColors

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data
    const String latitude = "12.9716° N";
    const String longitude = "77.5946° E";
    const String timestamp = "2025-07-31 18:45:00";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Status",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
        ),
        backgroundColor: AppColors.primaryBlue,
        elevation: 2,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          color: AppColors.primaryBlue,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "GPS Tracking Status",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 16),
                const Icon(Icons.location_on, color: AppColors.textLight, size: 50),
                const SizedBox(height: 12),
                const Text(
                  "Latest Location Data",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(color: AppColors.textLight),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    "Latitude: $latitude\nLongitude: $longitude\nTimestamp: $timestamp",
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
