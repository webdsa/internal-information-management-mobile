import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/screens/home_screen.dart';
import 'package:internalinformationmanagement/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Internal Information Managment',
      theme: ThemeData(
          primaryColor: Color(0xFF0C55F3),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFF5645E)),
          scaffoldBackgroundColor: Color(0xFFEFF4FF),
          useMaterial3: false,
          fontFamily: 'Poppins'),
      darkTheme: ThemeData(),
      home: HomeScreen(),
    );
  }
}
