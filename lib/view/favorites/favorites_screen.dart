import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/core/colors.dart';
import 'package:weather/view/favorites/favorites_widgets.dart';

import '../../view_model/favorites/favorites_bloc.dart';
import '../../view_model/favorites/favorites_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : ConstColors.purple4,
      appBar: FavoritesWidgets().appBar(),
      body: RefreshIndicator(
        onRefresh: () => FavoritesWidgets().loadWeatherDetails(context),
        child: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            final List listWeather = state.favorites;
            if (listWeather.isEmpty) {
              return ListView(children: [
                Container(
                    height: MediaQuery.of(context).size.height - kToolbarHeight,
                    alignment: Alignment.center,
                    child: const Text('No favorites yet')),
              ]);
            }

            return FavoritesWidgets().weatherList(listWeather, isDark);
          },
        ),
      ),
    );
  }
}
