part of 'weather_location_bloc.dart';

@immutable
sealed class WeatherLocationState {}

final class WeatherLocationInitial extends WeatherLocationState {}

class WeatherLoading extends WeatherLocationState {}

class LocationWeatherLoaded extends WeatherLocationState {
  final Weather weather;
  LocationWeatherLoaded(this.weather);
}

class WeatherError extends WeatherLocationState {
  final String message;
  WeatherError(this.message);
}
