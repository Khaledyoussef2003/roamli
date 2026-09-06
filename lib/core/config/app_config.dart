/// Central compile-time configuration for production integrations.
///
/// Example when APIs are ready:
/// flutter run --dart-define=ROAMLI_API_BASE_URL=https://api.example.com
///
/// Never commit secret server keys to the mobile application. Android/iOS map
/// keys should be platform-restricted and server-side billable calls should be
/// protected behind the ROAMLI backend where appropriate.
abstract final class AppConfig {
  static const apiBaseUrl = String.fromEnvironment('ROAMLI_API_BASE_URL', defaultValue: '');
  static const mockMode = bool.fromEnvironment('ROAMLI_MOCK_MODE', defaultValue: true);

  static bool get productionServicesConfigured => apiBaseUrl.isNotEmpty && !mockMode;
}
