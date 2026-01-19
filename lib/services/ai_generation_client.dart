import 'package:dio/dio.dart';

class AiGenerationClient {
  AiGenerationClient({required this.baseUrl, Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 60),
              ),
            );

  final String baseUrl;
  final Dio _dio;

  Future<String> generate({
    required String prompt,
    required String style,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/sdapi/v1/txt2img',
      data: {
        'prompt': '$prompt, $style, anime style, high detail',
        'steps': 25,
        'width': 768,
        'height': 1280,
      },
    );

    final payload = response.data;
    if (payload == null || payload['images'] is! List) {
      throw Exception('Invalid response from AI server.');
    }

    final images = payload['images'] as List;
    if (images.isEmpty || images.first is! String) {
      throw Exception('AI server returned no images.');
    }

    return images.first as String;
  }
}
