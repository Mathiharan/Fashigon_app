/// Backend API base URL (no trailing slash).
///
/// `flutter run -d chrome --dart-define=API_BASE_URL=https://your-api.example.com`
const String _defaultApiBase = 'http://localhost:3000';

String get uri {
  const fromEnv = String.fromEnvironment('API_BASE_URL');
  return fromEnv.isNotEmpty ? fromEnv : _defaultApiBase;
}
