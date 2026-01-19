import 'package:dio/dio.dart';
import 'package:wallpaper_app_flutter/models/wallpaper.dart';

class AnimeApiClient {
  AnimeApiClient({required this.baseUrl, Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 15),
              ),
            );

  final String baseUrl;
  final Dio _dio;

  Future<List<Wallpaper>> fetchWallpapers({
    required int page,
    required String tags,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      '/posts.json',
      queryParameters: {
        'page': page,
        'tags': '$tags rating:safe',
        'limit': 30,
      },
    );

    final payload = response.data ?? [];
    return payload
        .whereType<Map<String, dynamic>>()
        .map(Wallpaper.fromApi)
        .where((wallpaper) => wallpaper.previewUrl.isNotEmpty)
        .toList();
  }
}
