import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;

  ThemeProvider({
    required bool isDarkMode
  }): currentTheme = isDarkMode ? ThemeData.dark() : ThemeData.light();


  setLightMode() {
    currentTheme = ThemeData.light().copyWith(
      backgroundColor: Colors.white,
      primaryColor: Colors.white
    );
    notifyListeners();
  }
  
  setDarkMode() {

    currentTheme = ThemeData.dark().copyWith(
      backgroundColor: Colors.white,
      primaryColor: Colors.black45,
      primaryColorDark: Colors.black45,

    );
    notifyListeners();
  }
}