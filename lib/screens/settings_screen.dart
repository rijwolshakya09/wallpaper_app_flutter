import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app_flutter/state/app_config_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _animeController;
  late final TextEditingController _aiController;

  @override
  void initState() {
    super.initState();
    final config = ref.read(appConfigProvider);
    _animeController = TextEditingController(text: config.animeApiBaseUrl);
    _aiController = TextEditingController(text: config.aiApiBaseUrl);
  }

  @override
  void dispose() {
    _animeController.dispose();
    _aiController.dispose();
    super.dispose();
  }

  void _save() {
    ref
        .read(appConfigProvider.notifier)
        .updateAnimeApiBaseUrl(_animeController.text.trim());
    ref
        .read(appConfigProvider.notifier)
        .updateAiApiBaseUrl(_aiController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('API settings updated.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'API Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _animeController,
              decoration: const InputDecoration(
                labelText: 'Anime API Base URL',
                helperText: 'Example: https://danbooru.donmai.us',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _aiController,
              decoration: const InputDecoration(
                labelText: 'AI Generation Base URL',
                helperText: 'Example: https://your-ai-service.com',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Use a self-hosted open-source AI server to keep generation free.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
