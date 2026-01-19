import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_app_flutter/models/wallpaper.dart';

const _favoritesKey = 'favorite_wallpapers';

class FavoritesNotifier extends StateNotifier<List<Wallpaper>> {
  FavoritesNotifier() : super(const []) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_favoritesKey) ?? [];
    final items = raw
        .map((entry) => Wallpaper.fromStorage(
              jsonDecode(entry) as Map<String, dynamic>,
            ))
        .toList();
    state = items;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = state
        .map((wallpaper) => jsonEncode(wallpaper.toStorage()))
        .toList();
    await prefs.setStringList(_favoritesKey, payload);
  }

  bool isFavorite(String id) => state.any((wallpaper) => wallpaper.id == id);

  Future<void> toggle(Wallpaper wallpaper) async {
    if (isFavorite(wallpaper.id)) {
      state = state.where((item) => item.id != wallpaper.id).toList();
    } else {
      state = [wallpaper, ...state];
    }
    await _persist();
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Wallpaper>>(
  (ref) => FavoritesNotifier(),
);
