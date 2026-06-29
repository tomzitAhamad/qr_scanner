import 'package:flutter/material.dart';
import 'package:qr_code_scanner/core/constants/app_colors.dart';

class ScannerAppBar extends StatelessWidget {
  const ScannerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleIcon(icon: Icons.menu, onTap: () {}),
          Row(
            children: [
              _circleIcon(icon: Icons.image_outlined, onTap: () {}),
              const SizedBox(width: 12),
              _circleIcon(icon: Icons.flash_on_outlined, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleIcon({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        height: 46,
        width: 46,
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.18),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
