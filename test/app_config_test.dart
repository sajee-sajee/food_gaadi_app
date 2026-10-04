import 'package:flutter_test/flutter_test.dart';
import 'package:food_gaadi/app_config.dart';

void main() {
  test('Missing and invalid project configuration fails early', () {
    for (final url in ['', 'YOUR_SUPABASE_URL', 'http://example.com']) {
      expect(() => AppConfig(url: url, anonKey: 'public-key').validate(), throwsStateError);
    }
    expect(() => const AppConfig(url: 'https://example.supabase.co', anonKey: '').validate(), throwsStateError);
  });
  test('HTTPS project with public key is accepted', () {
    expect(() => const AppConfig(url: 'https://example.supabase.co', anonKey: 'public-key').validate(), returnsNormally);
  });
}
