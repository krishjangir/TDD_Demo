import 'package:flutter_test/flutter_test.dart';
import 'package:unit_test_demo/data/network/models/weather.dart';

void main() {
  group('WeatherEntity', () {
    test('should create a valid WeatherEntity instance', () {
      // Arrange
      const cityName = 'New York';
      const main = 'Clouds';
      const description = 'overcast clouds';
      const iconCode = '04d';
      const temperature = 25.0;
      const pressure = 1013;
      const humidity = 50;

      // Act
      const weatherEntity = WeatherEntity(
        cityName: cityName,
        main: main,
        description: description,
        iconCode: iconCode,
        temperature: temperature,
        pressure: pressure,
        humidity: humidity,
      );

      // Assert
      expect(weatherEntity.cityName, cityName);
      expect(weatherEntity.main, main);
      expect(weatherEntity.description, description);
      expect(weatherEntity.iconCode, iconCode);
      expect(weatherEntity.temperature, temperature);
      expect(weatherEntity.pressure, pressure);
      expect(weatherEntity.humidity, humidity);
    });

    test('should return correct props', () {
      // Arrange
      const cityName = 'New York';
      const main = 'Clouds';
      const description = 'overcast clouds';
      const iconCode = '04d';
      const temperature = 25.0;
      const pressure = 1013;
      const humidity = 50;

      const weatherEntity = WeatherEntity(
        cityName: cityName,
        main: main,
        description: description,
        iconCode: iconCode,
        temperature: temperature,
        pressure: pressure,
        humidity: humidity,
      );

      // Act
      final props = weatherEntity.props;

      // Assert
      expect(props.length, 7);
      expect(props, [
        cityName,
        main,
        description,
        iconCode,
        temperature,
        pressure,
        humidity,
      ]);
    });
  });
}