class Wallpaper {
  const Wallpaper({
    required this.id,
    required this.previewUrl,
    required this.fullUrl,
    required this.tags,
    required this.source,
    required this.rating,
    required this.width,
    required this.height,
  });

  final String id;
  final String previewUrl;
  final String fullUrl;
  final List<String> tags;
  final String source;
  final String rating;
  final int width;
  final int height;

  factory Wallpaper.fromApi(Map<String, dynamic> json) {
    return Wallpaper(
      id: json['id'].toString(),
      previewUrl: _readString(json, ['previewUrl', 'preview_file_url', 'preview_url']) ??
          _readString(json, ['file_url', 'large_file_url']) ??
          '',
      fullUrl: _readString(json, ['fullUrl', 'file_url', 'large_file_url']) ??
          _readString(json, ['preview_file_url', 'preview_url']) ??
          '',
      tags: _readString(json, ['tags', 'tag_string'])?.split(' ') ?? const [],
      source: _readString(json, ['source']) ?? 'unknown',
      rating: _readString(json, ['rating']) ?? 'safe',
      width: _readInt(json, ['image_width', 'width']) ?? 0,
      height: _readInt(json, ['image_height', 'height']) ?? 0,
    );
  }

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  static int? _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is int) {
        return value;
      }
      if (value is String) {
        return int.tryParse(value);
      }
    }
    return null;
  }
}
