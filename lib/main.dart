import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wallpaper_app_flutter/app.dart';
import 'package:wallpaper_app_flutter/models/downloaded_wallpaper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DownloadedWallpaperAdapter());
  await Hive.openBox<DownloadedWallpaper>('downloads');
  runApp(const ProviderScope(child: WallpaperApp()));
}
