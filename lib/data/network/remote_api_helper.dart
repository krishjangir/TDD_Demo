import 'dart:io';

import 'utility/api_response.dart';

abstract class RemoteApiHelper {
  Future<ApiResponse?> getApiCallWithQuery(
      String url, Map<String, String> queryParameters);

  Future<ApiResponse?> getApiCall(String url);

  Future<ApiResponse?> postApiCall(String url, Map<String, dynamic> jsonData);

  Future<ApiResponse?> putApiCall(String url, Map<String, dynamic> jsonData);

  Future<ApiResponse?> deleteApiCall(String url);

  Future<ApiResponse?> postApiCallMultipart(
      String url, Map<String, dynamic> jsonData, File file);
}
