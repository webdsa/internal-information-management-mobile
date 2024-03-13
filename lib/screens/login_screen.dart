import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:internalinformationmanagement/screens/home_screen.dart';
import 'package:internalinformationmanagement/service/auth_ad_service.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import '../util/Palette.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;
  const LoginScreen({super.key, required this.authService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  void _login() {
    setState(() {
      _isLoading = true; // Ativa a animação
    });

    // Simula um tempo de espera antes de navegar para a próxima tela
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      ).then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

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
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeInCirc,
                height:
                    _isLoading ? 0 : MediaQuery.of(context).size.height * 0.5,
                child: Visibility(
                  visible: !_isLoading,
                  child: Center(
                    child: Image.asset(
                      'assets/imgs/Computer login-amico 1.png',
                      fit: BoxFit.contain,
                      width: 240,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !_isLoading,
                child: Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "E-mail",
                                      style: Styles.bodyText.merge(
                                          TextStyle(color: TextColors.text4)),
                                    ),
                                    TextFormField(
                                      controller: _emailController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Por favor, insira um e-mail";
                                        }
                                        if (!EmailValidator.validate(value)) {
                                          return 'Email inválido';
                                        }
                                        return null;
                                      },
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
                                ),
                              ),
                            ),
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
                                    controller: _passwordController,
                                    obscureText: true,
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
                              ),
                            ),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    height: 44,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _login();
                                      },
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
                                            color: Theme.of(context)
                                                .primaryColor)),
                                      )
                                    ])),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _isLoading,
                child: Expanded(
                  flex: 5,
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                            height: 200,
                            width: 200,
                            child: CircularProgressIndicator()),
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
      ),
    );
  }
}
