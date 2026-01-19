import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app_flutter/models/wallpaper.dart';
import 'package:wallpaper_app_flutter/state/downloads_provider.dart';
import 'package:wallpaper_app_flutter/state/favorites_provider.dart';

class WallpaperDetailScreen extends ConsumerStatefulWidget {
  const WallpaperDetailScreen({
    super.key,
    required this.wallpaper,
    this.localPath,
  });

  final Wallpaper wallpaper;
  final String? localPath;

  @override
  ConsumerState<WallpaperDetailScreen> createState() =>
      _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState
    extends ConsumerState<WallpaperDetailScreen> {
  bool _isDownloading = false;
  bool _isSettingWallpaper = false;
  bool _isSaving = false;

  Future<void> _download() async {
    setState(() {
      _isDownloading = true;
    });
    try {
      await ref.read(downloadsProvider.notifier).download(widget.wallpaper);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Download complete.')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  Future<void> _saveToGallery() async {
    setState(() {
      _isSaving = true;
    });
    try {
      final downloaded =
          await ref.read(downloadsProvider.notifier).download(widget.wallpaper);
      final success = await ref
          .read(wallpaperActionsProvider)
          .saveToGallery(downloaded.localPath);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Saved to gallery.' : 'Gallery save denied.',
          ),
        ),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _setWallpaper() async {
    setState(() {
      _isSettingWallpaper = true;
    });
    try {
      final downloaded =
          await ref.read(downloadsProvider.notifier).download(widget.wallpaper);
      final success = await ref
          .read(wallpaperActionsProvider)
          .setWallpaper(downloaded.localPath);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Wallpaper applied on Android.'
                : 'Wallpaper setting is only supported on Android.',
          ),
        ),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wallpaper update failed: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSettingWallpaper = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite =
        favorites.any((item) => item.id == widget.wallpaper.id);
    final downloads = ref.watch(downloadsProvider);
    String? localPath = widget.localPath;
    if (localPath == null) {
      for (final item in downloads) {
        if (item.id == widget.wallpaper.id) {
          localPath = item.localPath;
          break;
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpaper'),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              ref.read(favoritesProvider.notifier).toggle(widget.wallpaper);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Hero(
              tag: 'wallpaper-${widget.wallpaper.id}',
              child: localPath != null && File(localPath).existsSync()
                  ? Image.file(
                      File(localPath),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : CachedNetworkImage(
                      imageUrl: widget.wallpaper.fullUrl.isNotEmpty
                          ? widget.wallpaper.fullUrl
                          : widget.wallpaper.previewUrl,
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
                  widget.wallpaper.tags.take(6).join(' • '),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _InfoChip(label: widget.wallpaper.rating.toUpperCase()),
                    const SizedBox(width: 8),
                    _InfoChip(
                      label:
                          '${widget.wallpaper.width}×${widget.wallpaper.height}',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed:
                            _isSettingWallpaper ? null : _setWallpaper,
                        icon: const Icon(Icons.wallpaper),
                        label: Text(
                          _isSettingWallpaper
                              ? 'Setting...'
                              : 'Set Wallpaper',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isDownloading ? null : _download,
                        icon: const Icon(Icons.download),
                        label: Text(
                          _isDownloading ? 'Downloading...' : 'Download',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _isSaving ? null : _saveToGallery,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(
                    _isSaving ? 'Saving...' : 'Save to Gallery',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Downloads are stored locally for offline access. Setting '
                  'wallpapers is supported on Android; iOS users can save to '
                  'Photos and set it manually.',
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
