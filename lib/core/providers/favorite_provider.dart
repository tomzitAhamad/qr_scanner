import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';

class FavoriteProvider extends ChangeNotifier {
  SharedPreferences? _preferences;
  final List<HistoryItem> _favorites = [];

  static const _favoritesKey = 'favorites.items';

  FavoriteProvider() {
    _init();
  }

  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
    _loadFavorites();
  }

  List<HistoryItem> get favorites => List.unmodifiable(_favorites.reversed);

  void _loadFavorites() {
    final list = _preferences?.getStringList(_favoritesKey);
    if (list != null) {
      for (final raw in list) {
        try {
          _favorites.add(HistoryItem.fromJson(jsonDecode(raw) as Map<String, dynamic>));
        } catch (_) {}
      }
      notifyListeners();
    }
  }

  void _saveFavorites() {
    final list = _favorites.map((item) => jsonEncode(item.toJson())).toList();
    _preferences?.setStringList(_favoritesKey, list);
  }

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
    _saveFavorites();
    notifyListeners();
  }

  void removeFavorite(String qrData) {
    _favorites.removeWhere((item) => item.data == qrData);
    _saveFavorites();
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    _saveFavorites();
    notifyListeners();
  }
}
