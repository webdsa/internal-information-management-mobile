import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:internalinformationmanagement/theme/theme_provider.dart';
import 'package:internalinformationmanagement/firebase_options.dart';

final _navigatorKey = GlobalKey<NavigatorState>();
FutureOr<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('is_logged_in', false);
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(
        navigatorKey: _navigatorKey,
        prefs: prefs
      )));
}