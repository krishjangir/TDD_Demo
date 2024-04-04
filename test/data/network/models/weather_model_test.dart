import 'package:flutter_test/flutter_test.dart';
import 'package:unit_test_demo/data/network/models/weather_model.dart';

void main() {
  group('WeatherModel', () {
    test('fromJson creates a valid WeatherModel instance', () {
      // Arrange
      final json = {
        'name': 'New York',
        'weather': [
          {'main': 'Clouds', 'description': 'overcast clouds', 'icon': '04d'}
        ],
        'main': {'temp': 25.0, 'pressure': 1013, 'humidity': 50}
      };

      // Act
      final weatherModel = WeatherModel.fromJson(json);

      // Assert
      expect(weatherModel.cityName, 'New York');
      expect(weatherModel.main, 'Clouds');
      expect(weatherModel.description, 'overcast clouds');
      expect(weatherModel.iconCode, '04d');
      expect(weatherModel.temperature, 25.0);
      expect(weatherModel.pressure, 1013);
      expect(weatherModel.humidity, 50);
    });

    test('toJson returns the correct JSON representation', () {
      // Arrange
      const weatherModel = WeatherModel(
        cityName: 'New York',
        main: 'Clouds',
        description: 'overcast clouds',
        iconCode: '04d',
        temperature: 25.0,
        pressure: 1013,
        humidity: 50,
      );

      // Act
      final json = weatherModel.toJson();

      // Assert
      expect(json['name'], 'New York');
      expect(json['weather'][0]['main'], 'Clouds');
      expect(json['weather'][0]['description'], 'overcast clouds');
      expect(json['weather'][0]['icon'], '04d');
      expect(json['main']['temp'], 25.0);
      expect(json['main']['pressure'], 1013);
      expect(json['main']['humidity'], 50);
    });

    test('toEntity returns the equivalent WeatherEntity', () {
      // Arrange
      const weatherModel = WeatherModel(
        cityName: 'New York',
        main: 'Clouds',
        description: 'overcast clouds',
        iconCode: '04d',
        temperature: 25.0,
        pressure: 1013,
        humidity: 50,
      );

      // Act
      final weatherEntity = weatherModel.toEntity();

      // Assert
      expect(weatherEntity.cityName, 'New York');
      expect(weatherEntity.main, 'Clouds');
      expect(weatherEntity.description, 'overcast clouds');
      expect(weatherEntity.iconCode, '04d');
      expect(weatherEntity.temperature, 25.0);
      expect(weatherEntity.pressure, 1013);
      expect(weatherEntity.humidity, 50);
    });
  });
}