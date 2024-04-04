import 'dart:io';

// ApiResponse:-----------------------------------------------------------
class ApiResponse<T> {
  ApiCallState? apiCallState;
  T? data;
  String? message;

  ApiResponse.loading() : apiCallState = ApiCallState.loading;

  ApiResponse.success(this.data) : apiCallState = ApiCallState.success;

  ApiResponse.error(this.message) : apiCallState = ApiCallState.error;

  @override
  String toString() {
    return "ApiCallState : $apiCallState \n Message : $message \n Data : $data";
  }
}

// ApiCallState:-----------------------------------------------------------
enum ApiCallState { loading, success, error }

// ApiType:-----------------------------------------------------------
enum ApiType { get, getWithQuery, post, put, delete, multipart }

// ApiCallRequest:-----------------------------------------------------------
class ApiRequest {
  String? url;
  ApiType? apiType;
  Map<String, String>? queryParams;
  Map<String, dynamic>? request;
  File? file;

  ApiRequest(
      {required this.url,
      required this.apiType,
      this.queryParams,
      this.request,
      this.file});

  ApiRequest.fromJson(Map<String, dynamic> json) {
    apiType = json['apiType'];
    url = json['url'];
    request = json['requestParams'];
    queryParams = json['queryParams'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['apiType'] = apiType;
    data['url'] = url;
    data['requestParams'] = request;
    data['queryParams'] = queryParams;
    data['file'] = file;
    return data;
  }
}
