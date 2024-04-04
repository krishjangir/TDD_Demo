import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unit_test_demo/app/presentation/bloc/weather_bloc.dart';
import 'package:unit_test_demo/app/presentation/ui/weather/weather_screen.dart';

import '../dependency_injection.dart';
import 'core/config/app_config.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppConfig.configDev();
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => locator<WeatherBloc>(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Unit Test Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const WeatherScreen(),
        ));
  }
}
