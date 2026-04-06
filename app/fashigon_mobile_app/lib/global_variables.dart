/// Backend API base URL (no trailing slash).
///
/// Staging/production: run with
/// `flutter run --dart-define=API_BASE_URL=https://your-api.example.com`
///
/// Physical device on same Wi‑Fi: use your PC's LAN IP, not localhost.
const String _defaultApiBase = 'http://192.168.68.54:3000';

String get uri {
  const fromEnv = String.fromEnvironment('API_BASE_URL');
  return fromEnv.isNotEmpty ? fromEnv : _defaultApiBase;
}
