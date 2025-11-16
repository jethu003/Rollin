import 'package:flutter/material.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';




class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? logoPath; 
  final List<Widget>? actions; 

  const CustomAppBar({
    super.key,
    this.logoPath,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 4,
      backgroundColor: AppColours.shineBlack,
      title: Row(
        children: [
          if (logoPath != null)
            Image.asset(
              logoPath!,
              height: 100,
              width: 100,
            ),
          if (logoPath != null) const SizedBox(width: 8), 
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
