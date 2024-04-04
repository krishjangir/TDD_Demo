import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:unit_test_demo/data/network/repos/weather_remote_repo.dart';
import 'package:unit_test_demo/domain/usecase/weather_usecase_impl.dart';

import 'app/core/config/app_config.dart';
import 'app/presentation/bloc/weather_bloc.dart';
import 'package:http/http.dart' as http;

import 'data/network/remote_api_helper.dart';
import 'data/network/remote_api_helper_impl.dart';
import 'data/network/repos/weather_remote_repo_impl.dart';
import 'data/network/utility/connectivity.dart';
import 'domain/usecase/weather_usecase.dart';

final locator = GetIt.instance;

void initDI() {
  // WeatherBloc
  locator.registerFactory(() => WeatherBloc(locator()));

  // WeatherUseCase
  locator.registerLazySingleton<WeatherUseCase>(
      () => WeatherUseCaseImpl(weatherRemoteRepo: locator()));

  // WeatherRemoteRepo
  locator.registerLazySingleton<WeatherRemoteRepo>(
    () => WeatherRemoteRepoImpl(remoteApiHelper: locator()),
  );

  // RemoteApiHelper
  locator.registerLazySingleton<RemoteApiHelper>(
    () => RemoteApiHelperImpl(
        httpClient: locator(),
        baseUrl: AppConfig.baseUrl,
        connectionStatus: locator(),
        apiHeaders: AppConfig.apiHeader),
  );

  // http.Client
  locator.registerLazySingleton(() => http.Client());

  // ConnectionStatus
  locator
      .registerLazySingleton(() => ConnectionStatus(connectivity: locator()));

  // Connectivity
  locator.registerLazySingleton(() => Connectivity());
}
