import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:unit_test_demo/app/presentation/ui/weather/widgets/table_row.dart';
import '../../../../data/network/utility/api_config.dart';
import '../../../core/config/app_config.dart';
import '../../../core/consts/consts.dart';
import '../../../core/utils/debouncer.dart';
import '../../bloc/weather_bloc.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deBouncer = DeBouncer(milliseconds: 500);
    return Scaffold(
      backgroundColor: const Color(0xdc045cbb),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    textAlign: TextAlign.center,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      hintText: 'Enter city name',
                      fillColor: const Color(0xffF3F3F3),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: (query) {
                      deBouncer.run(() {
                        context.read<WeatherBloc>().add(OnCityChangedEvent(
                            ApiConfig.weatherApi,
                            {'q': query, 'appid': AppConfig.apiKey}));
                      });
                    },
                  ),
                  const SizedBox(height: 32.0),
                  BlocBuilder<WeatherBloc, WeatherState>(
                    builder: (context, state) {
                      if (state is WeatherEmpty) {
                        return Center(
                          child:
                              Center(child: Lottie.asset(ASSETS.weatherLottie)),
                        );
                      }
                      if (state is WeatherLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is WeatherLoaded) {
                        return Column(
                          key: const Key('weather_data'),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.result.cityName,
                                  style: const TextStyle(
                                      fontSize: 22.0, color: Color(0xffF3F3F3)),
                                ),
                                Image(
                                  image: NetworkImage(
                                    URLS.weatherIcon(
                                      state.result.iconCode,
                                    ),
                                  ),
                                  color: const Color(0xffF3F3F3),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              '${state.result.main} | ${state.result.description}',
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  letterSpacing: 1.2,
                                  color: Color(0xffF3F3F3)),
                            ),
                            const SizedBox(height: 24.0),
                            Table(
                              defaultColumnWidth: const FixedColumnWidth(150.0),
                              border: TableBorder.all(
                                  style: BorderStyle.solid,
                                  width: 0.5,
                                  color: const Color(0xffF3F3F3)),
                              children: [
                                weatherTableRow("Temperature",
                                    state.result.temperature.toString()),
                                weatherTableRow("Pressure",
                                    state.result.pressure.toString()),
                                weatherTableRow("Humidity",
                                    state.result.humidity.toString()),
                              ],
                            ),
                          ],
                        );
                      }
                      if (state is WeatherFailure) {
                        return Center(
                          child: Text(state.message,
                              style: const TextStyle(color: Color(0xffF3F3F3))),
                        );
                      }
                      return Container();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
