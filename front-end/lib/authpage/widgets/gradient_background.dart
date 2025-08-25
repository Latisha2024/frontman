import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  
  const GradientBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.accent.withOpacity(0.3),
            AppColors.background,
          ],
        ),
      ),
      child: child,
    );
  }
}
