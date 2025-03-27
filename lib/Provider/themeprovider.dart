import 'package:flutter/material.dart';
import 'package:notes_app/Theme/theme.dart';
import 'package:notes_app/utils.dart';

class ThemeProvider extends ChangeNotifier{
  List themes=[lightModeSimple,darkModeSimple,lightModePink,darkModePink,lightModeYellow,darkModeYellow,lightModeGreen,darkModeGreen,darkMode];
  void addTheme(int index) {
    sharedPrefs.pref.setInt("theme", index);
    notifyListeners();
  }
  ThemeData getTheme() {
    return themes[sharedPrefs.pref.getInt('theme')??0];
  }
}