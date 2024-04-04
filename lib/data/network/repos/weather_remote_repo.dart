import '../utility/api_response.dart';

abstract class WeatherRemoteRepo{
  Future<ApiResponse?> getWeather(String url,Map<String, String> queryParameters);
}