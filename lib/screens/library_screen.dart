import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app_flutter/models/downloaded_wallpaper.dart';
import 'package:wallpaper_app_flutter/models/wallpaper.dart';
import 'package:wallpaper_app_flutter/screens/wallpaper_detail_screen.dart';
import 'package:wallpaper_app_flutter/state/downloads_provider.dart';
import 'package:wallpaper_app_flutter/state/favorites_provider.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final downloads = ref.watch(downloadsProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Library',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Access favorites and offline downloads.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              const TabBar(
                tabs: [
                  Tab(text: 'Favorites'),
                  Tab(text: 'Downloads'),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  children: [
                    _FavoritesTab(favorites: favorites),
                    _DownloadsTab(downloads: downloads),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoritesTab extends StatelessWidget {
  const _FavoritesTab({required this.favorites});

  final List<Wallpaper> favorites;

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text('No favorites yet. Tap a heart to save one.'),
        ),
      );
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final wallpaper = favorites[index];
        return _FavoriteCard(wallpaper: wallpaper);
      },
    );
  }
}

class _DownloadsTab extends StatelessWidget {
  const _DownloadsTab({required this.downloads});

  final List<DownloadedWallpaper> downloads;

  @override
  Widget build(BuildContext context) {
    if (downloads.isEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text('No downloads yet. Save a wallpaper for offline use.'),
        ),
      );
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: downloads.length,
      itemBuilder: (context, index) {
        final item = downloads[index];
        return _DownloadedCard(downloaded: item);
      },
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({required this.wallpaper});

  final Wallpaper wallpaper;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WallpaperDetailScreen(wallpaper: wallpaper),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Hero(
          tag: 'wallpaper-${wallpaper.id}',
          child: CachedNetworkImage(
            imageUrl: wallpaper.previewUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: Colors.black12,
            ),
          ),
        ),
      ),
    );
  }
}

class _DownloadedCard extends StatelessWidget {
  const _DownloadedCard({required this.downloaded});

  final DownloadedWallpaper downloaded;

  @override
  Widget build(BuildContext context) {
    final file = File(downloaded.localPath);
    final image = file.existsSync()
        ? Image.file(file, fit: BoxFit.cover)
        : CachedNetworkImage(
            imageUrl: downloaded.previewUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: Colors.black12,
            ),
          );
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WallpaperDetailScreen(
              wallpaper: downloaded.toWallpaper(),
              localPath: downloaded.localPath,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Hero(
          tag: 'wallpaper-${downloaded.id}',
          child: image,
        ),
      ),
    );
  }
}
