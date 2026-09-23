import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';

class WeekDetailScreen extends StatelessWidget {
  final String weekId;
  const WeekDetailScreen({super.key, required this.weekId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Week Detail'),
      ),
      body: const CyberBackground(
        child: Center(
          child: Text('Week detail coming from month view',
              style: TextStyle(color: AppColors.textSecondary)),
        ),
      ),
    );
  }
}
