// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/flavors.dart';
import 'package:internalinformationmanagement/widgets/LoginScreenWidgets/login_screen_widget.dart';

class LoginScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const LoginScreen({super.key, required this.navigatorKey});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Banner(
            message: F.env,
            location: BannerLocation.bottomEnd,
            child: LoginScreenWidget()));
  }
}
