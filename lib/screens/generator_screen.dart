import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaper_app_flutter/services/ai_generation_client.dart';
import 'package:wallpaper_app_flutter/state/app_config_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneratorScreen extends ConsumerStatefulWidget {
  const GeneratorScreen({super.key});

  @override
  ConsumerState<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends ConsumerState<GeneratorScreen> {
  final _promptController = TextEditingController();
  final List<String> _styles = const [
    'anime cinematic',
    'soft pastel',
    'mecha noir',
    'studio ghibli',
  ];

  String _selectedStyle = 'anime cinematic';
  String? _generatedBase64;
  bool _isGenerating = false;
  String? _error;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_promptController.text.trim().isEmpty) {
      setState(() {
        _error = 'Please enter a prompt to generate artwork.';
      });
      return;
    }

    setState(() {
      _isGenerating = true;
      _error = null;
    });

    try {
      final config = ref.read(appConfigProvider);
      final aiClient = AiGenerationClient(baseUrl: config.aiApiBaseUrl);
      final base64 = await aiClient.generate(
        prompt: _promptController.text.trim(),
        style: _selectedStyle,
      );
      setState(() {
        _generatedBase64 = base64;
      });
    } catch (error) {
      setState(() {
        _error = error.toString();
      });
    } finally {
      setState(() {
        _isGenerating = false;
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
              'AI Wallpaper Lab',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Connected AI endpoint: ${config.aiApiBaseUrl}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                hintText: 'Describe your anime wallpaper idea',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedStyle,
              decoration: const InputDecoration(
                labelText: 'Style',
                border: OutlineInputBorder(),
              ),
              items: _styles
                  .map((style) => DropdownMenuItem(
                        value: style,
                        child: Text(style),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedStyle = value;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isGenerating ? null : _generate,
                icon: const Icon(Icons.auto_awesome),
                label: Text(_isGenerating ? 'Generating...' : 'Generate'),
              ),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              )
            else if (_generatedBase64 == null)
              const Expanded(
                child: Center(
                  child: Text('Generated artwork will appear here.'),
                ),
              )
            else
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(
                    base64Decode(_generatedBase64!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
