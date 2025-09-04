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

  @override
  void initState() {
    super.initState();
    controller.fetchIncentives(); // ✅ auto-fetch when screen loads
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
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.error != null) {
              return Center(
                child: Text(controller.error!,
                    style: const TextStyle(color: Colors.red)),
              );
            }

            return IncentivesList(incentives: controller.incentives ?? []);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.buttonPrimary,
        onPressed: controller.fetchIncentives,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
