import 'package:unit_test_demo/data/network/repos/weather_remote_repo.dart';
import 'package:unit_test_demo/data/network/utility/api_response.dart';

import '../remote_api_helper.dart';

interface class WeatherRemoteRepoImpl extends WeatherRemoteRepo {
  late RemoteApiHelper remoteApiHelper;

  WeatherRemoteRepoImpl({required this.remoteApiHelper});

  @override
  Future<ApiResponse?> getWeather(String url,Map<String, String> queryParameters) {
    return remoteApiHelper.getApiCallWithQuery(url,queryParameters);
  }
}
