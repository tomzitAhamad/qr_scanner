import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  static const List<Color> colorSchemes = [
    Color(0xFF2563EB),
    Color(0xFFDC2626),
    Color(0xFFF97316),
    Color(0xFFF59E0B),
    Color(0xFF15803D),
    Color(0xFF10B981),
    Color(0xFF06B6D4),
    Color(0xFF4F46E5),
    Color(0xFF8B5CF6),
    Color(0xFF6D28D9),
    Color(0xFF9A3412),
    Color(0xFF475569),
  ];
  int _colorSchemeIndex = 0;
  ThemeMode _themeMode = ThemeMode.system;
  bool _beep = false;
  bool _vibrate = false;
  bool _copyToClipboard = false;
  bool _urlInfo = true;
  bool _batchScanMode = false;
  bool _useAutoFocus = true;
  bool _touchFocus = true;
  bool _keepDuplicates = true;
  bool _customAction = false;
  bool _useInAppBrowser = true;
  bool _addScansToHistory = true;
  bool _automaticallyOpenUrls = false;
  int get colorSchemeIndex => _colorSchemeIndex;
  Color get primaryColor => colorSchemes[_colorSchemeIndex];
  ThemeMode get themeMode => _themeMode;

  bool get beep => _beep;
  bool get vibrate => _vibrate;
  bool get copyToClipboard => _copyToClipboard;
  bool get urlInfo => _urlInfo;
  bool get batchScanMode => _batchScanMode;
  bool get useAutoFocus => _useAutoFocus;
  bool get touchFocus => _touchFocus;
  bool get keepDuplicates => _keepDuplicates;
  bool get customAction => _customAction;
  bool get useInAppBrowser => _useInAppBrowser;
  bool get addScansToHistory => _addScansToHistory;
  bool get automaticallyOpenUrls => _automaticallyOpenUrls;

  void setColorSchemeIndex(int index) {
    if (index >= 0 && index < colorSchemes.length) {
      _colorSchemeIndex = index;
      notifyListeners();
    }
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setBeep(bool value) {
    _beep = value;
    notifyListeners();
  }

  void setVibrate(bool value) {
    _vibrate = value;
    notifyListeners();
  }

  void setCopyToClipboard(bool value) {
    _copyToClipboard = value;
    notifyListeners();
  }

  void setUrlInfo(bool value) {
    _urlInfo = value;
    notifyListeners();
  }

  void setBatchScanMode(bool value) {
    _batchScanMode = value;
    notifyListeners();
  }

  void setUseAutoFocus(bool value) {
    _useAutoFocus = value;
    notifyListeners();
  }

  void setTouchFocus(bool value) {
    _touchFocus = value;
    notifyListeners();
  }

  void setKeepDuplicates(bool value) {
    _keepDuplicates = value;
    notifyListeners();
  }

  void setCustomAction(bool value) {
    _customAction = value;
    notifyListeners();
  }

  void setUseInAppBrowser(bool value) {
    _useInAppBrowser = value;
    notifyListeners();
  }

  void setAddScansToHistory(bool value) {
    _addScansToHistory = value;
    notifyListeners();
  }

  void setAutomaticallyOpenUrls(bool value) {
    _automaticallyOpenUrls = value;
    notifyListeners();
  }
}
