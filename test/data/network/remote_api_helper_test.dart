import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_test_demo/data/network/remote_api_helper_impl.dart';
import 'package:http/http.dart' as http;
import 'package:unit_test_demo/data/network/utility/api_msg_strings.dart';
import 'package:unit_test_demo/data/network/utility/api_response.dart';
import 'package:unit_test_demo/data/network/utility/connectivity.dart';

// Mocking HttpClient
class MockHttpClient extends Mock implements http.Client {}

// Mocking ConnectionStatus
class MockConnectionStatus extends Mock implements ConnectionStatus {}

// Mocking http.Response
class MockResponse extends Mock implements http.Response {}

void main() {
  late RemoteApiHelperImpl remoteApiHelper;
  late http.Client mockHttpClient;
  const fakeBaseURL = 'http://example.com/';
  const fakeToken = 'fakeToken';
  late ConnectionStatus mockConnectionStatus;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockConnectionStatus = MockConnectionStatus();
    remoteApiHelper = RemoteApiHelperImpl(
      httpClient: mockHttpClient,
      baseUrl: fakeBaseURL,
      connectionStatus: mockConnectionStatus,
      apiHeaders: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $fakeToken'
      },
    );
  });

  group('safeApiCall', () {
    test('should return ApiResponse with success for a successful API call',
        () async {
      // Mock successful API response
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.bodyBytes)
          .thenReturn(utf8.encode('{"message": "Success"}'));
      final futureResponse = Future.value(mockResponse);

      // Mock connection status to return true
      when(() => mockConnectionStatus.checkConnection())
          .thenAnswer((_) => Future.value(true));

      // Call the method under test
      final response = await remoteApiHelper.safeApiCall(futureResponse);

      // Verify the response
      expect(response, isA<ApiResponse>());
      expect(response?.data, equals({'message': 'Success'}));
    });

    test('should return ApiResponse with error for 400 status code', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(400);
      when(() => mockResponse.body).thenReturn('Bad request');
      final futureResponse = Future.value(mockResponse);

      when(() => mockConnectionStatus.checkConnection())
          .thenAnswer((_) async => true);

      final response = await remoteApiHelper.safeApiCall(futureResponse);

      expect(response, isA<ApiResponse>());
      expect(response?.message, equals(ApiMsgStrings.txtInvalidRequest));
    });

    test('should return ApiResponse with error for 401 status code', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(401);
      when(() => mockResponse.body).thenReturn('Unauthorized');
      final futureResponse = Future.value(mockResponse);

      when(() => mockConnectionStatus.checkConnection())
          .thenAnswer((_) async => true);

      final response = await remoteApiHelper.safeApiCall(futureResponse);

      expect(response, isA<ApiResponse>());
      expect(response?.message, equals(ApiMsgStrings.txtUnauthorised));
    });

    test('should return ApiResponse with error for 403 status code', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(403);
      when(() => mockResponse.body).thenReturn('Unauthorized');
      final futureResponse = Future.value(mockResponse);

      when(() => mockConnectionStatus.checkConnection())
          .thenAnswer((_) async => true);

      final response = await remoteApiHelper.safeApiCall(futureResponse);

      expect(response, isA<ApiResponse>());
      expect(response?.message, equals(ApiMsgStrings.txtUnauthorised));
    });

    test('should return ApiResponse with error for 500 status code', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(500);
      when(() => mockResponse.body).thenReturn('Internal server error');
      final futureResponse = Future.value(mockResponse);

      when(() => mockConnectionStatus.checkConnection())
          .thenAnswer((_) async => true);

      final response = await remoteApiHelper.safeApiCall(futureResponse);

      expect(response, isA<ApiResponse>());
      expect(response?.message, ApiMsgStrings.txtInvalidRequest);
    });

    test('should return ApiResponse with error for timeout', () async {
      final futureResponse =
          Future.delayed(const Duration(seconds: 61), () => MockResponse());

      when(() => mockConnectionStatus.checkConnection())
          .thenAnswer((_) async => true);

      final response = await remoteApiHelper.safeApiCall(futureResponse);

      expect(response, isA<ApiResponse>());
      expect(response?.message, equals(ApiMsgStrings.txtConnectionTimeOut));
    }, timeout: const Timeout(Duration(seconds: 65)));

    test('should return ApiResponse with error for no internet connection',
        () async {
      when(() => mockConnectionStatus.checkConnection())
          .thenAnswer((_) async => false);

      final response =
          await remoteApiHelper.safeApiCall(Future.value(MockResponse()));

      expect(response, isA<ApiResponse>());
      expect(response?.message, equals(ApiMsgStrings.txtNoInternetConnection));
    });
  });

  test('should return ApiResponse with success for a successful DELETE request',
      () async {
    // Mock successful DELETE response
    const url = 'delete';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $fakeToken'
    };
    final mockResponse = MockResponse();
    when(() => mockResponse.statusCode).thenReturn(200);
    when(() => mockResponse.bodyBytes)
        .thenReturn(utf8.encode('{"message": "Deleted"}'));

    // Mock connection status to return true
    when(() => mockConnectionStatus.checkConnection())
        .thenAnswer((_) async => true);

    // Mock httpClient.delete method
    when(() => mockHttpClient.delete(Uri.parse(fakeBaseURL + url),
        headers: headers)).thenAnswer((_) async => mockResponse);

    // Call the method under test
    final response = await remoteApiHelper.deleteApiCall(url);

    // Verify the response
    expect(response, isA<ApiResponse>());
    expect(response?.data, equals({'message': 'Deleted'}));
  });

  test('should return ApiResponse with success for a successful GET request',
      () async {
    // Mock successful GET response
    const url = 'get';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $fakeToken'
    };
    final mockResponse = MockResponse();
    when(() => mockResponse.statusCode).thenReturn(200);
    when(() => mockResponse.bodyBytes)
        .thenReturn(utf8.encode('{"message": "Response"}'));

    // Mock connection status to return true
    when(() => mockConnectionStatus.checkConnection())
        .thenAnswer((_) async => true);

    // Mock httpClient.delete method
    when(() =>
            mockHttpClient.get(Uri.parse(fakeBaseURL + url), headers: headers))
        .thenAnswer((_) async => mockResponse);

    // Call the method under test
    final response = await remoteApiHelper.getApiCall(url);

    // Verify the response
    expect(response, isA<ApiResponse>());
    expect(response?.data, equals({'message': 'Response'}));
  });

  test(
      'should return ApiResponse with success for a successful GET with query request',
      () async {
    // Mock successful GET with query response
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

    // Mock httpClient.delete method
    when(() => mockHttpClient.get(
        Uri.parse(fakeBaseURL + url).replace(queryParameters: queryParameters),
        headers: headers)).thenAnswer((_) async => mockResponse);

    // Call the method under test
    final response =
        await remoteApiHelper.getApiCallWithQuery(url, queryParameters);

    // Verify the response
    expect(response, isA<ApiResponse>());
    expect(response?.data, equals({'message': 'Response'}));
  });

  test('should return ApiResponse with success for a successful POST request',
      () async {
    // Mock successful POST response
    const url = 'post';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $fakeToken'
    };
    final jsonData = {
      'Test-Param': 'Test-Param',
    };
    final mockResponse = MockResponse();
    when(() => mockResponse.statusCode).thenReturn(200);
    when(() => mockResponse.bodyBytes)
        .thenReturn(utf8.encode('{"message": "Response"}'));

    // Mock connection status to return true
    when(() => mockConnectionStatus.checkConnection())
        .thenAnswer((_) async => true);

    // Mock httpClient.delete method
    when(() => mockHttpClient.post(Uri.parse(fakeBaseURL + url),
        headers: headers,
        body: jsonEncode(jsonData))).thenAnswer((_) async => mockResponse);

    // Call the method under test
    final response = await remoteApiHelper.postApiCall(url, jsonData);

    // Verify the response
    expect(response, isA<ApiResponse>());
    expect(response?.data, equals({'message': 'Response'}));
  });

  test('should return ApiResponse with success for a successful PUT request',
      () async {
    // Mock successful PUT response
    const url = 'put';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $fakeToken'
    };
    final jsonData = {
      'Test-Param': 'Test-Param',
    };
    final mockResponse = MockResponse();
    when(() => mockResponse.statusCode).thenReturn(200);
    when(() => mockResponse.bodyBytes)
        .thenReturn(utf8.encode('{"message": "Response"}'));

    // Mock connection status to return true
    when(() => mockConnectionStatus.checkConnection())
        .thenAnswer((_) async => true);

    // Mock httpClient.delete method
    when(() => mockHttpClient.put(Uri.parse(fakeBaseURL + url),
        headers: headers,
        body: jsonEncode(jsonData))).thenAnswer((_) async => mockResponse);

    // Call the method under test
    final response = await remoteApiHelper.putApiCall(url, jsonData);

    // Verify the response
    expect(response, isA<ApiResponse>());
    expect(response?.data, equals({'message': 'Response'}));
  });

  test(
      'should return ApiResponse with success for successful POST multipart request',
      () async {
    // Arrange
    const url = 'post';
    const jsonData = {'key': 'value'};
    final file = File('test/assets/user.png');
    final expectedResponseData = {'message': 'Success'};
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $fakeToken'
    };
    const expectedStatusCode = 200;

    // Mocking http.MultipartFile
    final fileLength = await file.length();
    final mockMultipartFile = http.MultipartFile(
      'file',
      http.ByteStream(Stream.castFrom(file.openRead())),
      fileLength,
      filename: file.path.split('/').last,
    );

    // Mocking http.MultipartRequest
    final request =
        http.MultipartRequest('POST', Uri.parse('$fakeBaseURL$url'));
    request.headers.addAll(headers);
    request.files.add(mockMultipartFile);

    when(() => mockConnectionStatus.checkConnection())
        .thenAnswer((_) async => true);

    // Stubbing http.Client.send method
    when(() => mockHttpClient.send(request)).thenAnswer((_) async {
      final response = http.StreamedResponse(
        Stream.value(utf8.encode(json.encode(expectedResponseData))),
        expectedStatusCode,
      );
      return response;
    });

    // Act
    final apiResponse =
        await remoteApiHelper.postApiCallMultipart(url, jsonData, file);

    // Assert
    expect(apiResponse, isA<ApiResponse>());
  });
}
