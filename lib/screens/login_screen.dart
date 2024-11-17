// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/flavors.dart';
import 'package:internalinformationmanagement/widgets/Login/login_screen_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final SharedPreferences prefs;
  const LoginScreen({super.key, required this.navigatorKey, required this.prefs});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: LoginScreenWidget(preferences: widget.prefs,));
  }
}
