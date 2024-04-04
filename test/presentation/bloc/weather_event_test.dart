import 'package:flutter_test/flutter_test.dart';
import 'package:unit_test_demo/app/presentation/bloc/weather_bloc.dart';

void main() {
  group('OnCityChangedEvent', () {
    test('should return correct props', () {
      // Arrange
      const weatherApi = "weather";
      const queryParameters = {
        'Test-Param': 'Test-Param',
      };
      const onCityChangedEvent =
          OnCityChangedEvent(weatherApi, queryParameters);

      // Act
      final props = onCityChangedEvent.props;

      // Assert
      expect(props, [weatherApi, queryParameters]);
    });

    test('props are properly initialized', () {
      // Arrange
      const weatherApi = "weather";
      const queryParameters = {
        'Test-Param': 'Test-Param',
      };

      // Act
      const event = OnCityChangedEvent(weatherApi, queryParameters);

      // Assert
      expect(event.weatherApi, weatherApi);
      expect(event.queryParameters, queryParameters);
    });

    test('equality comparison works as expected', () {
      // Arrange
      const weatherApi = "weather";
      const queryParameters1 = {
        'Test-Param': 'Test-Param1',
      };
      const queryParameters3 = {
        'Test-Param': 'Test-Param3',
      };

      const event1 = OnCityChangedEvent(weatherApi, queryParameters1);
      const event2 = OnCityChangedEvent(weatherApi, queryParameters1);
      const event3 = OnCityChangedEvent(weatherApi, queryParameters3);

      // Assert
      expect(
          event1, equals(event2)); // events with same cityName should be equal
      expect(
          event1,
          isNot(equals(
              event3))); // events with different cityName should not be equal
    });
  });
}
