import 'package:flutter/material.dart';
import '../models/history_item.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<HistoryItem> _favorites = [];

  List<HistoryItem> get favorites => List.unmodifiable(_favorites.reversed);

  bool isFavorite(String qrData) {
    return _favorites.any((item) => item.data == qrData);
  }

  void toggleFavorite(HistoryItem item) {
    final index = _favorites.indexWhere((fav) => fav.data == item.data);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(item);
    }
    notifyListeners();
  }

  void removeFavorite(String qrData) {
    _favorites.removeWhere((item) => item.data == qrData);
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
