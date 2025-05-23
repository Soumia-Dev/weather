part of 'weather_location_bloc.dart';

@immutable
sealed class WeatherLocationEvent {}

class FetchWeatherByLocation extends WeatherLocationEvent {
  FetchWeatherByLocation();
}

class RefreshWeatherByLocation extends WeatherLocationEvent {
  RefreshWeatherByLocation();
}
