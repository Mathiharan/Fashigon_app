/// Backend API base URL (no trailing slash).
///
/// `flutter run --dart-define=API_BASE_URL=https://your-api.example.com`
const String _defaultApiBase = 'http://192.168.68.54:3000';

String get uri {
  const fromEnv = String.fromEnvironment('API_BASE_URL');
  return fromEnv.isNotEmpty ? fromEnv : _defaultApiBase;
}
