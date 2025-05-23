import 'dart:ui';

abstract class ThemeEvent {}

class ToggleTheme extends ThemeEvent {
  final Brightness brightness;
  ToggleTheme(this.brightness);
}
