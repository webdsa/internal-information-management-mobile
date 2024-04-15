import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/theme/theme.dart';
import 'package:internalinformationmanagement/screens/home_screen.dart';
import 'package:internalinformationmanagement/screens/login_screen.dart';
import 'package:internalinformationmanagement/theme/theme_provider.dart';
import 'package:provider/provider.dart';
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
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}