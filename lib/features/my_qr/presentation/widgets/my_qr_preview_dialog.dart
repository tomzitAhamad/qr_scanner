import 'package:flutter/material.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_code_scanner/core/constants/app_colors.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/providers/my_qr_provider.dart';
import 'my_qr_preview_header.dart';
import 'my_qr_preview_details.dart';
import 'my_qr_preview_actions.dart';

class MyQrPreviewDialog extends StatelessWidget {
  final MyQrProvider myQrProvider;

  const MyQrPreviewDialog({super.key, required this.myQrProvider});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.darkBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MyQrPreviewHeader(),
            const Divider(color: Colors.white12, height: 1),
            MyQrPreviewDetails(myQrProvider: myQrProvider),
            const Divider(color: Colors.white12, height: 1),
            MyQrPreviewActions(myQrProvider: myQrProvider),
            const Divider(color: Colors.white12, height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: QrImageView(
                      data: myQrProvider.generatedQrCodeData ?? "",
                      version: QrVersions.auto,
                      size: 140.0,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Colors.black,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Colors.black,
                      ),
                      gapless: false,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
                left: 16,
                right: 16,
              ),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(AppStrings.closePreview),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
