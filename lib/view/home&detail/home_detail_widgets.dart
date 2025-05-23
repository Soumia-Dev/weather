import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../core/colors.dart';
import '../../core/global_functions.dart';
import '../../core/router.dart';
import '../../domain/model/weather.dart';
import '../../view_model/favorites/favorites_bloc.dart';
import '../../view_model/favorites/favorites_event.dart';
import '../../view_model/favorites/favorites_state.dart';
import '../../view_model/theme/theme_bloc.dart';
import '../../view_model/theme/theme_event.dart';
import '../../view_model/weather/city_name/weather_city_bloc.dart';
import '../../view_model/weather/location/weather_location_bloc.dart'
    as location;

class HomeDetailWidgets {
  Future<void> onRefresh(BuildContext context) async {
    final bloc = context.read<location.WeatherLocationBloc>();
    final completer = Completer();
    final subscription = bloc.stream.listen((state) {
      if (state is location.LocationWeatherLoaded ||
          state is location.WeatherError) {
        completer.complete();
      }
    });

    bloc.add(location.RefreshWeatherByLocation());

    await completer.future;
    await subscription.cancel(); // Clean up listener
  }

  LinearGradient backgroundScreen(bool isDark) {
    return LinearGradient(
      colors: isDark
          ? [
              ConstColors.purple1,
              Colors.black,
              ConstColors.purple1,
            ]
          : [
              Colors.white,
              ConstColors.purple4,
              Colors.white,
              ConstColors.purple4,
              Colors.white,
              ConstColors.purple4,
            ],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    );
  }

  Gradient backgroundAppBar(bool isDark) {
    return RadialGradient(
      colors: isDark
          ? [
              ConstColors.purple1,
              ConstColors.purple1.withOpacity(0.5),
            ]
          : [ConstColors.purple3, ConstColors.purple4],
    );
  }

  SliverAppBar sliverAppBar(
      Weather weather, bool actions, BuildContext context, bool isDark) {
    final height = MediaQuery.sizeOf(context).height;
    final orientation = MediaQuery.of(context).orientation;
    final themeMode = context.select<ThemeBloc, ThemeMode>(
      (bloc) => bloc.state.themeMode,
    );
    final brightness = (themeMode == ThemeMode.system)
        ? MediaQuery.of(context).platformBrightness
        : (themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light);

    return SliverAppBar(
        pinned: true,
        expandedHeight: orientation == Orientation.portrait
            ? height / 2 + 50
            : height * 14 / 15,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(100),
          ),
        ),
        actions: actions
            ? [
                IconButton(
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.favorites);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.brightness_6),
                  onPressed: () {
                    context.read<ThemeBloc>().add(ToggleTheme(brightness));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.search);
                  },
                ),
              ]
            : null,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.only(left: 40, bottom: 16),
          title: Text(
            "${weather.cityName} ${weather.country}",
            style: const TextStyle(fontSize: 15),
          ),
          background: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                  gradient: backgroundAppBar(isDark),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: Lottie.asset(
                        GlobalFunctions().getWeatherLottie(weather.icon),
                        height: 100),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '${weather.temperature.toString()}°C',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(weather.description),
                        Text(
                          GlobalFunctions().dayFormat(time: weather.date),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  SliverToBoxAdapter sliverAddFavorite(Weather weather) {
    return SliverToBoxAdapter(
      child: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          final isNotFavorite = !state.favorites.any(
            (item) => item.cityId == weather.cityId,
          );
          return (isNotFavorite)
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<FavoritesBloc>().add(AddFavorite(weather));
                      context.read<WeatherCityBloc>().add(ResetWeather());
                      Navigator.pushReplacementNamed(
                          context, AppRouter.favorites);
                    },
                    child: const Text("Add to Favorites"),
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }

  SliverToBoxAdapter sliverWeatherMain(List<Widget> weatherMain) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: ConstColors.purple1.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weatherMain,
        ),
      ),
    );
  }

  SliverList sliverList(Map groupedForecast, bool isDark) {
    final List entries = groupedForecast.entries.toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: groupedForecast.length,
        (context, index) {
          final date = entries[index].key;
          final hours = entries[index].value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  date,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 170,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: hours.length,
                  itemBuilder: (context, i) {
                    final hour = hours[i];
                    return Container(
                      width: 80,
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            isDark ? ConstColors.purple1 : ConstColors.purple4,
                        border: Border.all(
                          width: 2.0,
                          color: isDark
                              ? ConstColors.purple3
                              : ConstColors.purple1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ConstColors.purple1,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(hour.date.split(' ')[1].substring(0, 5)),
                          const SizedBox(height: 15),
                          Text("${hour.temperature}°C"),
                          Lottie.asset(
                            GlobalFunctions().getWeatherLottie(hour.icon),
                            height: 50,
                            width: 50,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Column weatherMain(String icon, Color color, String title, String data) {
    return Column(
      children: [
        SvgPicture.asset(
          "assets/icons/$icon.svg",
          height: 70,
          colorFilter: ColorFilter.mode(
            color,
            BlendMode.srcIn,
          ),
        ),
        Text(title),
        Text(
          data,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
