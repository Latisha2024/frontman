import 'package:flutter/material.dart';
import '../controllers/points.dart';
import '../widgets/points.dart';
import '../../constants/colors.dart';
import './plumber_drawer.dart';

class PlumberPointsScreen extends StatefulWidget {
  const PlumberPointsScreen({super.key});

  @override
  State<PlumberPointsScreen> createState() => _PlumberPointsScreenState();
}

class _PlumberPointsScreenState extends State<PlumberPointsScreen> {
  final controller = PlumberPointsController();

  @override
  void initState() {
    super.initState();
    controller.fetchPoints(); // automatically fetch on screen open
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
        title: const Text('My Points'),
        backgroundColor: AppColors.primaryBlue,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
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
            return PointsDisplay(points: controller.points);
          },
        ),
      ),
    );
  }
}
