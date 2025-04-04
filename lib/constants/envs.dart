abstract class EnvConfig {

  static const String apikey = String.fromEnvironment("apiKey");
  static const String appId = String.fromEnvironment("appId");
  static const String messagingSenderId = String.fromEnvironment("messagingSenderId");
  static const String projectId = String.fromEnvironment("projectId");
  static const String storageBucket = String.fromEnvironment("storageBucket");
}
