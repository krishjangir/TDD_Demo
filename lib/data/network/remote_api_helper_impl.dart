import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:unit_test_demo/data/network/remote_api_helper.dart';
import 'package:unit_test_demo/data/network/utility/api_msg_strings.dart';
import 'package:unit_test_demo/data/network/utility/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:unit_test_demo/data/network/utility/app_exception.dart';
import 'package:unit_test_demo/data/network/utility/connectivity.dart';
import 'package:unit_test_demo/data/network/utility/network_log_utils.dart';

interface class RemoteApiHelperImpl extends RemoteApiHelper {
  final http.Client httpClient;
  final String baseUrl;
  final Map<String, String> apiHeaders;
  final ConnectionStatus connectionStatus;

  RemoteApiHelperImpl(
      {required this.httpClient,
      required this.baseUrl,
      required this.connectionStatus,
      required this.apiHeaders});

  @override
  Future<ApiResponse?> deleteApiCall(String url) {
    NetworkLogUtils.printLogs(
        logs: 'DeleteApiCall: url = $url', isDebugMode: kDebugMode);
    final response = safeApiCall(httpClient.delete(
      Uri.parse(baseUrl + url),
      headers: apiHeaders,
    ));
    return response;
  }

  @override
  Future<ApiResponse?> getApiCall(String url) {
    NetworkLogUtils.printLogs(
        logs: 'GetApiCall: url = $url', isDebugMode: kDebugMode);
    final response = safeApiCall(httpClient.get(
      Uri.parse(baseUrl + url),
      headers: apiHeaders,
    ));
    return response;
  }

  @override
  Future<ApiResponse?> getApiCallWithQuery(
      String url, Map<String, String> queryParameters) {
    var uri = Uri.parse(baseUrl + url);
    uri = uri.replace(queryParameters: queryParameters);
    NetworkLogUtils.printLogs(
        logs: 'GetApiCallWithQuery: url = $uri', isDebugMode: kDebugMode);
    final response = safeApiCall(httpClient.get(
      uri,
      headers: apiHeaders,
    ));
    return response;
  }

  @override
  Future<ApiResponse?> postApiCall(String url, Map<String, dynamic> jsonData) {
    NetworkLogUtils.printLogs(
        logs: 'PostApiCall: url = $url', isDebugMode: kDebugMode);
    NetworkLogUtils.printLogs(
        logs: 'PostApiCall request- ${jsonEncode(jsonData)}',
        isDebugMode: kDebugMode);
    final response = safeApiCall(httpClient.post(Uri.parse(baseUrl + url),
        headers: apiHeaders, body: jsonEncode(jsonData)));
    return response;
  }

  @override
  Future<ApiResponse?> putApiCall(String url, Map<String, dynamic> jsonData) {
    NetworkLogUtils.printLogs(
        logs: 'PutApiCall: url = $url', isDebugMode: kDebugMode);
    NetworkLogUtils.printLogs(
        logs: 'PutApiCall request- ${jsonEncode(jsonData)}',
        isDebugMode: kDebugMode);
    final response = safeApiCall(httpClient.put(Uri.parse(baseUrl + url),
        headers: apiHeaders, body: jsonEncode(jsonData)));
    return response;
  }

  @override
  Future<ApiResponse?> postApiCallMultipart(
      String url, Map<String, dynamic> jsonData, File file) async {
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + url));
    request.headers.addAll(apiHeaders);
    request.files.add(
      http.MultipartFile(
        'file',
        http.ByteStream(Stream.castFrom(file.openRead())),
        await file.length(),
        filename: file.path.split('/').last,
      ),
    );
    var response = safeApiCall(http.Response.fromStream(await request.send()));
    return response;
  }

// SafeApiCall:--------------------------------safe api call---------------------------------------
  Future<ApiResponse?> safeApiCall(Future<http.Response> apiResponse) async {
    if (await connectionStatus.checkConnection()) {
      try {
        final response = await apiResponse.timeout(const Duration(seconds: 60));
        return ApiResponse.success(_returnResponse(response));
      } on BadRequestException {
        return ApiResponse.error(ApiMsgStrings.txtInvalidRequest);
      } on UnauthorisedException {
        return ApiResponse.error(ApiMsgStrings.txtUnauthorised);
      } on FetchDataException {
        return ApiResponse.error(ApiMsgStrings.txtInvalidRequest);
      } on TimeoutException {
        return ApiResponse.error(ApiMsgStrings.txtConnectionTimeOut);
      } on SocketException {
        return ApiResponse.error(ApiMsgStrings.txtNoInternetConnection);
      } catch (e) {
        return ApiResponse.error(e.toString());
      }
    } else {
      return ApiResponse.error(ApiMsgStrings.txtNoInternetConnection);
    }
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(utf8.decode(response.bodyBytes));
        NetworkLogUtils.printLogs(
            logs: responseJson.toString(), isDebugMode: kDebugMode);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            '${ApiMsgStrings.txtServerError} ${response.statusCode}');
    }
  }
}
