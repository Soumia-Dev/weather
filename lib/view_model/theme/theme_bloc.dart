import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeMode: ThemeMode.system)) {
    on<ToggleTheme>((event, emit) {
      if (event.brightness == Brightness.light) {
        emit(ThemeState(themeMode: ThemeMode.dark));
      } else {
        emit(ThemeState(themeMode: ThemeMode.light));
      }
    });
  }
}
