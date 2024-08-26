
import 'package:fcm_notification_app/res/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final String title;
  final bool showBackArrow; // Add this parameter

  const CustomAppBar({super.key, required this.backgroundColor, required this.title, this.showBackArrow = true});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: Text(
        title,
        style:  TextStyle(color: Color(kLight.value), fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      automaticallyImplyLeading: showBackArrow, // Control the leading widget
      leading: showBackArrow
          ? IconButton(
        icon: Icon(Icons.arrow_back, color: Color(kALight.value)),
        onPressed: () => Navigator.of(context).pop(),
      )
          : null,
    );
  }
}
