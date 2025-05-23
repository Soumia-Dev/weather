import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather/view_model/theme/theme_state.dart';
import 'package:weather/view_model/weather/location/weather_location_bloc.dart';


import 'core/router.dart';
import 'domain/data/remote/weather_api.dart';
import 'domain/model/forecast.dart';
import 'domain/model/weather.dart';
import 'view_model/favorites/favorites_bloc.dart';
import 'view_model/theme/theme_bloc.dart';
import 'view_model/weather/city_name/weather_city_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDirection = await getApplicationDocumentsDirectory();
  Hive.init(appDirection.path);
  Hive.registerAdapter(ForecastAdapter());
  Hive.registerAdapter(WeatherAdapter());
  await Hive.openBox<Weather>('favorites');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WeatherCityBloc(weatherApi: WeatherApi())),
        BlocProvider(
            create: (_) => WeatherLocationBloc(weatherApi: WeatherApi())
              ..add(FetchWeatherByLocation())),
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => FavoritesBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Weather Multi-BLoC App',
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData.dark(),
            themeMode: state.themeMode,
            initialRoute: AppRouter.home,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
