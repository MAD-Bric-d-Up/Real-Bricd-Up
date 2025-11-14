import 'package:bricd_up/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  final TabController tabController;

  const Navbar({super.key, required this.tabController});

  @override
  State<Navbar> createState() => _NavBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

/// This defines the navigation bar at the bottom of the screen
class _NavBarState extends State<Navbar> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    widget.tabController.animateTo(index);
  }

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      if (_selectedIndex != widget.tabController.index) {
        setState(() {
          _selectedIndex = widget.tabController.index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFFFB81C),
        unselectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: AppColors.primaryBeige,
        type: BottomNavigationBarType.fixed,
      ),
    );
    
    
  }
}