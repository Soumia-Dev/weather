part of 'weather_city_bloc.dart';

@immutable
sealed class WeatherCityEvent {}

class ResetWeather extends WeatherCityEvent {}

class FetchWeatherByCity extends WeatherCityEvent {
  final String cityName;
  FetchWeatherByCity(this.cityName);
}
