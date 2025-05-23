import 'package:intl/intl.dart';

import '../domain/model/forecast.dart';

class GlobalFunctions {
  DateTime toRealTime({required int date, required int timeZone}) {
    DateTime utcTime =
        DateTime.fromMillisecondsSinceEpoch(date * 1000, isUtc: true);
    DateTime localTime = utcTime.add(Duration(seconds: timeZone));

    return localTime;
  }

  String hourFormat({required DateTime time}) {
    return DateFormat('hh:mm a').format(time);
  }

  String dayFormat({required DateTime time}) {
    return DateFormat.yMMMMd().format(time);
  }

  String timeZoneFormat(int timezoneInSeconds) {
    int hours = timezoneInSeconds ~/ 3600;
    String sign = hours >= 0 ? '+' : '-';
    return 'GMT$sign${hours.abs()}';
  }

  String getWeatherLottie(String icon) {
    switch (icon) {
      case '01d':
        return 'assets/LottieDescription/clear_sky_day.json';
      case '01n':
        return 'assets/LottieDescription/clear_sky_night.json';
      case '02d':
        return 'assets/LottieDescription/few_clouds_day.json';
      case '02n':
        return 'assets/LottieDescription/few_clouds_night.json';

      case '03d' || '03n' || '04d ' || '04n':
        return 'assets/LottieDescription/scattered_clouds.json';

      case '09d ' || '09n':
        return 'assets/LottieDescription/shower_rain.json';

      case '10d':
        return 'assets/LottieDescription/rain_day.json';
      case '10n':
        return 'assets/LottieDescription/rain_night.json';
      case '11d' || '11n':
        return 'assets/LottieDescription/thunderstorm.json';

      case '13d' || '13n':
        return 'assets/LottieDescription/snow.json';

      case '50d' || '50n':
        return 'assets/LottieDescription/mist.json';

      default:
        return 'assets/LottieDescription/scattered_clouds.json';
    }
  }

  Map forecastByDay(List<Forecast> forecast) {
    Map day = {};
    for (Forecast item in forecast) {
      final date = item.date.split(' ')[0];
      day.putIfAbsent(date, () => []).add(item);
    }
    return day;
  }
}
