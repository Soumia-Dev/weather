import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../domain/model/weather.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final Box<Weather> _favoritesBox = Hive.box<Weather>('favorites');

  FavoritesBloc()
      : super(FavoritesState(Hive.box<Weather>('favorites').values.toList())) {
    on<LoadFavorites>((event, emit) {
      final List<Weather> all = _favoritesBox.values.toList();
      emit(FavoritesState(all));
    });

    on<AddFavorite>((event, emit) {
      try {
        _favoritesBox.put(event.weather.cityId, event.weather);
        add(LoadFavorites());
      } catch (e) {
        throw ('error');
      }
    });

    on<RemoveFavorite>((event, emit) async {
      try {
        _favoritesBox.delete(event.weather.cityId);
        add(LoadFavorites());
      } catch (e) {
        throw ('error');
      }
    });
  }
}
