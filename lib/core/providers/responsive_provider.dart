import 'package:flutter/material.dart';

class ResponsiveProvider extends ChangeNotifier {
  double _screenWidth = 0;
  double _screenHeight = 0;

  double get screenWidth => _screenWidth;
  double get screenHeight => _screenHeight;

  bool get isMobile => _screenWidth < 600;
  bool get isTablet => _screenWidth >= 600 && _screenWidth < 1024;
  bool get isDesktop => _screenWidth >= 1024;

  void updateMetrics(double width, double height) {
    if (_screenWidth != width || _screenHeight != height) {
      _screenWidth = width;
      _screenHeight = height;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}
