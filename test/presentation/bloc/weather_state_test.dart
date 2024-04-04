import 'package:flutter_test/flutter_test.dart';
import 'package:unit_test_demo/app/presentation/bloc/weather_bloc.dart';
import 'package:unit_test_demo/data/network/models/weather.dart';

void main() {
  group('WeatherEmpty', () {
    test('should return correct props', () {
      // Arrange & Act
      final weatherEmpty = WeatherEmpty();

      // Assert
      expect(weatherEmpty.props, []);
    });
  });

  group('WeatherLoading', () {
    test('should return correct props', () {
      // Arrange & Act
      final weatherLoading = WeatherLoading();

      // Assert
      expect(weatherLoading.props, []);
    });
  });

  group('WeatherLoaded', () {
    test('should return correct props', () {
      // Arrange
      const weatherEntity = WeatherEntity(
        cityName: 'New York',
        main: 'Clouds',
        description: 'overcast clouds',
        iconCode: '04d',
        temperature: 25.0,
        pressure: 1013,
        humidity: 50,
      );
      const weatherLoaded = WeatherLoaded(weatherEntity);

      // Act
      final props = weatherLoaded.props;

      // Assert
      expect(props, [weatherEntity]);
    });
  });

  group('WeatherFailure', () {
    test('should return correct props', () {
      // Arrange
      const errorMessage = 'Failed to load weather data';
      const weatherFailure = WeatherFailure(errorMessage);

      // Act
      final props = weatherFailure.props;

      // Assert
      expect(props, [errorMessage]);
    });
  });
}