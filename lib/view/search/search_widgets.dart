import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/core/global_functions.dart';

import '../../core/colors.dart';
import '../../core/router.dart';
import '../../view_model/weather/city_name/weather_city_bloc.dart';

class SearchWidgets {
  AppBar appBar(bool isDark) {
    return AppBar(
      title: const Text("Search Weather"),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      systemOverlayStyle:
          isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );
  }

  Widget textField(
      TextEditingController controller, BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: isDark ? ConstColors.purple3 : ConstColors.purple1,
            spreadRadius: 10,
            blurRadius: 150,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          if (value == '') {
            context.read<WeatherCityBloc>().add(ResetWeather());
          }
        },
        decoration: InputDecoration(
            hintText: 'Enter city name . . .',
            filled: true,
            fillColor: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.white.withOpacity(0.3),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            suffixIcon: IconButton(
              onPressed: () {
                if (controller.text == '') return;
                final cityName = controller.text.trim();
                context
                    .read<WeatherCityBloc>()
                    .add(FetchWeatherByCity(cityName));
              },
              icon: const Icon(Icons.search),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isDark ? ConstColors.purple4 : ConstColors.purple1,
                  width: 0),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isDark ? ConstColors.purple4 : ConstColors.purple1,
                  width: 0),
              borderRadius: BorderRadius.circular(30),
            ),
            hintStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 15,
              fontWeight: FontWeight.w400,
            )),
      ),
    );
  }

  Widget cityInformation(bool isDark) {
    return Expanded(
      child: BlocBuilder<WeatherCityBloc, WeatherCityState>(
        builder: (context, state) {
          if (state is WeatherInitial) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_city_rounded, size: 80, color: Colors.grey),
                SizedBox(height: 15),
                Text(
                  "Search for any city",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            );
          } else if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CityNameWeatherLoaded) {
            return Center(
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withOpacity(0.8)
                      : Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? ConstColors.purple3 : ConstColors.purple1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      GlobalFunctions().getWeatherLottie(state.weather.icon),
                      height: 100,
                    ),
                    Text('${state.weather.temperature} °C',
                        style: const TextStyle(fontSize: 18)),
                    Text(state.weather.description,
                        style: const TextStyle(fontSize: 16)),
                    RichText(
                      text: TextSpan(
                        text: state.weather.cityName,
                        style: Theme.of(context).textTheme.titleLarge,
                        children: <TextSpan>[
                          TextSpan(
                            text: ' | ${state.weather.country}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(isDark
                              ? ConstColors.purple1
                              : ConstColors.purple4),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRouter.detail,
                              arguments: {
                                'weather': state.weather,
                              });
                        },
                        child: const Text('More Information'))
                  ],
                ),
              ),
            );
          } else if (state is WeatherError) {
            return Center(
              child: Text(state.message,
                  style: const TextStyle(color: Colors.red)),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
