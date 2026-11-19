/// Build-time configuration.
///
/// Release 1 runs on local mock data. Point the app at the FastAPI backend with:
/// `flutter run --dart-define=USE_MOCK_DATA=false --dart-define=API_BASE_URL=https://api.example.com/v1`
abstract final class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8000/api/v1');

  static const bool useMockData = bool.fromEnvironment('USE_MOCK_DATA', defaultValue: true);

  /// Demo OTP accepted by the mock auth data source.
  static const String demoOtp = '1234';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);

  /// How often the remote slot source polls until a websocket channel exists.
  static const Duration slotPollInterval = Duration(seconds: 15);
}
