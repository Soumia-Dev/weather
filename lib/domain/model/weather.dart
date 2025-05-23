import 'package:hive/hive.dart';

import '../../core/global_functions.dart';
import 'forecast.dart';

part '../data/local/weather.g.dart';

@HiveType(typeId: 0)
class Weather extends HiveObject {
  @HiveField(0)
  final int cityId;

  @HiveField(1)
  final String cityName;

  @HiveField(2)
  final String country;

  @HiveField(3)
  final int temperature;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final String sunrise;

  @HiveField(6)
  final String sunset;

  @HiveField(7)
  final List<Forecast> forecast;

  @HiveField(8)
  final DateTime date;

  @HiveField(9)
  final String icon;

  @HiveField(10)
  final dynamic humidity;

  @HiveField(11)
  final dynamic wind;
  @HiveField(12)
  final int pressure;
  @HiveField(13)
  final int timeZone;

  Weather({
    required this.cityId,
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.description,
    required this.sunrise,
    required this.sunset,
    required this.forecast,
    required this.date,
    required this.icon,
    required this.humidity,
    required this.wind,
    required this.pressure,
    required this.timeZone,
  });

  factory Weather.fromJson({
    required Map<String, dynamic> currentJson,
    required List<dynamic> forecastJson,
    required sunrise,
    required sunset,
    required date,
  }) {
    return Weather(
      cityId: currentJson['id'],
      cityName: currentJson['name'],
      country: currentJson['sys']['country'],
      temperature: (currentJson['main']['temp']).toInt(),
      description: currentJson['weather'][0]['description'],
      sunrise: GlobalFunctions().hourFormat(time: sunrise),
      sunset: GlobalFunctions().hourFormat(time: sunset),
      forecast: forecastJson.map((item) => Forecast.fromJson(item)).toList(),
      date: date,
      icon: currentJson['weather'][0]['icon'],
      humidity: currentJson['main']['humidity'],
      wind: (currentJson['wind']['speed'] * 3.6).toInt(),
      pressure: (currentJson['main']['pressure']).toInt(),
      timeZone: currentJson['timezone'],
    );
  }
}
