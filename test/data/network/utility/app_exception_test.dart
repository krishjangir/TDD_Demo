import 'package:flutter_test/flutter_test.dart';
import 'package:unit_test_demo/data/network/utility/api_msg_strings.dart';
import 'package:unit_test_demo/data/network/utility/app_exception.dart';

void main() {
  group('Exceptions', () {
    test('toString() returns the correct string representation', () {
      final fetchDataException = FetchDataException('Fetch data error');
      expect(fetchDataException.toString(), equals('${ApiMsgStrings.txtErrorDuringCommunication}Fetch data error'));

      final badRequestException = BadRequestException('Bad request error');
      expect(badRequestException.toString(), equals('${ApiMsgStrings.txtInvalidRequest}Bad request error'));

      final unauthorisedException = UnauthorisedException('Unauthorised error');
      expect(unauthorisedException.toString(), equals('${ApiMsgStrings.txtUnauthorised}Unauthorised error'));

      final invalidInputException = InvalidInputException('Invalid input error');
      expect(invalidInputException.toString(), equals('${ApiMsgStrings.txtInvalidInput}Invalid input error'));

      final forbiddenException = ForbiddenException('Forbidden error');
      expect(forbiddenException.toString(), equals('${ApiMsgStrings.txtForbiddenException}Forbidden error'));

      final notFoundException = NotFoundException('Not found error');
      expect(notFoundException.toString(), equals('${ApiMsgStrings.txtNotFoundException}Not found error'));

      final internalServerErrorException = InternalServerErrorException('Internal server error');
      expect(internalServerErrorException.toString(), equals('${ApiMsgStrings.txtInternalServerException}Internal server error'));
    });
  });
}