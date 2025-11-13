import 'package:bricd_up/components/appbar.dart';
import 'package:bricd_up/components/navbar.dart';
import 'package:bricd_up/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      bottomNavigationBar: const NavBar(),
      backgroundColor: AppColors.primaryGreen,
      body: Column(
        children: [
          Text('Feed Page TBD')
        ],
      ),
    );
  }
}