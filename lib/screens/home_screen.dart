import 'package:flutter/material.dart';
import 'package:wallpaper_app_flutter/screens/browse_screen.dart';
import 'package:wallpaper_app_flutter/screens/generator_screen.dart';
import 'package:wallpaper_app_flutter/screens/library_screen.dart';
import 'package:wallpaper_app_flutter/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const BrowseScreen(),
      const GeneratorScreen(),
      const LibraryScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anime Wallpaper Studio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.wallpaper_outlined),
            label: 'Browse',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome),
            label: 'Generate',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
