import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';
import 'settings_provider.dart';

class HistoryProvider extends ChangeNotifier {
  final SettingsProvider _settings;
  SharedPreferences? _preferences;
  final List<HistoryItem> _items = [];

  static const _historyKey = 'history.items';

  HistoryProvider(this._settings) {
    _init();
  }

  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
    _loadHistory();
  }

  List<HistoryItem> get items => List.unmodifiable(_items.reversed);

  void _loadHistory() {
    final list = _preferences?.getStringList(_historyKey);
    if (list != null) {
      for (final raw in list) {
        try {
          _items.add(HistoryItem.fromJson(jsonDecode(raw) as Map<String, dynamic>));
        } catch (_) {}
      }
      notifyListeners();
    }
  }

  void _saveHistory() {
    final list = _items.map((item) => jsonEncode(item.toJson())).toList();
    _preferences?.setStringList(_historyKey, list);
  }

  void addHistoryItem({required String data, required String type}) {
    final lowerType = type.toLowerCase();
    if ((lowerType == 'camera' || lowerType == 'image') &&
        !_settings.addScansToHistory) {
      return;
    }

    final newItem = HistoryItem(
      data: data,
      scanTime: DateTime.now(),
      scanType: type,
    );
    _items.add(newItem);
    _saveHistory();
    notifyListeners();
  }

  void clearHistory() {
    _items.clear();
    _saveHistory();
    notifyListeners();
  }

  void removeHistoryItem(int index) {
    final reversedList = _items.reversed.toList();
    if (index >= 0 && index < reversedList.length) {
      final itemToRemove = reversedList[index];
      _items.remove(itemToRemove);
      _saveHistory();
      notifyListeners();
    }
  }
}
