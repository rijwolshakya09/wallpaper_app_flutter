class AppConfigState {
  const AppConfigState({
    required this.animeApiBaseUrl,
    required this.aiApiBaseUrl,
  });

  final String animeApiBaseUrl;
  final String aiApiBaseUrl;

  AppConfigState copyWith({
    String? animeApiBaseUrl,
    String? aiApiBaseUrl,
  }) {
    return AppConfigState(
      animeApiBaseUrl: animeApiBaseUrl ?? this.animeApiBaseUrl,
      aiApiBaseUrl: aiApiBaseUrl ?? this.aiApiBaseUrl,
    );
  }
}
