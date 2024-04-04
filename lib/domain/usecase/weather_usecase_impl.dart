import 'package:unit_test_demo/data/network/utility/api_response.dart';
import 'package:unit_test_demo/domain/usecase/weather_usecase.dart';

import '../../data/network/repos/weather_remote_repo.dart';

interface class WeatherUseCaseImpl extends WeatherUseCase {
  late WeatherRemoteRepo weatherRemoteRepo;

  WeatherUseCaseImpl({required this.weatherRemoteRepo});

  @override
  Future<ApiResponse?> getWeather(String url,Map<String, String> queryParameters) {
    return weatherRemoteRepo.getWeather(url,queryParameters);
  }
}
