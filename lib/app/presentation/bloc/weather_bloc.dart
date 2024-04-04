import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:unit_test_demo/data/network/utility/api_response.dart';

import '../../../data/network/models/weather.dart';
import '../../../data/network/models/weather_model.dart';
import '../../../domain/usecase/weather_usecase.dart';

part 'weather_event.dart';

part 'weather_state.dart';

interface class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherUseCase weatherUseCase;

  WeatherBloc(this.weatherUseCase) : super(WeatherEmpty()) {
    on<OnCityChangedEvent>(_onCityChangedEvent);
  }

  FutureOr<void> _onCityChangedEvent(
      OnCityChangedEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    final result = await weatherUseCase.getWeather(
        event.weatherApi, event.queryParameters);
    if (result?.apiCallState == ApiCallState.success) {
      if (result != null && result.data != null) {
        emit(WeatherLoaded(WeatherModel.fromJson(result.data)));
      }
    } else {
      if (result != null && result.message != null) {
        emit(WeatherFailure(result.message!));
      }
    }
  }
}
