import 'package:flutter/material.dart';
import '../controllers/incentives.dart';
import '../widgets/incentives.dart';
import '../../constants/colors.dart';
import './plumber_drawer.dart';

class PlumberIncentivesScreen extends StatefulWidget {
  const PlumberIncentivesScreen({super.key});

  @override
  State<PlumberIncentivesScreen> createState() =>
      _PlumberIncentivesScreenState();
}

class _PlumberIncentivesScreenState extends State<PlumberIncentivesScreen> {
  final controller = PlumberIncentivesController();

  void handleFetch() {
    controller.fetchIncentives();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Incentives'),
        backgroundColor: AppColors.primaryBlue,
      ),
      drawer: PlumberDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: controller.isLoading ? null : handleFetch,
                  child: controller.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Fetch Incentives'),
                ),
                const SizedBox(height: 24),
                if (controller.error != null)
                  Text(controller.error!,
                      style: const TextStyle(color: Colors.red)),
                Expanded(
                  child:
                      IncentivesList(incentives: controller.incentives ?? []),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
