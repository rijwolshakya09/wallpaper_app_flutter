import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class WallpaperActionsService {
  WallpaperActionsService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<String> downloadImage({
    required String imageUrl,
    required String fileName,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final wallpaperDir = Directory('${directory.path}/wallpapers');
    if (!wallpaperDir.existsSync()) {
      wallpaperDir.createSync(recursive: true);
    }

    final extension = _resolveExtension(imageUrl);
    final filePath = '${wallpaperDir.path}/$fileName.$extension';
    final file = File(filePath);
    if (file.existsSync()) {
      return filePath;
    }

    await _dio.download(imageUrl, filePath);
    return filePath;
  }

  Future<bool> saveToGallery(String filePath) async {
    if (Platform.isIOS) {
      final status = await Permission.photos.request();
      if (!status.isGranted) {
        return false;
      }
    }
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        return false;
      }
    }

    final result = await ImageGallerySaver.saveFile(filePath);
    return result['isSuccess'] == true;
  }

  Future<bool> setWallpaper(String filePath) async {
    if (!Platform.isAndroid) {
      return false;
    }
    await WallpaperManagerFlutter().setwallpaperfromFile(
      filePath,
      WallpaperManagerFlutter.HOME_SCREEN,
    );
    return true;
  }

  String _resolveExtension(String imageUrl) {
    final uri = Uri.tryParse(imageUrl);
    final path = uri?.path ?? '';
    final segments = path.split('.');
    if (segments.length > 1) {
      final ext = segments.last.toLowerCase();
      if (ext.length <= 5) {
        return ext;
      }
    }
    return 'jpg';
  }
}
