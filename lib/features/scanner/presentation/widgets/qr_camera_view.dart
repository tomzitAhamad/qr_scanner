import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/providers/scanner_provider.dart';
import 'package:qr_code_scanner/core/providers/history_provider.dart';
import 'package:qr_code_scanner/features/scanner/services/qr_launcher_service.dart';

class QrCameraView extends StatelessWidget {
  const QrCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    final scannerProvider = context.read<ScannerProvider>();

    return MobileScanner(
      controller: scannerProvider.controller,
      onDetect: (capture) async {
        if (scannerProvider.isScanned) return;

        if (capture.barcodes.isEmpty) return;

        final Barcode barcode = capture.barcodes.first;
        final String? result = barcode.rawValue;

        if (result == null || result.isEmpty) return;

        if (scannerProvider.checkDuplicateAndSet(result)) return;

        scannerProvider.scanned();
        if (context.mounted) {
          context.read<HistoryProvider>().addHistoryItem(
            data: result,
            type: "Camera",
          );
        }
        QrLauncherService.launchQr(context: context, qrData: result);

        scannerProvider.reset();
      },
    );
  }
}
