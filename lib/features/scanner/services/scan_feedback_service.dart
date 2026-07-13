import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ScanFeedbackService {
  ScanFeedbackService._();

  static const _channel = MethodChannel(
    'com.example.qr_code_scanner/scan_feedback',
  );

  static Future<void> playBeep() async {
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('playBeep');
    } on PlatformException {
      // Scanning can continue when a device does not provide a system tone.
    }
  }
}
