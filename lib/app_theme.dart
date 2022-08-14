
import 'package:flutter/material.dart';

abstract class IThemeFactory {
  ThemeData getTheme({required BuildContext context, String themeName});
}

class ThemeFactory implements IThemeFactory {

  static ThemeFactory? _instance;

  ThemeFactory._();

  static ThemeFactory getInstance() {
    return _instance ??= ThemeFactory._();
  }

  final Map<String, ThemeData> _supportedThemes = {
    "Base": ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: purpleProp),
      //scaffoldBackgroundColor: purpleProp.shade50
    )
  };

  @override
  ThemeData getTheme({required BuildContext context, String themeName = "Base"}) {
    ThemeData? theme = _supportedThemes[themeName];
    return theme ?? Theme.of(context);
  }

  static const MaterialColor purpleProp = MaterialColor(
    _purplePropPrimaryValue,
    <int, Color>{
      50: Color(0xFFF3E5F5),
      100: Color(0xFFE1BEE7),
      200: Color(0xFFCE93D8),
      300: Color(0xFFBA68C8),
      400: Color(0xFFAB47BC),
      500: Color(_purplePropPrimaryValue),
      600: Color(0xFF8E24AA),
      700: Color(0xFF7B1FA2),
      800: Color(0xFF6A1B9A),
      900: Color(0xFF4A148C),
    },
  );
  static const int _purplePropPrimaryValue = 0xFF5335c3;


}