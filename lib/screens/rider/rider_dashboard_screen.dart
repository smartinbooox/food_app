import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class RiderDashboardScreen extends StatelessWidget {
  const RiderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rider Dashboard'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: AppConstants.textOnPrimary,
        elevation: 0,
      ),
      backgroundColor: AppConstants.backgroundColor,
      body: Center(
        child: Text(
          'Welcome, Rider!\nYour dashboard will appear here.',
          style: AppConstants.headingStyle.copyWith(color: AppConstants.primaryColor, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
} 