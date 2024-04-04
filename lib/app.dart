import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/screens/home_screen.dart';
import 'package:internalinformationmanagement/screens/login_screen.dart';
import 'flavors.dart';

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({Key? key, required this.navigatorKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: F.title,
      navigatorKey: navigatorKey,
      routes: {
        '/login': (context) => LoginScreen(navigatorKey: navigatorKey),
        '/home': (context) => HomeScreen()
      },
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xFF0C55F3),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFF5645E)),
          scaffoldBackgroundColor: Color(0xFFEFF4FF),
          useMaterial3: false,
          fontFamily: 'Inter'),
    );
  }
}