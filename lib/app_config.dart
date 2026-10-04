class AppConfig {
  final String url;
  final String anonKey;
  const AppConfig({required this.url, required this.anonKey});
  const AppConfig.fromEnvironment()
      : url = const String.fromEnvironment('SUPABASE_URL'),
        anonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');

  void validate() {
    final parsed = Uri.tryParse(url);
    if (parsed == null || parsed.scheme != 'https' || parsed.host.isEmpty || anonKey.trim().isEmpty) {
      throw StateError('Provide SUPABASE_URL (https) and SUPABASE_ANON_KEY using --dart-define. See README.md.');
    }
  }
}
