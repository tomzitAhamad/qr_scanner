import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/providers/scanner_provider.dart';
import 'package:qr_code_scanner/core/providers/history_provider.dart';
import 'package:qr_code_scanner/features/scanner/services/qr_launcher_service.dart';

class QrCameraView extends StatefulWidget {
  const QrCameraView({super.key});

  @override
  State<QrCameraView> createState() => _QrCameraViewState();
}

class _QrCameraViewState extends State<QrCameraView>
    with WidgetsBindingObserver {
  late final ScannerProvider _scannerProvider;
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scannerProvider = context.read<ScannerProvider>();

    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      autoStart: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scannerProvider.setController(_controller);
      }
    });

    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) {
        _startScanner();
      }
    });
  }

  Future<void> _startScanner() async {
    try {
      if (!_controller.value.isRunning && !_controller.value.isStarting) {
        await _controller.start();
      }
    } catch (e) {
      debugPrint('Error starting mobile scanner: $e');
    }
  }

  Future<void> _stopScanner() async {
    try {
      if (_controller.value.isRunning || _controller.value.isStarting) {
        await _controller.stop();
      }
    } catch (e) {
      debugPrint('Error stopping mobile scanner: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.isInitialized) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _startScanner();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _stopScanner();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scannerProvider.clearController(_controller);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scannerProvider = context.read<ScannerProvider>();

    return MobileScanner(
      controller: _controller,
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
