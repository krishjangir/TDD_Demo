part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

interface class OnCityChangedEvent extends WeatherEvent {
  final String weatherApi;
  final Map<String, String> queryParameters;

  const OnCityChangedEvent(this.weatherApi, this.queryParameters);

  @override
  List<Object?> get props => [weatherApi, queryParameters];
}
