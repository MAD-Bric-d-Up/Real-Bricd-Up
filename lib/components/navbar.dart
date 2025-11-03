import 'package:flutter/material.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const NavBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {

    const Widget defaultLeadingIcon = IconButton(
      onPressed: null,
      icon: Icon(Icons.menu),
      tooltip: 'Navigation Menu',
    );

    return AppBar(
      leading: leading ?? defaultLeadingIcon,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: actions,
      backgroundColor: const Color(0xFFABE782),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}