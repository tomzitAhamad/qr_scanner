import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/providers/history_provider.dart';
import 'package:qr_code_scanner/features/scanner/services/qr_launcher_service.dart';

class ScannerProvider extends ChangeNotifier {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
  );

  bool _isScanned = false;
  bool _isFlashOn = false;
  bool get isScanned => _isScanned;
  bool get isFlashOn => _isFlashOn;

  String? _lastScannedData;
  DateTime? _lastScannedTime;

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
    await controller.toggleTorch();

    _isFlashOn = !_isFlashOn;

    notifyListeners();
  }

  Future<void> scanImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;
    if (!context.mounted) return;

    final BarcodeCapture? capture = await controller.analyzeImage(image.path);

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

    context.read<HistoryProvider>().addHistoryItem(
      data: result,
      type: "Image",
    );

    await QrLauncherService.launchQr(context: context, qrData: result);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
