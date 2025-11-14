import 'package:bricd_up/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Forum extends StatefulWidget {
  const Forum({super.key});

  @override
  State<Forum> createState() => _Forum();
}

class _Forum extends State<Forum> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Column(
        children: [
          Text('Forum Page TBD')
        ],
      ),
    );
  }
}