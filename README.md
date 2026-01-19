# Anime Wallpaper Studio (Flutter)

A Flutter starter app for anime wallpaper discovery and AI generation.

## Features
- Browse anime wallpapers from a Danbooru-compatible API (defaults to Danbooru).
- Generate anime wallpapers using a self-hosted open-source AI endpoint (AUTOMATIC1111-compatible).
- Material 3 UI with tabs for browsing, generation, library, and in-app settings.

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
- For Android wallpaper setting, consider adding a platform plugin such as `wallpaper_manager`.
- iOS does not allow setting wallpaper programmatically. Save to Photos and guide the user.
