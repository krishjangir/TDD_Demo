import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_test_demo/app/presentation/bloc/weather_bloc.dart';
import 'package:unit_test_demo/data/network/models/weather_model.dart';
import 'package:unit_test_demo/data/network/utility/api_response.dart';
import 'package:unit_test_demo/domain/usecase/weather_usecase.dart';

class MockWeatherUseCase extends Mock implements WeatherUseCase {}

void main() {
  late WeatherBloc weatherBloc;
  late MockWeatherUseCase mockWeatherUseCase;

  setUp(() {
    mockWeatherUseCase = MockWeatherUseCase();
    weatherBloc = WeatherBloc(mockWeatherUseCase);
  });

  tearDown(() {
    weatherBloc.close();
  });

  group('WeatherBloc', () {
    test('initial state is WeatherEmpty', () {
      expect(weatherBloc.state, WeatherEmpty());
    });

    test('emits [WeatherLoading, WeatherFailure] when OnCityChangedEvent fails',
        () async {
      // Arrange
      const weatherApi = 'weather';
      const errorMessage = 'Error Message';
      final apiResponse = ApiResponse.error(errorMessage);
      final queryParameters = {
        'Test-Param': 'Test-Param',
      };

      when(() => mockWeatherUseCase.getWeather(weatherApi, queryParameters))
          .thenAnswer((_) async => Future.value(apiResponse));
      // Act
      weatherBloc.add(OnCityChangedEvent(weatherApi, queryParameters));

      // Assert
      await expectLater(
        weatherBloc.stream,
        emitsInOrder([
          WeatherLoading(),
          const WeatherFailure(errorMessage),
        ]),
      );
    });

    test(
        'emits [WeatherLoading, WeatherLoaded] when OnCityChangedEvent is added',
        () async {
      // Arrange
      const weatherApi = 'weather';
      const weatherModel = WeatherModel(
          cityName: 'New York',
          main: 'Clouds',
          description: 'overcast clouds',
          iconCode: '04d',
          temperature: 25.0,
          pressure: 1013,
          humidity: 50);
      final queryParameters = {
        'Test-Param': 'Test-Param',
      };
      when(() => mockWeatherUseCase.getWeather(weatherApi, queryParameters))
          .thenAnswer((_) async =>
              Future.value(ApiResponse.success(weatherModel.toJson())));

      // Act
      weatherBloc.add(OnCityChangedEvent(weatherApi, queryParameters));

      // Assert
      await expectLater(
        weatherBloc.stream,
        emitsInOrder([
          WeatherLoading(),
          const WeatherLoaded(weatherModel),
        ]),
      );
    });
  });
}
