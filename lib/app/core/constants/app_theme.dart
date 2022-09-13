import 'package:com_joaojsrbr_reader/app/generated/color_schemes.g.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  static ColorScheme darkcolorScheme = darkColorScheme;
  static const MaterialColor primary = Colors.indigo;
  static const Color accent = Color.fromRGBO(68, 157, 171, 1);

  static const Color option = Color.fromRGBO(59, 62, 82, 1);
  static const Color greyDark = Color.fromRGBO(58, 61, 65, 1);
  static const Color blueDark = Color.fromRGBO(42, 43, 58, 1);

  static ColorScheme color(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  static const Color surface = Color.fromRGBO(22, 22, 30, 1);
  static const Color surfaceTwo = Color.fromRGBO(26, 27, 38, 1);
  static const Color background = Color.fromRGBO(16, 16, 20, 1);
}
