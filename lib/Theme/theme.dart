import 'package:flutter/material.dart';

ThemeData lightModeSimple=ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.white,
    secondary: Colors.black,
    tertiary: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    color: Color(0xFFC7C3E2)
  ),
);

ThemeData darkModeSimple=ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.black,
    secondary: Colors.white,
    tertiary: Colors.white,
  ),
  appBarTheme: AppBarTheme(
      color: Color(0xFF3B5998)
  ),
);

ThemeData lightModePink=ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.white,
    secondary: Colors.pinkAccent,
    tertiary: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    color: Color(0xFFF7D6DA)
  )
);

ThemeData darkModePink=ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Colors.black,
      secondary: Colors.pinkAccent,
      tertiary: Colors.white,
    ),
    appBarTheme: AppBarTheme(
        color: Color(0xFFFA94AF)
    )
);

ThemeData lightModeYellow=ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Colors.white,
      secondary: Colors.yellowAccent,
      tertiary: Colors.black,
    ),
    appBarTheme: AppBarTheme(
        color: Color(0xFFffe599)
    )
);

ThemeData darkModeYellow=ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Colors.black,
      secondary: Colors.yellowAccent,
      tertiary: Colors.white,
    ),
    appBarTheme: AppBarTheme(
        color: Color(0xFFbf9000)
    )
);

ThemeData lightModeGreen=ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Colors.white,
      secondary: Colors.green,
      tertiary: Colors.black,
    ),
    appBarTheme: AppBarTheme(
        color: Color(0xFF5EA758)
    )
);

ThemeData darkModeGreen=ThemeData(
    brightness: Brightness.dark,
    primaryColorDark: Colors.black54,
    colorScheme: ColorScheme.dark(
      primary: Colors.black,
      secondary: Colors.green,
      tertiary: Colors.white,
    ),
    appBarTheme: AppBarTheme(
        color: Color(0xFF47894B),
    )
);

ThemeData darkMode=ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.black54,
    secondary: Colors.white24,
    tertiary: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    color: Color(0xFF444444)
  )
);
