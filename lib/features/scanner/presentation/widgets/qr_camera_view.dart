import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/providers/scanner_provider.dart';

class QrCameraView extends StatefulWidget {
  const QrCameraView({super.key});

  @override
  State<QrCameraView> createState() => _QrCameraViewState();
}

class _QrCameraViewState extends State<QrCameraView> {
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scannerProvider = context.read<ScannerProvider>();

    return MobileScanner(
      controller: _controller,
      onDetect: (capture) {
        if (scannerProvider.isScanned) return;

        if (capture.barcodes.isEmpty) return;

        final Barcode barcode = capture.barcodes.first;
        final String? result = barcode.rawValue;

        if (result == null || result.isEmpty) return;

        scannerProvider.scanned();

        debugPrint("QR Result : $result");
      },
    );
  }
}
