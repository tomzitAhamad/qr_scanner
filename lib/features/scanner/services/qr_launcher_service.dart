import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QrLauncherService {
  static Future<void> launchQr({
    required BuildContext context,
    required String qrData,
  }) async {
    if (qrData.startsWith("http://") || qrData.startsWith("https://")) {
      final Uri uri = Uri.parse(qrData);

      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      debugPrint("Launched : $launched");

      return;
    }

    debugPrint("Unsupported QR : $qrData");
  }
}
