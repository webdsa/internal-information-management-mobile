import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/screens/blog_screen.dart';
import 'package:internalinformationmanagement/screens/feed_screen.dart';
import 'package:internalinformationmanagement/screens/home_screen.dart';
import 'package:internalinformationmanagement/screens/login_screen.dart';
import 'package:internalinformationmanagement/screens/search_screen.dart';
import 'package:internalinformationmanagement/screens/sumary_screen.dart';
import 'package:internalinformationmanagement/theme/theme_provider.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'flavors.dart';

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final SharedPreferences prefs;
  const MyApp({Key? key, required this.navigatorKey, required this.prefs}) : super(key: key);

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
    final bool isAutoLogged = prefs.getBool("auto_login") ?? false;
    final int? lastLoginTime = prefs.getInt("last_login_time");

    if (!isAutoLogged || lastLoginTime == null) {
      return false;
    }

    final DateTime lastLoginDateTime = DateTime.fromMillisecondsSinceEpoch(lastLoginTime);
    final DateTime currentDateTime = DateTime.now();

    if (currentDateTime.difference(lastLoginDateTime).inHours >= 1) {
      prefs.setBool('is_logged_in', false);
      return false;
    }

    prefs.setBool('is_logged_in', true);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: F.title,
      navigatorKey: widget.navigatorKey,
      routes: {
        '/summary': (context) => SummaryScreen(),
        '/feed': (context) => FeedScreen(),
        '/login': (context) => LoginScreen(navigatorKey: widget.navigatorKey, prefs: widget.prefs,),
      },
      home: FutureBuilder<bool>(
        future: _isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data!) {
            return AppScreens();
          } else {
            return BlogScreen(prefs: widget.prefs);
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
  late List<IconData> _tabIcons;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(length: 2, initialIndex: _selectedIndex, vsync: this);

    _pages = [
      HomeScreen(),
      SearchScreen(
        wasPreviousScreenFeed: false,
      ),
    ];

    _tabIcons = [
      Icons.home, // Ícone para "Início"
      Icons.search, // Ícone para "Pesquisar"
    ];
  }

  void _updateValue(int newValue) {
    setState(() {
      _selectedIndex = newValue;
      _motionTabBarController?.animateTo(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: "Início",
        labels: ["Início", "Pesquisar"],
        icons: _tabIcons,
        controller: _motionTabBarController,
        tabIconColor: const Color.fromARGB(255, 31, 101, 148),
        tabBarColor: MainColors.primary02,
        tabIconSize: 28,
        onTabItemSelected: (index) {
          _updateValue(index);
        },
        tabSelectedColor: MainColors.primary01,
        tabIconSelectedSize: 30,
        textStyle: TextStyle(color: MainColors.primary01, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}
