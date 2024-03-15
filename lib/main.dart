import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internalinformationmanagement/screens/home_screen.dart';
import 'package:internalinformationmanagement/screens/login_screen.dart';
import 'package:internalinformationmanagement/service/auth_ad_service.dart';

final _navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(
    navigatorKey: _navigatorKey,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        '/login': (context) => LoginScreen(navigatorKey: _navigatorKey),
        '/home': (context) => HomeScreen()
      },
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      title: 'Internal Information Managment',
      theme: ThemeData(
          primaryColor: Color(0xFF0C55F3),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFF5645E)),
          scaffoldBackgroundColor: Color(0xFFEFF4FF),
          useMaterial3: false,
          fontFamily: 'Inter'),
      darkTheme: ThemeData(),
    );
  }
}
