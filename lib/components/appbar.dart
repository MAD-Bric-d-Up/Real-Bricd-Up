import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// This defines the AppBar at the top of the screen on most pages
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Bric'd Up",
        style: TextStyle(
          color: AppColors.primaryGreen,
          fontSize: 30.0,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}