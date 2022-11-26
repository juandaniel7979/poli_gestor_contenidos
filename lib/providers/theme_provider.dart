import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;
    static const Color primary = Color.fromRGBO(25,104,68, 1);
  static const Color secondary = Color.fromRGBO(254,165,0, 1);


  ThemeProvider({
    required bool isDarkMode
  }): currentTheme = isDarkMode ? ThemeData.dark() : ThemeData.light();


  setLightMode() {
    currentTheme = ThemeData.light().copyWith(
      backgroundColor: Colors.white,
      primaryColor: Colors.white,
      inputDecorationTheme: const InputDecorationTheme(
        floatingLabelStyle: TextStyle( color: primary),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide( color: primary),
          borderRadius: BorderRadius.only( bottomLeft: Radius.circular(10), topRight: Radius.circular(10)
        ),
      ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide( color: primary),
          borderRadius: BorderRadius.only( bottomLeft: Radius.circular(10), topRight: Radius.circular(10)
        )
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.only( bottomLeft: Radius.circular(10), topRight: Radius.circular(10)
        )
        ),
      ),
      
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