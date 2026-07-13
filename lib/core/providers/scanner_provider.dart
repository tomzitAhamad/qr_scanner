import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/providers/history_provider.dart';
import 'package:qr_code_scanner/core/providers/settings_provider.dart';
import 'package:qr_code_scanner/features/scanner/services/qr_launcher_service.dart';

class ScannerProvider extends ChangeNotifier {
  MobileScannerController? _controller;
  MobileScannerController? get controller => _controller;

  bool _isScanned = false;
  bool _isFlashOn = false;
  bool get isScanned => _isScanned;
  bool get isFlashOn => _isFlashOn;

  String? _lastScannedData;
  DateTime? _lastScannedTime;

  void setController(MobileScannerController newController) {
    _controller = newController;
    _isFlashOn = false;
    notifyListeners();
  }

  void clearController(MobileScannerController controllerToClear) {
    if (_controller == controllerToClear) {
      _controller = null;
      notifyListeners();
    }
  }

  bool checkDuplicateAndSet(String data) {
    final now = DateTime.now();
    if (_lastScannedData == data &&
        _lastScannedTime != null &&
        now.difference(_lastScannedTime!) < const Duration(seconds: 3)) {
      return true;
    }
    _lastScannedData = data;
    _lastScannedTime = now;
    return false;
  }

  void scanned() {
    _isScanned = true;
    notifyListeners();
  }

  void reset() {
    _isScanned = false;
    notifyListeners();
  }

  Future<void> toggleFlash() async {
    if (_controller != null) {
      await _controller!.toggleTorch();
      _isFlashOn = !_isFlashOn;
      notifyListeners();
    }
  }

  Future<void> scanImage(BuildContext context) async {
    scanned(); // Pause camera scanner while picking and scanning
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;
      if (!context.mounted) return;

      final activeController = _controller;
      final tempController = activeController ?? MobileScannerController();

      final BarcodeCapture? capture = await tempController.analyzeImage(
        image.path,
      );

      if (activeController == null) {
        tempController.dispose();
      }

      if (!context.mounted) return;

      if (capture == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("No QR Code Found")));
        return;
      }

      if (capture.barcodes.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("No QR Code Found")));
        return;
      }

      final String? result = capture.barcodes.first.rawValue;

      if (result == null || result.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Invalid QR Code")));
        return;
      }

      final settings = context.read<SettingsProvider>();
      context.read<HistoryProvider>().addHistoryItem(
        data: result,
        type: "Image",
        keepDuplicates: settings.keepDuplicates,
      );

      if (settings.copyToClipboard) {
        await Clipboard.setData(ClipboardData(text: result));
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Copied to clipboard"),
            duration: Duration(seconds: 1),
          ),
        );
      }

      if (!context.mounted) return;
      await QrLauncherService.launchQr(context: context, qrData: result);
    } finally {
      reset(); // Resume camera scanner when done or if cancelled/failed
    }
  }
}
