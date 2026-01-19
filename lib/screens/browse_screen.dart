import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app_flutter/models/wallpaper.dart';
import 'package:wallpaper_app_flutter/screens/wallpaper_detail_screen.dart';
import 'package:wallpaper_app_flutter/services/anime_api_client.dart';
import 'package:wallpaper_app_flutter/state/app_config_provider.dart';
import 'package:wallpaper_app_flutter/widgets/tag_chip.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  static const _defaultTags = 'anime landscape';

  late final TextEditingController _searchController;
  bool _isLoading = false;
  String? _error;
  List<Wallpaper> _wallpapers = const [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: _defaultTags);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadWallpapers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final config = ref.read(appConfigProvider);
      final apiClient = AnimeApiClient(baseUrl: config.animeApiBaseUrl);
      final results = await apiClient.fetchWallpapers(
        page: 1,
        tags: _searchController.text.trim().replaceAll(' ', '+'),
      );
      setState(() {
        _wallpapers = results;
      });
    } catch (error) {
      setState(() {
        _error = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Discover Anime Wallpapers',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Connected API: ${config.animeApiBaseUrl}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tags (e.g. cyberpunk sunset)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadWallpapers,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _loadWallpapers(),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: const [
                TagChip(label: 'neon city'),
                TagChip(label: 'mecha'),
                TagChip(label: 'studio ghibli'),
                TagChip(label: 'samurai'),
              ],
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const LinearProgressIndicator()
            else if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              )
            else if (_wallpapers.isEmpty)
              const Text('No results yet. Try fetching your first batch.')
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadWallpapers,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _wallpapers.length,
                    itemBuilder: (context, index) {
                      final wallpaper = _wallpapers[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  WallpaperDetailScreen(wallpaper: wallpaper),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Hero(
                                tag: 'wallpaper-${wallpaper.id}',
                                child: CachedNetworkImage(
                                  imageUrl: wallpaper.previewUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(
                                    color: Colors.black12,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 8,
                                right: 8,
                                bottom: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    wallpaper.tags.take(2).join(' • '),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
