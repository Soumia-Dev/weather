import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/global_functions.dart';
import '../../model/weather.dart';

class WeatherApi {
  static const _apiKeyWeather = 'your API Key';
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/';

  Future<Weather> fetchWeatherByLocation({
    required double lat,
    required double lon,
  }) async {
    final url1 =
        '${_baseUrl}weather?lat=$lat&lon=$lon&appid=$_apiKeyWeather&units=metric';
    final url2 =
        '${_baseUrl}forecast?lat=$lat&lon=$lon&appid=$_apiKeyWeather&units=metric';

    return getWeatherInformation(url1, url2);
  }

  Future<Weather> fetchWeatherByCityName({required String cityName}) async {
    final url1 =
        '${_baseUrl}weather?q=$cityName&appid=$_apiKeyWeather&units=metric';
    final url2 =
        '${_baseUrl}forecast?q=$cityName&appid=$_apiKeyWeather&units=metric';

    return getWeatherInformation(url1, url2);
  }

  Future<Weather> getWeatherInformation(String url1, String url2) async {
    try {
      final currentWeatherResponse = await http.get(Uri.parse(url1));
      final forecastResponse = await http.get(Uri.parse(url2));

      if (currentWeatherResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        final currentWeatherJson = json.decode(currentWeatherResponse.body);
        final forecastJson = json.decode(forecastResponse.body)['list'];

        final sunrise = GlobalFunctions().toRealTime(
          date: currentWeatherJson['sys']['sunrise'],
          timeZone: currentWeatherJson['timezone'],
        );

        final sunset = GlobalFunctions().toRealTime(
          date: currentWeatherJson['sys']['sunset'],
          timeZone: currentWeatherJson['timezone'],
        );

        final date = GlobalFunctions().toRealTime(
          date: currentWeatherJson['dt'],
          timeZone: currentWeatherJson['timezone'],
        );

        return Weather.fromJson(
          currentJson: currentWeatherJson,
          forecastJson: forecastJson,
          sunrise: sunrise,
          sunset: sunset,
          date: date,
        );
      } else {
        throw ('Failed to load weather data');
      }
    } catch (e) {
      throw ('Failed to load weather data');
    }
  }
}
