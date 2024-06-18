import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:internalinformationmanagement/screens/search_screen.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/screens/feed_screen.dart';
import 'package:internalinformationmanagement/screens/sumary_screen.dart';
import 'package:internalinformationmanagement/theme/theme.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internalinformationmanagement/screens/home_screen.dart';
import 'package:internalinformationmanagement/screens/login_screen.dart';
import 'package:internalinformationmanagement/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'flavors.dart';

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({Key? key, required this.navigatorKey}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _isAutoLogged;

  @override
  void initState() {
    super.initState();
    _checkJWT();
  }

  Future<void> _checkJWT() async {
    final prefs = await SharedPreferences.getInstance();
    _isAutoLogged = prefs.getBool('auto_login');
  }

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("auto_login") &&
        prefs.getBool("auto_login") == true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: F.title,
      navigatorKey: widget.navigatorKey,
      routes: {
        '/summary': (context) => SummaryScreen(),
        '/feed': (context) => FeedScreen(),
        '/login': (context) => LoginScreen(navigatorKey: widget.navigatorKey),
        '/home': (context) => HomeScreen()
      },
      home: FutureBuilder<bool>(
        future: _isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data!) {
            return AppScreens();
          } else {
            return LoginScreen(navigatorKey: widget.navigatorKey);
          }
        },
      ),
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

class AppScreens extends StatefulWidget {
  const AppScreens({super.key});

  @override
  State<AppScreens> createState() => _AppScreensState();
}

class _AppScreensState extends State<AppScreens> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
        length: 3, initialIndex: _selectedIndex, vsync: this);
  }

  final List<Widget> _pages = [
    HomeScreen(),
    SearchScreen(),
    Center(
      child: Text("Profile"),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: "Início",
        labels: ["Início", "Pesquisar", "Perfil"],
        icons: [Icons.home, Icons.search, Icons.person],
        controller: _motionTabBarController,
        tabIconColor: MainColors.primary04,
        tabBarColor: MainColors.primary02,
        tabIconSize: 28,
        onTabItemSelected: (index) => setState(() => _selectedIndex = index),
        tabSelectedColor: MainColors.primary01,
        tabIconSelectedSize: 30,
        textStyle: TextStyle(
            color: MainColors.primary01,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
