import 'package:flutter/material.dart';

class ScannerProvider extends ChangeNotifier {
  bool _isScanning = true;

  bool get isScanning => _isScanning;

  void stopScanning() {
    _isScanning = false;
    notifyListeners();
  }

  void startScanning() {
    _isScanning = true;
    notifyListeners();
  }
}
