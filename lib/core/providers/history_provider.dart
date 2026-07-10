import 'package:flutter/material.dart';
import '../models/history_item.dart';

class HistoryProvider extends ChangeNotifier {
  final List<HistoryItem> _items = [];

  List<HistoryItem> get items => List.unmodifiable(_items.reversed);

  void addHistoryItem({required String data, required String type}) {
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
    // Note: since the getter returns the reversed list for UI (showing newest first),
    // we need to translate the index back to the original list or just remove by reference.
    final reversedList = _items.reversed.toList();
    if (index >= 0 && index < reversedList.length) {
      final itemToRemove = reversedList[index];
      _items.remove(itemToRemove);
      notifyListeners();
    }
  }
}
