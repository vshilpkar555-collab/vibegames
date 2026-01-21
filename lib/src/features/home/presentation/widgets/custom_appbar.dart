import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,

      // CUSTOM BACK BUTTON
      leading: IconButton(
        onPressed: onBack ?? () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF059669), // Green
                Color(0xFF10B981), // Emerald
                Color(0xFF14B8A6), // Teal
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),

      // CENTER TITLE
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
      ),

      // RIGHT SIDE EMPTY TO KEEP TITLE CENTERED
      actions: const [
        SizedBox(width: 48),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
