part of 'weather_city_bloc.dart';

@immutable
sealed class WeatherCityState {}

class WeatherInitial extends WeatherCityState {}

class WeatherLoading extends WeatherCityState {}

class CityNameWeatherLoaded extends WeatherCityState {
  final Weather weather;
  CityNameWeatherLoaded(this.weather);
}

class WeatherError extends WeatherCityState {
  final String message;
  WeatherError(this.message);
}
