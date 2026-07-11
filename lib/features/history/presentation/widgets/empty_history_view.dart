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
            color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.3) ?? Colors.grey.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noHistoryYet,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).textTheme.titleLarge?.color?.withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.scannedQrCodesWillAppear,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.4),
                ),
          ),
        ],
      ),
    );
  }
}
