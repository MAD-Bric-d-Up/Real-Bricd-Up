import 'package:flutter/material.dart';

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
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Forum',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Camera',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color(0xFFFFB81C),
        unselectedItemColor: Colors.black,
      ),
    );
    
    
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}