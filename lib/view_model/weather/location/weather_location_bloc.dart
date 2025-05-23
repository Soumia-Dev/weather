import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/location_service.dart';
import '../../../domain/data/remote/weather_api.dart';
import '../../../domain/model/weather.dart';

part 'weather_location_event.dart';
part 'weather_location_state.dart';

class WeatherLocationBloc
    extends Bloc<WeatherLocationEvent, WeatherLocationState> {
  final WeatherApi weatherApi;

  WeatherLocationBloc({required this.weatherApi})
      : super(WeatherLocationInitial()) {
    on<FetchWeatherByLocation>(_loadWeather);
    on<RefreshWeatherByLocation>(_loadWeather);
  }

  Future<void> _loadWeather(
      WeatherLocationEvent event, Emitter<WeatherLocationState> emit) async {
    if (event is FetchWeatherByLocation) {
      emit(WeatherLoading());
    }

    try {
      final position = await locationService();
      final weather = await weatherApi.fetchWeatherByLocation(
        lat: position.latitude,
        lon: position.longitude,
      );
      emit(LocationWeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}
