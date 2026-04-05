abstract final class AppEnv {
  static const String apiBaseUrl = String.fromEnvironment(
    'LEARNAI_API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000/api/v1',
  );
}
