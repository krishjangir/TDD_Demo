import 'api_msg_strings.dart';

class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, ApiMsgStrings.txtErrorDuringCommunication);
}

class BadRequestException extends AppException {
  BadRequestException([message])
      : super(message, ApiMsgStrings.txtInvalidRequest);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message])
      : super(message, ApiMsgStrings.txtUnauthorised);
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message])
      : super(message, ApiMsgStrings.txtInvalidInput);
}

class ForbiddenException extends AppException {
  ForbiddenException([String? message])
      : super(message, ApiMsgStrings.txtForbiddenException);
}

class NotFoundException extends AppException {
  NotFoundException([String? message])
      : super(message, ApiMsgStrings.txtNotFoundException);
}

class InternalServerErrorException extends AppException {
  InternalServerErrorException([String? message])
      : super(message, ApiMsgStrings.txtInternalServerException);
}
