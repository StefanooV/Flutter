import 'package:flutter/material.dart';

class AppTheme {
  static const Color weveSkyBlue = Color.fromARGB(255, 61, 189, 255);
  static const Color wevePrimaryBlue = Color.fromARGB(255, 0, 124, 244);
  static const Color availableGreen = Color.fromARGB(255, 10, 207, 131);
  static const List<Color> colorsCollection = [
    Color.fromARGB(255, 13, 77, 172),
    weveSkyBlue,
    wevePrimaryBlue,
  ];

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      color: wevePrimaryBlue,
      elevation: 0,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: weveSkyBlue),
    ),
    scrollbarTheme: ScrollbarThemeData(
      minThumbLength: 2,
      thumbVisibility: MaterialStateProperty.all(true),
      trackVisibility: MaterialStateProperty.all(false),
      thickness: MaterialStateProperty.all(1),
      thumbColor: MaterialStateProperty.all(wevePrimaryBlue),
      radius: const Radius.circular(10),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: weveSkyBlue, elevation: 5),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        backgroundColor: weveSkyBlue,
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: const TextStyle(color: weveSkyBlue),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 236, 236, 236),
          width: 0,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppTheme.weveSkyBlue,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 255, 0, 0),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      // hintStyle: const TextStyle(
      //   fontFamily: "Montserrat",
      //   fontWeight: FontWeight.w200,
      // ),
      filled: true,
      fillColor: const Color.fromARGB(255, 240, 240, 240),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      labelStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 16,
      ),
    ),
  );
}
