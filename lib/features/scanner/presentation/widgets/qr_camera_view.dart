import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCameraView extends StatelessWidget {
  const QrCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: MobileScannerController(),

      onDetect: (capture) {
        final Barcode? barcode = capture.barcodes.first;

        if (barcode == null) return;

        debugPrint("QR Result : ${barcode.rawValue}");
      },
    );
  }
}
