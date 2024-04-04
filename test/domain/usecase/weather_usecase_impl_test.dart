import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_test_demo/data/network/remote_api_helper.dart';
import 'package:unit_test_demo/data/network/repos/weather_remote_repo.dart';
import 'package:unit_test_demo/data/network/utility/api_response.dart';
import 'package:unit_test_demo/domain/usecase/weather_usecase_impl.dart';

// Create a mock class for RemoteApiHelper
class MockRemoteApiHelper extends Mock implements RemoteApiHelper {}

// Mocking WeatherRemoteRepo
class MockWeatherRemoteRepo extends Mock implements WeatherRemoteRepo {}

void main() {
  late WeatherUseCaseImpl weatherUseCaseImpl;
  late MockWeatherRemoteRepo mockWeatherRemoteRepo;

  setUp(() {
    mockWeatherRemoteRepo = MockWeatherRemoteRepo();
    weatherUseCaseImpl =
        WeatherUseCaseImpl(weatherRemoteRepo: mockWeatherRemoteRepo);
  });

  group('WeatherRemoteRepoImpl', () {
    test('getWeather returns ApiResponse', () async {
      // Mock successful GET response
      const url = 'get';
      final queryParameters = {
        'Test-Param': 'Test-Param',
      };
      when(() => mockWeatherRemoteRepo.getWeather(url, queryParameters))
          .thenAnswer((_) async =>
              Future.value(ApiResponse.success({"message": "Response"})));

      // Call the method under test
      final response =
          await weatherUseCaseImpl.getWeather(url, queryParameters);

      // Verify the response
      expect(response, isA<ApiResponse>());
      expect(response?.data, equals({'message': 'Response'}));
    });

    test('should return ApiResponse with error for 401 status code', () async {
      const url = 'get';
      final queryParameters = {
        'Test-Param': 'Test-Param',
      };
      when(() => mockWeatherRemoteRepo.getWeather(url, queryParameters))
          .thenAnswer(
              (_) async => Future.value(ApiResponse.error('Unauthorized')));

      // Call the method under test
      final response =
          await weatherUseCaseImpl.getWeather(url, queryParameters);

      // Verify the response
      expect(response, isA<ApiResponse>());
      expect(response?.message, equals('Unauthorized'));
    });
  });
}
