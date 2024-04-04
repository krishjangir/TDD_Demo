sealed class URLS {
  static String weatherIcon(String iconCode) =>
      'http://openweathermap.org/img/wn/$iconCode@2x.png';
}

sealed class ASSETS {
  static const String weatherLottie = 'assets/lotties/weather_lottie.json';
}
