import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internalinformationmanagement/screens/home_screen.dart';
import 'package:internalinformationmanagement/screens/login_screen.dart';
import 'package:internalinformationmanagement/service/auth_ad_service.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AuthService authService = AuthService(
      oAuth: AadOAuth(Config(
          clientId: '${dotenv.env['AAD_CLIENT_ID']}',
          tenant: '${dotenv.env['AAD_TENANT_ID']}',
          scope: 'user.read',
          redirectUri: '${dotenv.env['AAD_REDIRECT_URI']}',
          navigatorKey: GlobalKey<NavigatorState>())));

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: GlobalKey<NavigatorState>(),
      routes: {
        '/login': (context) => LoginScreen(
              authService: authService,
            ),
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
          fontFamily: 'Poppins'),
      darkTheme: ThemeData(),
    );
  }
}
