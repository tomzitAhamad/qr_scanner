import 'package:flutter/material.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_code_scanner/core/constants/app_colors.dart';

class MyQrPreviewHeader extends StatelessWidget {
  const MyQrPreviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.person_outline,
            color: AppColors.blueAccent,
            size: 28,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.contactTitle,
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  AppStrings.scannedContactCardPreview,
                  style: TextStyle(
                    color: AppColors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.star_outline,
              color: AppColors.white54,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
