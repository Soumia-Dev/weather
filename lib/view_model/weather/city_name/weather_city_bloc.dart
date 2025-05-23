import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/data/remote/weather_api.dart';
import '../../../domain/model/weather.dart';

part 'weather_city_event.dart';
part 'weather_city_state.dart';

class WeatherCityBloc extends Bloc<WeatherCityEvent, WeatherCityState> {
  final WeatherApi weatherApi;

  WeatherCityBloc({required this.weatherApi}) : super(WeatherInitial()) {
    on<FetchWeatherByCity>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather =
            await weatherApi.fetchWeatherByCityName(cityName: event.cityName);
        emit(CityNameWeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    });
    on<ResetWeather>((event, emit) async {
      emit(WeatherInitial());
    });
  }
}
