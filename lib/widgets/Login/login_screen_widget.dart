import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internalinformationmanagement/app.dart';
import 'package:internalinformationmanagement/service/login_service.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:internalinformationmanagement/util/Styles.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({super.key});

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget>
    with SingleTickerProviderStateMixin {
  final LoginService _loginService = LoginService();

  bool _isLoading = false;

  Future<void> _setJwt(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    final int currentTime = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt('last_login_time', currentTime);
    await prefs.setBool("auto_login", true);
  }

  void _loginAd() async {
    try {
      final microsoftProvider = OAuthProvider('microsoft.com');

      final credential =
          await FirebaseAuth.instance.signInWithProvider(microsoftProvider);

      var token = await credential.user?.getIdToken(true);

      await _setJwt(token!);

      setState(() {
        _isLoading = true; // Ativa a animação
      });

      // Simula um tempo de espera antes de navegar para a próxima tela
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AppScreens()),
        ).then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 26),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            MainColors.primary03,
            FoundationColors.foundationSecondaryDarkest
          ])),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Visibility(
              visible: !_isLoading,
              child: Expanded(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'assets/imgs/Mobile login-rafiki (2) 1.png',
                          height: 256,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          'Bem-vindo ao',
                          style: Styles.h6.merge(TextStyle(color: Colors.white)),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'DSA - Informações',
                          style: Styles.h4.merge(TextStyle(color: Colors.white)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const Spacer(),
                    formButtonsWidget()
                  ],
                ),
              ),
            ),

            /*
              SCREEN - LOADING SCREEN
              */
            Visibility(
              visible: _isLoading,
              child: Expanded(
                flex: 7,
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                          height: 200,
                          width: 200,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          )),
                      Positioned(
                        top: 40,
                        right: 0,
                        left: 0,
                        bottom: 40,
                        child: Image.asset(
                          'assets/imgs/logoLogin.png',
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget formButtonsWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                _loginAd();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: TextColors.text5),
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.white,
                textStyle: Styles.headline4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Entrar com Microsoft',
                    style: Styles.buttonSmall
                        .merge(TextStyle(color: TextColors.text1)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SvgPicture.asset('assets/svgs/key.svg'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
