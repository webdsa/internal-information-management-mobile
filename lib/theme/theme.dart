import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  useMaterial3: false,
  primaryColor: Color(0xFF0C55F3),
  fontFamily: 'Inter',
  colorScheme: ColorScheme.light(
    background: Color(0xFFE8EDF1),
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: false,
  primaryColor: Color(0xFF0C55F3),
  fontFamily: 'Inter',
  colorScheme: ColorScheme.dark(
    background: Color(0xFF081B28),
  )
);
