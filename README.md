# Anime Wallpaper Studio (Flutter)

A Flutter starter app for anime wallpaper discovery and AI generation.

## Features
- Browse anime wallpapers from a Danbooru-compatible API (defaults to Danbooru).
- Generate anime wallpapers using a self-hosted open-source AI endpoint (AUTOMATIC1111-compatible).
- Material 3 UI with tabs for browsing, generation, library, and in-app settings.
- Favorites are stored locally using shared preferences.
- Offline downloads cached with Hive, including local previews in the Library.
- Download, save to gallery, and (Android) set wallpaper actions.

## Configure APIs
Update the base URLs from the Settings screen in-app or edit the defaults in:
- `lib/state/app_config_provider.dart`

Defaults:
- Anime API: `https://danbooru.donmai.us`
- AI API: `http://localhost:7860` (AUTOMATIC1111 default)

## Run
```bash
flutter pub get
flutter run
```

## Notes
- Downloads are stored in the app documents directory (`wallpapers/`).
- Android can set wallpaper directly via `wallpaper_manager_flutter`; iOS users can save
  to Photos and set it manually.
- Remember to configure platform permissions for storage/photos per
  `permission_handler` and `image_gallery_saver`.
