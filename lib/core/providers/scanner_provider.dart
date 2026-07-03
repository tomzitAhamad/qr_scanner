import 'package:flutter/material.dart';

class ScannerProvider extends ChangeNotifier {
  bool _isScanned = false;

  bool get isScanned => _isScanned;

  void scanned() {
    _isScanned = true;
    notifyListeners();
  }

  void reset() {
    _isScanned = false;
    notifyListeners();
  }
}
