import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/firebase_options.dart';
import 'app.dart';

final _navigatorKey = GlobalKey<NavigatorState>();
FutureOr<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(
    navigatorKey: _navigatorKey,
  ));
}