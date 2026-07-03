import 'package:flutter/material.dart';

class QrLauncherService {
  static Future<void> launchQr({
    required BuildContext context,
    required String qrData,
  }) async {
    debugPrint("Scanned Data: $qrData");
  }
}
