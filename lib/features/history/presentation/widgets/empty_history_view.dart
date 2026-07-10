import 'package:flutter/material.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';

class EmptyHistoryView extends StatelessWidget {
  const EmptyHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noHistoryYet,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.scannedQrCodesWillAppear,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.4),
                ),
          ),
        ],
      ),
    );
  }
}
