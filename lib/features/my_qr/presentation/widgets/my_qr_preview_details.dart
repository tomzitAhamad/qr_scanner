import 'package:flutter/material.dart';
import '../../../../core/providers/my_qr_provider.dart';
import '../../../../core/constants/app_colors.dart';

class MyQrPreviewDetails extends StatelessWidget {
  final MyQrProvider myQrProvider;

  const MyQrPreviewDetails({super.key, required this.myQrProvider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (myQrProvider.fullName.isNotEmpty)
            Text(
              myQrProvider.fullName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          if (myQrProvider.organization.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              myQrProvider.organization,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.white70,
              ),
            ),
          ],
          if (myQrProvider.address.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              myQrProvider.address,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.white60,
              ),
            ),
          ],
          if (myQrProvider.phoneNumber.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              myQrProvider.phoneNumber,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.white60,
              ),
            ),
          ],
          if (myQrProvider.email.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              myQrProvider.email,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.white60,
              ),
            ),
          ],
          if (myQrProvider.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              myQrProvider.notes,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AppColors.white54,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
