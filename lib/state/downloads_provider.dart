import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:wallpaper_app_flutter/models/downloaded_wallpaper.dart';
import 'package:wallpaper_app_flutter/models/wallpaper.dart';
import 'package:wallpaper_app_flutter/services/wallpaper_actions_service.dart';

final wallpaperActionsProvider = Provider<WallpaperActionsService>(
  (ref) => WallpaperActionsService(),
);

final downloadsProvider =
    StateNotifierProvider<DownloadsNotifier, List<DownloadedWallpaper>>(
  (ref) => DownloadsNotifier(
    box: Hive.box<DownloadedWallpaper>('downloads'),
    actionsService: ref.read(wallpaperActionsProvider),
  ),
);

class DownloadsNotifier extends StateNotifier<List<DownloadedWallpaper>> {
  DownloadsNotifier({
    required Box<DownloadedWallpaper> box,
    required WallpaperActionsService actionsService,
  })  : _box = box,
        _actionsService = actionsService,
        super(box.values.toList());

  final Box<DownloadedWallpaper> _box;
  final WallpaperActionsService _actionsService;

  DownloadedWallpaper? getById(String id) {
    return _box.get(id);
  }

  Future<DownloadedWallpaper> download(Wallpaper wallpaper) async {
    final existing = _box.get(wallpaper.id);
    if (existing != null && File(existing.localPath).existsSync()) {
      return existing;
    }

    final url = wallpaper.fullUrl.isNotEmpty
        ? wallpaper.fullUrl
        : wallpaper.previewUrl;
    final filePath = await _actionsService.downloadImage(
      imageUrl: url,
      fileName: wallpaper.id,
    );
    final downloaded = DownloadedWallpaper.fromWallpaper(
      wallpaper: wallpaper,
      localPath: filePath,
    );
    await _box.put(downloaded.id, downloaded);
    state = _box.values.toList();
    return downloaded;
  }

  Future<void> remove(String id) async {
    final existing = _box.get(id);
    if (existing != null) {
      final file = File(existing.localPath);
      if (file.existsSync()) {
        await file.delete();
      }
    }
    await _box.delete(id);
    state = _box.values.toList();
  }
}
