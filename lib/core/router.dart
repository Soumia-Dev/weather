import 'package:flutter/material.dart';

import '../domain/model/weather.dart';
import '../view/favorites/favorites_screen.dart';
import '../view/home&detail/detail_screen.dart';
import '../view/home&detail/home_screen.dart';
import '../view/search/search_screen.dart';

class AppRouter {
  static const home = '/';
  static const search = '/search';
  static const detail = '/detail';
  static const favorites = '/favorites';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case search:
        return MaterialPageRoute(builder: (_) => SearchScreen());
      case detail:
        final args = settings.arguments as Map<String, dynamic>;
        final weather = args['weather'] as Weather;
        return MaterialPageRoute(
            builder: (_) => DetailScreen(weather: weather));
      case favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
