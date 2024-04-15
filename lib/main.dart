import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/firebase_options.dart';
import 'package:internalinformationmanagement/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'app.dart';

final _navigatorKey = GlobalKey<NavigatorState>();
FutureOr<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( ChangeNotifierProvider(create: (context) => ThemeProvider(),
  child: MyApp(
    navigatorKey: _navigatorKey,
  )));
}