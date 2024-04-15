import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:internalinformationmanagement/screens/home_screen.dart';
import 'package:internalinformationmanagement/service/login_service.dart';
import 'package:internalinformationmanagement/theme/theme.dart';
import 'package:internalinformationmanagement/theme/theme_provider.dart';
import 'package:internalinformationmanagement/widgets/gradient_text.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import 'package:provider/provider.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({super.key});

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget>
    with SingleTickerProviderStateMixin {
  final LoginService _loginService = LoginService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isHidingPassword = true;

/*
  void _login() async {
    try {
      final token = await _loginService.login(
          context, _emailController.text, _passwordController.text);

      if (token != "") {
        setState(() {
          _isLoading = true; // Ativa a animação
        });

        // Simula um tempo de espera antes de navegar para a próxima tela
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          ).then((value) {
            setState(() {
              _isLoading = false;
            });
          });
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _loginAd() async {
    try {
      final microsoftProvider = OAuthProvider('microsoft.com');
      final credential =
          await FirebaseAuth.instance.signInWithProvider(microsoftProvider);

      var token = await credential.user?.getIdToken(true);

      if (token != null) {
        setState(() {
          _isLoading = true; // Ativa a animação
        });

        // Simula um tempo de espera antes de navegar para a próxima tela
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          ).then((value) {
            setState(() {
              _isLoading = false;
            });
          });
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: loginAndRegister(context),
          ),
        ),
      );
  }

  /*
  SCREEN - LOGIN AND REGISTER
  */
  Widget loginAndRegister(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text("Acesse sua conta",
              style: Styles.h6
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 32),
              child: formTextFields(context)),
        ],
      ),
    );
  }

  /*
  SECTION - FORM TEXT FIELDS
  */
  Widget formTextFields(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("E-mail", 
            style: Provider.of<ThemeProvider>(context).themeData == darkMode ? Styles.body.merge(TextStyle(color: Colors.white)) : Styles.body.merge(TextStyle(color: Colors.black)),),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: Provider.of<ThemeProvider>(context).themeData == darkMode ?
                  LinearGradient(
                    colors: [
                      Color.fromRGBO(91, 252, 252, 0.2),
                      Color.fromRGBO(50, 143, 251, 0.04),
                    ]
                  ) :
                  LinearGradient(
                    colors: [
                      Color.fromRGBO(186, 199, 213, 1),
                      Color.fromRGBO(186, 199, 213, 1),
                    ]
                  ), 
              ),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
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
                  fillColor: Provider.of<ThemeProvider>(context).themeData == darkMode ?
                     Color(0xFF061620) :
                     Color(0xFFE8EDF1),
                  filled: true,
                  constraints: const BoxConstraints(maxHeight: 48),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Text("Senha",  
            style: Provider.of<ThemeProvider>(context).themeData == darkMode ? Styles.body.merge(TextStyle(color: Colors.white)) : Styles.body.merge(TextStyle(color: Colors.black)),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: Provider.of<ThemeProvider>(context).themeData == darkMode ?
                  LinearGradient(
                    colors: [
                      Color.fromRGBO(91, 252, 252, 0.2),
                      Color.fromRGBO(50, 143, 251, 0.04),
                    ]
                  ) :
                  LinearGradient(
                    colors: [
                      Color.fromRGBO(186, 199, 213, 1),
                      Color.fromRGBO(186, 199, 213, 1),
                    ]
                  ), 
              ),
              child: TextFormField(
                controller: _passwordController,
                obscureText: _isHidingPassword,
                decoration: InputDecoration(
                    fillColor: Provider.of<ThemeProvider>(context).themeData == darkMode ?
                     Color(0xFF061620) :
                     Color(0xFFE8EDF1), 
                    filled: true,
                    constraints: const BoxConstraints(maxHeight: 48),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(4),
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: GestureDetector(
              onTap: () {},
              child: Provider.of<ThemeProvider>(context).themeData == darkMode ?
                GradientText("Esqueceu a senha?", 
                style: Styles.body,
                gradient: LinearGradient(colors: [Color(0xFF5BFCFC),
                Color(0XFF328FFB),])) :
                Text("Esqueceu a senha?", style: Styles.body.merge(TextStyle(color: Color(0xff1E5799))),),
            ),
          ),
          formButtonsWidget(),
        ],
      ),
    );
  }

  /*
  SECTION - FORM BUTTONS WIDGET
  */
  Widget formButtonsWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: 
                Provider.of<ThemeProvider>(context).themeData == darkMode ? 
                  LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                    Color.fromRGBO(91, 252, 252, 0.2),
                    Color.fromRGBO(50, 143, 251, 0.04),
                    ],
              ) :
              LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                    Color.fromRGBO(30, 87, 153, 1),
                    Color.fromRGBO(30, 87, 153, 1),
                    ],
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                //_login();
              },
              style: ElevatedButton.styleFrom(// Define a cor do botão como transparente para mostrar o gradiente do Container
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.transparent,
                textStyle: Styles.headline4,
              ),
              child: Text(
                'Entrar',
                style: Provider.of<ThemeProvider>(context).themeData == darkMode ? Styles.button.merge(TextStyle(color: Colors.white)) : Styles.button,
              ),
            ),
          ),
          SizedBox(height: 32,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Ou se preferir", 
                style: Provider.of<ThemeProvider>(context).themeData == darkMode ? Styles.body.merge(TextStyle(color: Colors.white)) : Styles.body,),
              Container(
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    //_loginAd();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Provider.of<ThemeProvider>(context).themeData == darkMode ? Colors.black : Color(0xFFC5D6E8),
                    textStyle: Styles.headline4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Provider.of<ThemeProvider>(context).themeData == darkMode ? SvgPicture.asset('assets/svgs/key-dark.svg') : SvgPicture.asset('assets/svgs/key-light.svg'),
                      ),
                      Text(
                        'Conecte-se com SSO',
                        style: Provider.of<ThemeProvider>(context).themeData == darkMode ? Styles.buttonSmall.merge(TextStyle(color: Colors.white)) : Styles.buttonSmall.merge(TextStyle(color: Colors.black)),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Divider(thickness: 1, color: Color(0xFF1E5799),)
          ),
          Padding(
            padding: const EdgeInsets.only(top:32), 
            child: GestureDetector(
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false).toggleThemeData();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if(Provider.of<ThemeProvider>(context).themeData == darkMode)
                          SvgPicture.asset("assets/svgs/user-round-plus-dark.svg")
                        else
                          SvgPicture.asset("assets/svgs/user-round-plus-light.svg"),

                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Não tem um conta?", 
                                style: Provider.of<ThemeProvider>(context).themeData == darkMode ? Styles.bodySmall.merge(TextStyle(color: Colors.white)) : Styles.bodySmall,),
                              
                              if (Provider.of<ThemeProvider>(context).themeData == darkMode)
                                GradientText("Se inscreva gratuitamente", 
                                  style: Styles.body.merge(TextStyle(color: Colors.white)),
                                  gradient: LinearGradient(colors: [Color(0xFF5BFCFC),Color(0XFF328FFB)]),)
                              else
                                Text("Se inscreva gratuitamente", style: Styles.body.merge(TextStyle(color: Color(0xFF1E5799))),)
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    if(Provider.of<ThemeProvider>(context).themeData == darkMode)
                      SvgPicture.asset("assets/svgs/arrow-right-dark.svg")
                    else
                      SvgPicture.asset("assets/svgs/arrow-right-light.svg")
                  ],
              ), 
              height: 64, 
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(92, 201, 255, 0.3),
                  Color.fromRGBO(74, 161, 204, 0.3),
                  Color.fromRGBO(41, 116, 204, 0.3)
                ]),
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(12))
                        ),),
            ),)
        ],
      ),
    );
  }
}
