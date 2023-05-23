import 'package:flutter/material.dart';

ThemeData themeData() {
  return ThemeData(
      dropdownMenuTheme: const DropdownMenuThemeData(menuStyle: MenuStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffced6e0)))),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xff2f3542),
      ),
      primaryColor: const Color(0xffffa502),
      scaffoldBackgroundColor: const Color(0xff2f3542),
      appBarTheme: const AppBarTheme(color: Color(0xffffa502)),
      primaryColorDark: const Color(0xff2f3542),
      cardColor: const Color(0xff2f3542),
      canvasColor: const Color(0xffced6e0),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: Colors.white,
        focusColor: Color(0xffced6e0),
        labelStyle: TextStyle(color: Color(0xff2f3542)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffced6e0)), borderRadius: BorderRadius.all(Radius.circular(20))),
        filled: true,
        contentPadding: EdgeInsets.all(10),
      ),
      segmentedButtonTheme: const SegmentedButtonThemeData(
          style: ButtonStyle(
        iconSize: MaterialStatePropertyAll(10),
        iconColor: MaterialStatePropertyAll(Color(0xffffa502)),
        padding: MaterialStatePropertyAll(EdgeInsets.zero),
        elevation: MaterialStatePropertyAll(40),
        foregroundColor: MaterialStatePropertyAll(Color(0xffffa502)),
        overlayColor: MaterialStatePropertyAll(Color(0xffffa502)),
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(Color(0xffffa502)),
          textStyle: const MaterialStatePropertyAll(TextStyle(color: Color(0xffced6e0), fontSize: 20)),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          alignment: Alignment.center,
          elevation: const MaterialStatePropertyAll(40),
        ),
      ),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStatePropertyAll(TextStyle(color: Color.fromARGB(255, 2, 103, 255), fontSize: 15, decoration: TextDecoration.underline)),
        ),
      ),
      textTheme: const TextTheme(
        labelLarge: TextStyle(color: Color(0xffced6e0), fontSize: 50),
        titleLarge: TextStyle(color: Color(0xffffa502), fontSize: 42),
        bodyLarge: TextStyle(color: Color(0xffced6e0), fontSize: 30, fontWeight: FontWeight.bold, shadows: [
          Shadow(
              blurRadius: 15.0, // shadow blur
              color: Color(0xff2f3542), // shadow color
              offset: Offset(4.0, 4.0) // how much shadow will be shown
              )
        ]),
        displayMedium: TextStyle(color: Color(0xffced6e0), fontSize: 15),
        labelMedium: TextStyle(
          color: Color(0xffffa502),
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(color: Color(0xffced6e0), fontSize: 20, fontWeight: FontWeight.bold),
        bodySmall: TextStyle(color: Color(0xffced6e0), fontSize: 15),
      ));
}
