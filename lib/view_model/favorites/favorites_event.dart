import '../../domain/model/weather.dart';

abstract class FavoritesEvent {}

class LoadFavorites extends FavoritesEvent {}

class AddFavorite extends FavoritesEvent {
  final Weather weather;
  AddFavorite(this.weather);
}

class RemoveFavorite extends FavoritesEvent {
  final Weather weather;
  RemoveFavorite(this.weather);
}
