import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/global_functions.dart';
import '../../view_model/weather/location/weather_location_bloc.dart';
import 'home_detail_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    HomeDetailWidgets widgets = HomeDetailWidgets();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => widgets.onRefresh(context),
        child: Container(
          decoration: BoxDecoration(
            gradient: widgets.backgroundScreen(isDark),
          ),
          child: BlocBuilder<WeatherLocationBloc, WeatherLocationState>(
            builder: (context, state) {
              if (state is WeatherLoading) {
                return Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              } else if (state is LocationWeatherLoaded) {
                final weather = state.weather;
                final Map groupedForecast =
                    GlobalFunctions().forecastByDay(weather.forecast);
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    widgets.sliverAppBar(weather, true, context, isDark),
                    widgets.sliverWeatherMain([
                      widgets.weatherMain(
                          'sunrise', Colors.yellow, 'Sunrise', weather.sunrise),
                      widgets.weatherMain(
                          'sunset', Colors.orange, 'Sunset', weather.sunset)
                    ]),
                    widgets.sliverWeatherMain([
                      widgets.weatherMain(
                        'humidity',
                        Colors.blue,
                        'Humidity',
                        '${weather.humidity.toString()}%',
                      ),
                      widgets.weatherMain(
                        'wind',
                        Colors.grey,
                        'wind',
                        '${weather.wind.toString()} Km/h',
                      ),
                      widgets.weatherMain(
                        'pressure',
                        Colors.blue,
                        'Pressure',
                        '${weather.pressure.toString()} mb',
                      ),
                    ]),
                    widgets.sliverList(groupedForecast, isDark),
                  ],
                );
              }
              if (state is WeatherError) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
