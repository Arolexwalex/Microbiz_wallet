import 'package:flutter/material.dart';
import '../theme/theme.dart';

class CurvedHeader extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Widget? child;
  const CurvedHeader({super.key, this.height = 180, this.child});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Container(
            height: height,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
          ),
          if (child != null)
            Positioned.fill(
              child: Align(alignment: Alignment.bottomCenter, child: Padding(padding: const EdgeInsets.all(16), child: child!)),
            ),
        ],
      ),
    );
  }
}


