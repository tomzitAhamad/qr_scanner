import 'package:flutter/material.dart';
import '../models/history_item.dart';
import 'settings_provider.dart';

class HistoryProvider extends ChangeNotifier {
  final SettingsProvider _settings;
  final List<HistoryItem> _items = [];

  HistoryProvider(this._settings);

  List<HistoryItem> get items => List.unmodifiable(_items.reversed);

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
    notifyListeners();
  }

  void clearHistory() {
    _items.clear();
    notifyListeners();
  }

  void removeHistoryItem(int index) {
    final reversedList = _items.reversed.toList();
    if (index >= 0 && index < reversedList.length) {
      final itemToRemove = reversedList[index];
      _items.remove(itemToRemove);
      notifyListeners();
    }
  }
}
