import 'package:hive/hive.dart';

part '../data/local/forecast.g.dart';

@HiveType(typeId: 1)
class Forecast {
  @HiveField(0)
  final String date;
  @HiveField(1)
  final int temperature;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String icon;

  Forecast({
    required this.date,
    required this.temperature,
    required this.description,
    required this.icon,
  });
  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: json['dt_txt'],
      temperature: json['main']['temp'].toInt(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}
