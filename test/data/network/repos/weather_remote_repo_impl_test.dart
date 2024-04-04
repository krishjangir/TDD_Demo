import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_test_demo/data/network/remote_api_helper.dart';
import 'package:unit_test_demo/data/network/repos/weather_remote_repo_impl.dart';
import 'package:unit_test_demo/data/network/utility/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:unit_test_demo/data/network/utility/connectivity.dart';

// Create a mock class for RemoteApiHelper
class MockRemoteApiHelper extends Mock implements RemoteApiHelper {}

// Mocking HttpClient
class MockHttpClient extends Mock implements http.Client {}

// Mocking ConnectionStatus
class MockConnectionStatus extends Mock implements ConnectionStatus {}

// Mocking http.Response
class MockResponse extends Mock implements http.Response {}

void main() {
  late http.Client mockHttpClient;
  const fakeBaseURL = 'http://example.com/';
  const fakeToken = 'fakeToken';
  late ConnectionStatus mockConnectionStatus;
  late WeatherRemoteRepoImpl weatherRemoteRepo;
  late MockRemoteApiHelper mockRemoteApiHelper;

  setUp(() {
    mockRemoteApiHelper = MockRemoteApiHelper();
    weatherRemoteRepo =
        WeatherRemoteRepoImpl(remoteApiHelper: mockRemoteApiHelper);
    mockHttpClient = MockHttpClient();
    mockConnectionStatus = MockConnectionStatus();
  });

  group('WeatherRemoteRepoImpl', () {
    test('getWeather returns ApiResponse', () async {
      // Mock successful GET response
      const url = 'get';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $fakeToken'
      };
      final queryParameters = {
        'Test-Param': 'Test-Param',
      };
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.bodyBytes)
          .thenReturn(utf8.encode('{"message": "Response"}'));

      // Mock connection status to return true
      when(() => mockConnectionStatus.checkConnection())
          .thenAnswer((_) async => true);

      // Mock httpClient.get method
      when(() => mockHttpClient.get(Uri.parse(fakeBaseURL + url),
          headers: headers)).thenAnswer((_) async => mockResponse);

      when(() => mockRemoteApiHelper.getApiCallWithQuery(url,queryParameters)).thenAnswer((_) async =>
          Future.value(ApiResponse.success({"message": "Response"})));

      // Call the method under test
      final response = await weatherRemoteRepo.getWeather(url,queryParameters);

      // Verify the response
      expect(response, isA<ApiResponse>());
      expect(response?.data, equals({'message': 'Response'}));
    });

    test('should return ApiResponse with error for 401 status code', () async {
      const url = 'get';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $fakeToken'
      };
      final queryParameters = {
        'Test-Param': 'Test-Param',
      };
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(401);
      when(() => mockResponse.body).thenReturn('Unauthorized');

      when(() => mockConnectionStatus.checkConnection())
          .thenAnswer((_) async => true);

      // Mock httpClient.get method
      when(() => mockHttpClient.get(Uri.parse(fakeBaseURL + url),
          headers: headers)).thenAnswer((_) async => mockResponse);

      when(() => mockRemoteApiHelper.getApiCallWithQuery(url,queryParameters)).thenAnswer(
          (_) async => Future.value(ApiResponse.error('Unauthorized')));

      // Call the method under test
      final response = await weatherRemoteRepo.getWeather(url,queryParameters);

      // Verify the response
      expect(response, isA<ApiResponse>());
      expect(response?.message, equals('Unauthorized'));
    });
  });
}
