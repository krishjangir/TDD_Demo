import '../../data/network/utility/api_response.dart';

abstract class WeatherUseCase{
  Future<ApiResponse?> getWeather(String url,Map<String, String> queryParameters);
}