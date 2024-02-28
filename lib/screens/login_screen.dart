import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import '../util/Palette.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Evita que a tela seja redimensionada quando o teclado é exibido
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Image.asset(
                  'assets/imgs/logoLogin.png',
                  fit: BoxFit.contain,
                  width: 70,
                  height: 70,
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: [
                          Text(
                            "Entrar",
                            style: Styles.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "E-mail",
                                    style: Styles.bodyText.merge(
                                        TextStyle(color: TextColors.text4)),
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      constraints:
                                          BoxConstraints(maxHeight: 42),
                                      fillColor: Color(0xFFEAE9F0),
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Senha",
                                    style: Styles.bodyText.merge(
                                        TextStyle(color: TextColors.text4)),
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                        constraints:
                                            BoxConstraints(maxHeight: 42),
                                        filled: true,
                                        fillColor: Color(
                                          0xFFEAE9F0,
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none)),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: "Esqueceu a senha? ",
                                style: Styles.bodyText),
                            TextSpan(
                                text: "Redefinir senha.",
                                style: Styles.bodyText.merge(TextStyle(
                                    color: Theme.of(context).primaryColor))),
                          ])),
                        ],
                      ),
                      Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Entrar'.toUpperCase()),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    textStyle: Styles.headline4,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: "Não tem conta? ",
                                      style: Styles.bodyText),
                                  TextSpan(
                                    text: "Registre-se",
                                    style: Styles.bodyText.merge(TextStyle(
                                        color: Theme.of(context).primaryColor)),
                                  )
                                ])),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
