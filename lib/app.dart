import 'package:flutter/material.dart';
import 'package:wallpaper_app_flutter/screens/home_screen.dart';

class WallpaperApp extends StatelessWidget {
  const WallpaperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Wallpaper Studio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B5BFF)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
