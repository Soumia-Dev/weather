import 'package:flutter/material.dart';

import '../../core/global_functions.dart';
import '../../domain/model/weather.dart';
import 'home_detail_widgets.dart';

class DetailScreen extends StatelessWidget {
  final Weather weather;

  const DetailScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    HomeDetailWidgets widgets = HomeDetailWidgets();
    final Map groupedForecast =
        GlobalFunctions().forecastByDay(weather.forecast);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: widgets.backgroundScreen(isDark),
        ),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            widgets.sliverAppBar(weather, false, context, isDark),
            widgets.sliverAddFavorite(weather),
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
        ),
      ),
    );
  }
}
