import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_test_demo/data/network/utility/connectivity.dart';

class MockConnectivity extends Mock implements Connectivity {}

class InternetAddressWrapper {
  static Future<List<InternetAddress>> lookup(String host,
      {InternetAddressType type = InternetAddressType.any}) async {
    return await InternetAddress.lookup(host, type: type);
  }
}

class MockInternetAddressWrapper extends Mock {
  Future<List<InternetAddress>> lookup(String host,
      {InternetAddressType type = InternetAddressType.any});
}

void main() {
  late ConnectionStatus connectionStatus;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    connectionStatus = ConnectionStatus(connectivity: mockConnectivity);
  });

  setUpAll(() {
    registerFallbackValue(InternetAddressType.any);
  });

  group('ConnectionStatus', () {
    test('initialize method subscribes to connectivity changes', () {
      // Arrange
      when(() => mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => Stream.value(ConnectivityResult.mobile));

      // Act
      connectionStatus.initialize();

      // Assert
      verify(() => mockConnectivity.onConnectivityChanged.listen(any()))
          .called(1);
    });

    test('dispose method closes the StreamController', () {
      // Act
      connectionStatus.dispose();

      // Assert
      expect(connectionStatus.connectionChangeController.isClosed, isTrue);
    });

    test('checkConnection method updates connection status', () async {
      // Arrange
      // Mocking InternetAddressWrapper
      final mockInternetAddressWrapper = MockInternetAddressWrapper();
      when(() => mockInternetAddressWrapper.lookup(any(),
              type: any(named: 'type')))
          .thenAnswer((_) async => [InternetAddress('google.com')]);

      // Act
      final result = await connectionStatus.checkConnection();

      // Assert
      expect(result, isTrue);
      expect(connectionStatus.hasConnection, isTrue);
    });

    test(
        'connectionChange getter returns the stream from connectionChangeController',
        () {
      // Act
      final resultStream = connectionStatus.connectionChange;

      // Assert
      expect(resultStream,
          equals(connectionStatus.connectionChangeController.stream));
    });
  });
}
