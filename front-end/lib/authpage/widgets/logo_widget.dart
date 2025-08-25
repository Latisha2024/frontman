import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class LogoWidget extends StatelessWidget {
  final double size;
  
  const LogoWidget({
    Key? key,
    this.size = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(size / 4),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.business,
        size: size * 0.5,
        color: AppColors.textLight,
      ),
    );
  }
}
