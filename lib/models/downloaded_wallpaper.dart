import 'package:hive/hive.dart';
import 'package:wallpaper_app_flutter/models/wallpaper.dart';

@HiveType(typeId: 0)
class DownloadedWallpaper extends HiveObject {
  DownloadedWallpaper({
    required this.id,
    required this.previewUrl,
    required this.fullUrl,
    required this.tags,
    required this.source,
    required this.rating,
    required this.width,
    required this.height,
    required this.localPath,
    required this.downloadedAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String previewUrl;

  @HiveField(2)
  final String fullUrl;

  @HiveField(3)
  final List<String> tags;

  @HiveField(4)
  final String source;

  @HiveField(5)
  final String rating;

  @HiveField(6)
  final int width;

  @HiveField(7)
  final int height;

  @HiveField(8)
  final String localPath;

  @HiveField(9)
  final DateTime downloadedAt;

  factory DownloadedWallpaper.fromWallpaper({
    required Wallpaper wallpaper,
    required String localPath,
  }) {
    return DownloadedWallpaper(
      id: wallpaper.id,
      previewUrl: wallpaper.previewUrl,
      fullUrl: wallpaper.fullUrl,
      tags: wallpaper.tags,
      source: wallpaper.source,
      rating: wallpaper.rating,
      width: wallpaper.width,
      height: wallpaper.height,
      localPath: localPath,
      downloadedAt: DateTime.now(),
    );
  }

  Wallpaper toWallpaper() {
    return Wallpaper(
      id: id,
      previewUrl: previewUrl,
      fullUrl: fullUrl,
      tags: tags,
      source: source,
      rating: rating,
      width: width,
      height: height,
    );
  }
}

class DownloadedWallpaperAdapter extends TypeAdapter<DownloadedWallpaper> {
  @override
  final int typeId = 0;

  @override
  DownloadedWallpaper read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < fieldCount; i += 1) {
      fields[reader.readByte()] = reader.read();
    }
    return DownloadedWallpaper(
      id: fields[0] as String,
      previewUrl: fields[1] as String,
      fullUrl: fields[2] as String,
      tags: (fields[3] as List).cast<String>(),
      source: fields[4] as String,
      rating: fields[5] as String,
      width: fields[6] as int,
      height: fields[7] as int,
      localPath: fields[8] as String,
      downloadedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedWallpaper obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.previewUrl)
      ..writeByte(2)
      ..write(obj.fullUrl)
      ..writeByte(3)
      ..write(obj.tags)
      ..writeByte(4)
      ..write(obj.source)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.width)
      ..writeByte(7)
      ..write(obj.height)
      ..writeByte(8)
      ..write(obj.localPath)
      ..writeByte(9)
      ..write(obj.downloadedAt);
  }
}
