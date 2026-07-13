import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_code_scanner/core/constants/app_colors.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider._(this._preferences);

  static const _colorSchemeIndexKey = 'settings.colorSchemeIndex';
  static const _themeModeKey = 'settings.themeMode';
  static const _beepKey = 'settings.beep';
  static const _vibrateKey = 'settings.vibrate';
  static const _copyToClipboardKey = 'settings.copyToClipboard';
  static const _urlInfoKey = 'settings.urlInfo';
  static const _useAutoFocusKey = 'settings.useAutoFocus';
  static const _touchFocusKey = 'settings.touchFocus';
  static const _keepDuplicatesKey = 'settings.keepDuplicates';
  static const _customActionKey = 'settings.customAction';
  static const _useInAppBrowserKey = 'settings.useInAppBrowser';
  static const _addScansToHistoryKey = 'settings.addScansToHistory';
  static const _automaticallyOpenUrlsKey = 'settings.automaticallyOpenUrls';

  final SharedPreferences _preferences;

  static Future<SettingsProvider> create() async {
    final provider = SettingsProvider._(await SharedPreferences.getInstance());
    provider._restore();
    return provider;
  }

  static const List<Color> colorSchemes = AppColors.colorSchemes;
  int _colorSchemeIndex = 0;
  ThemeMode _themeMode = ThemeMode.system;
  bool _beep = false;
  bool _vibrate = false;
  bool _copyToClipboard = false;
  bool _urlInfo = true;
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
  bool get useAutoFocus => _useAutoFocus;
  bool get touchFocus => _touchFocus;
  bool get keepDuplicates => _keepDuplicates;
  bool get customAction => _customAction;
  bool get useInAppBrowser => _useInAppBrowser;
  bool get addScansToHistory => _addScansToHistory;
  bool get automaticallyOpenUrls => _automaticallyOpenUrls;

  void _restore() {
    final savedColorIndex = _preferences.getInt(_colorSchemeIndexKey);
    if (savedColorIndex != null &&
        savedColorIndex >= 0 &&
        savedColorIndex < colorSchemes.length) {
      _colorSchemeIndex = savedColorIndex;
    }
    _themeMode = switch (_preferences.getString(_themeModeKey)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    _beep = _preferences.getBool(_beepKey) ?? _beep;
    _vibrate = _preferences.getBool(_vibrateKey) ?? _vibrate;
    _copyToClipboard = _preferences.getBool(_copyToClipboardKey) ?? _copyToClipboard;
    _urlInfo = _preferences.getBool(_urlInfoKey) ?? _urlInfo;
    _useAutoFocus = _preferences.getBool(_useAutoFocusKey) ?? _useAutoFocus;
    _touchFocus = _preferences.getBool(_touchFocusKey) ?? _touchFocus;
    _keepDuplicates = _preferences.getBool(_keepDuplicatesKey) ?? _keepDuplicates;
    _customAction = _preferences.getBool(_customActionKey) ?? _customAction;
    _useInAppBrowser = _preferences.getBool(_useInAppBrowserKey) ?? _useInAppBrowser;
    _addScansToHistory = _preferences.getBool(_addScansToHistoryKey) ?? _addScansToHistory;
    _automaticallyOpenUrls =
        _preferences.getBool(_automaticallyOpenUrlsKey) ?? _automaticallyOpenUrls;
  }

  void _saveBool(String key, bool value) {
    unawaited(_preferences.setBool(key, value));
  }

  void setColorSchemeIndex(int index) {
    if (index >= 0 && index < colorSchemes.length) {
      _colorSchemeIndex = index;
      unawaited(_preferences.setInt(_colorSchemeIndexKey, index));
      notifyListeners();
    }
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    unawaited(_preferences.setString(_themeModeKey, mode.name));
    notifyListeners();
  }

  void setBeep(bool value) {
    _beep = value;
    _saveBool(_beepKey, value);
    notifyListeners();
  }

  void setVibrate(bool value) {
    _vibrate = value;
    _saveBool(_vibrateKey, value);
    notifyListeners();
  }

  void setCopyToClipboard(bool value) {
    _copyToClipboard = value;
    _saveBool(_copyToClipboardKey, value);
    notifyListeners();
  }

  void setUrlInfo(bool value) {
    _urlInfo = value;
    _saveBool(_urlInfoKey, value);
    notifyListeners();
  }

  void setUseAutoFocus(bool value) {
    _useAutoFocus = value;
    _saveBool(_useAutoFocusKey, value);
    notifyListeners();
  }

  void setTouchFocus(bool value) {
    _touchFocus = value;
    _saveBool(_touchFocusKey, value);
    notifyListeners();
  }

  void setKeepDuplicates(bool value) {
    _keepDuplicates = value;
    _saveBool(_keepDuplicatesKey, value);
    notifyListeners();
  }

  void setCustomAction(bool value) {
    _customAction = value;
    _saveBool(_customActionKey, value);
    notifyListeners();
  }

  void setUseInAppBrowser(bool value) {
    _useInAppBrowser = value;
    _saveBool(_useInAppBrowserKey, value);
    notifyListeners();
  }

  void setAddScansToHistory(bool value) {
    _addScansToHistory = value;
    _saveBool(_addScansToHistoryKey, value);
    notifyListeners();
  }

  void setAutomaticallyOpenUrls(bool value) {
    _automaticallyOpenUrls = value;
    _saveBool(_automaticallyOpenUrlsKey, value);
    notifyListeners();
  }

  Future<void> shareApp() async {
    await SharePlus.instance.share(ShareParams(text: AppStrings.shareAppMessage));
  }
}
