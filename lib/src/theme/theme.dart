import 'package:flutter/material.dart';

import 'available_themes/dark_theme.dart';

enum AllThemes { light, dark }

class AppTheme {
  static ThemeData getTheme({AllThemes theme = AllThemes.dark}) {
    switch (theme) {
      case AllThemes.dark:
        return DarkTheme().theme;
      default:
        return DarkTheme().theme;
    }
  }
}
