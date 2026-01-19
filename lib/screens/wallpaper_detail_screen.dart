import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app_flutter/models/wallpaper.dart';
import 'package:wallpaper_app_flutter/state/favorites_provider.dart';

class WallpaperDetailScreen extends ConsumerWidget {
  const WallpaperDetailScreen({super.key, required this.wallpaper});

  final Wallpaper wallpaper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.any((item) => item.id == wallpaper.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpaper'),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              ref.read(favoritesProvider.notifier).toggle(wallpaper);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Hero(
              tag: 'wallpaper-${wallpaper.id}',
              child: CachedNetworkImage(
                imageUrl: wallpaper.fullUrl.isNotEmpty
                    ? wallpaper.fullUrl
                    : wallpaper.previewUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wallpaper.tags.take(6).join(' • '),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _InfoChip(label: wallpaper.rating.toUpperCase()),
                    const SizedBox(width: 8),
                    _InfoChip(label: '${wallpaper.width}×${wallpaper.height}'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.wallpaper),
                        label: const Text('Set Wallpaper'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.download),
                        label: const Text('Download'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Connect platform plugins to enable download and wallpaper actions.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
