import 'package:bricd_up/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// This defines the navigation bar at the bottom of the screen
class NavBar extends StatelessWidget implements PreferredSizeWidget {

  const NavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    const Widget defaultLeadingIcon = IconButton(
      onPressed: null,
      icon: Icon(Icons.menu),
      tooltip: 'Navigation Menu',
    );

    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Forum',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Camera',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color(0xFFFFB81C),
        unselectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: AppColors.primaryBeige,
        type: BottomNavigationBarType.fixed,
      ),
    );
    
    
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}