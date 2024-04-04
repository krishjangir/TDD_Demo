import 'package:flutter_test/flutter_test.dart';
import 'package:unit_test_demo/data/network/utility/api_response.dart';

void main() {
  group('ApiResponse', () {
    test('toString() returns the expected string representation', () {
      final loadingResponse = ApiResponse.loading();
      expect(
        loadingResponse.toString(),
        equals(
            'ApiCallState : ${ApiCallState.loading} \n Message : null \n Data : null'),
      );

      final successResponse = ApiResponse.success('some_data');
      expect(
        successResponse.toString(),
        equals(
            'ApiCallState : ${ApiCallState.success} \n Message : null \n Data : some_data'),
      );

      final errorResponse = ApiResponse.error('error_message');
      expect(
        errorResponse.toString(),
        equals(
            'ApiCallState : ${ApiCallState.error} \n Message : error_message \n Data : null'),
      );
    });
  });

  group('ApiRequest', () {
    test('toJson() converts the object to JSON correctly', () {
      final request = ApiRequest(
        url: 'https://example.com',
        apiType: ApiType.get,
        queryParams: {'param1': 'value1'},
        request: {'key': 'value'},
        file: null,
      );
      final json = request.toJson();

      expect(json['url'], equals('https://example.com'));
      expect(json['apiType'], equals(ApiType.get));
      expect(json['requestParams'], equals({'key': 'value'}));
      expect(json['queryParams'], equals({'param1': 'value1'}));
      expect(json['file'], isNull);
    });

    test('fromJson() converts JSON to ApiRequest object correctly', () {
      final json = {
        'url': 'https://example.com',
        'apiType': ApiType.post,
        'requestParams': {'key': 'value'},
        'queryParams': {'param1': 'value1'},
        'file': null,
      };

      final request = ApiRequest.fromJson(json);

      expect(request.url, equals('https://example.com'));
      expect(request.apiType, equals(ApiType.post));
      expect(request.request, equals({'key': 'value'}));
      expect(request.queryParams, equals({'param1': 'value1'}));
      expect(request.file, isNull);
    });
  });
}
