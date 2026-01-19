import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app_flutter/state/app_config.dart';

class AppConfigNotifier extends StateNotifier<AppConfigState> {
  AppConfigNotifier()
      : super(
          const AppConfigState(
            animeApiBaseUrl: 'https://danbooru.donmai.us',
            aiApiBaseUrl: 'http://localhost:7860',
          ),
        );

  void updateAnimeApiBaseUrl(String value) {
    state = state.copyWith(animeApiBaseUrl: value);
  }

  void updateAiApiBaseUrl(String value) {
    state = state.copyWith(aiApiBaseUrl: value);
  }
}

final appConfigProvider =
    StateNotifierProvider<AppConfigNotifier, AppConfigState>(
  (ref) => AppConfigNotifier(),
);
