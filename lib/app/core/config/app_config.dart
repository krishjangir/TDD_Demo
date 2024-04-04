class AppConfig {
  static String baseUrl = '';
  static const String defaultLocale = 'en';
  static const String apiKey = "cc95d932d5a45d33a9527d5019475f2c";
  static const apiHeader = {
    'Content-Type': 'application/json; charset=UTF-8',
    'accept': 'text/plain'
  };

  static void configDev() {
    baseUrl = 'https://api.openweathermap.org/data/2.5/';
  }

  static void configStaging() {
    baseUrl = 'https://api.openweathermap.org/data/2.5/';
  }

  static void configProduction() {
    baseUrl = 'https://api.openweathermap.org/data/2.5/';
  }
}
