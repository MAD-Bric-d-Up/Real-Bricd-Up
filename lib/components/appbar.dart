import 'package:bricd_up/pages/alerts.dart';
import 'package:bricd_up/pages/search.dart';
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
      backgroundColor: AppColors.primaryBeige,
      leading: IconButton(onPressed: null, icon: Icon(Icons.add)),
      actions: <Widget>[

        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Search()
              )
            );
          },
        ),

        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Alerts()
              )
            );
          },
        )
        
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}