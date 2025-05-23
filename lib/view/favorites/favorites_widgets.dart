import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/core/colors.dart';

import '../../core/global_functions.dart';
import '../../core/router.dart';
import '../../domain/data/remote/weather_api.dart';
import '../../domain/model/weather.dart';
import '../../view_model/favorites/favorites_bloc.dart';
import '../../view_model/favorites/favorites_event.dart';

class FavoritesWidgets {
  loadWeatherDetails(BuildContext context) async {
    final WeatherApi weatherApi = WeatherApi();
    final bloc = context.read<FavoritesBloc>();
    final List<Weather> localFavorites = bloc.state.favorites;
    try {
      for (var city in localFavorites) {
        final updated =
            await weatherApi.fetchWeatherByCityName(cityName: city.cityName);
        bloc.add(AddFavorite(updated));
      }
      if (!context.mounted) return;
      if (localFavorites.isEmpty) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Update successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please Try Again')),
      );
    }
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('Favorite Cities'),
    );
  }

  ListView weatherList(List listWeather, bool isDark) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: listWeather.length,
      itemBuilder: (context, index) {
        final weather = listWeather[index];
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, AppRouter.detail,
                arguments: {'weather': weather});
          },
          onLongPress: () {
            FavoritesWidgets().deleteAlert(context, weather);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              FavoritesWidgets().weatherInformation(weather, isDark),
              FavoritesWidgets().weatherIcon(weather, isDark),
            ],
          ),
        );
      },
    );
  }

  Container weatherInformation(Weather weather, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: isDark
                ? [
                    Colors.black.withOpacity(0.2),
                    ConstColors.purple2,
                  ]
                : [
                    ConstColors.purple1,
                    Colors.white,
                  ]),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: ConstColors.purple3.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(-10, 20),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weather.temperature.toString()}°C',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  GlobalFunctions().dayFormat(time: weather.date),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  GlobalFunctions().hourFormat(time: weather.date),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  '${weather.cityName}, ${weather.country}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Positioned weatherIcon(Weather weather, bool isDark) {
    return Positioned(
      top: -10,
      right: -2,
      child: Column(
        children: [
          Container(
            height: 130,
            width: 130,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 20,
                        ),
                      ]),
            child: Lottie.asset(
              GlobalFunctions().getWeatherLottie(weather.icon),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 35),
          Text(
            GlobalFunctions().timeZoneFormat(weather.timeZone),
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future deleteAlert(BuildContext context, Weather weather) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              IconData(0xe6cc, fontFamily: 'MaterialIcons'),
              color: Colors.red,
            ),
            SizedBox(width: 5),
            Text('Confirm Deletion')
          ],
        ),
        content: const Text('Are you sure you want to delete this city?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.red),
            onPressed: () {
              context.read<FavoritesBloc>().add(RemoveFavorite(weather));
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
