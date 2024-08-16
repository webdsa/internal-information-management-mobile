import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/app.dart';
import 'package:internalinformationmanagement/flavors.dart';
import 'package:internalinformationmanagement/screens/home_screen.dart';
import 'package:internalinformationmanagement/service/login_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({super.key});

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget>
    with SingleTickerProviderStateMixin {
  final LoginService _loginService = LoginService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _animation;
  late SharedPreferences prefs;

  bool _isLoading = false;
  bool _isRegistering = false;
  bool _isChecked = false;
  bool _isHidingPassword = true;
  bool _forgetPassword = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _animation = Tween<double>(
            begin: !_isRegistering ? 166 : 84, end: !_isRegistering ? 84 : 166)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOutCubic));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _setJwt(String token, bool auto_login, String login_type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    final int currentTime = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt('last_login_time', currentTime);
    await prefs.setBool("auto_login", auto_login);
    await prefs.setString("login_type", login_type);
  }

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
            MaterialPageRoute(builder: (context) => const AppScreens()),
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

  void appleSignIn() async {
    try {
      AuthorizationResult authResult = await TheAppleSignIn.performRequests([AppleIdRequest(requestedScopes: [Scope.email,Scope.fullName])]);
    
      switch (authResult.status) {
        case AuthorizationStatus.authorized:
          AppleIdCredential? appleCredentials = authResult.credential;
          OAuthProvider oaprovider = OAuthProvider("apple.com");
          OAuthCredential oAuthCredential = oaprovider.credential(
            idToken: String.fromCharCodes(appleCredentials!.identityToken!),
            accessToken: String.fromCharCodes(appleCredentials.authorizationCode!)
          );
  
          UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
        var token = userCredential.user?.getIdToken(true);
        print(token);
          print("Credenciais do usuario: $userCredential");
          print("authorizer");
          break;
        case AuthorizationStatus.cancelled:
          print("cancelled");
          break;
        case AuthorizationStatus.error:
          print("error");
          break;
        default:
          print("None of the above");
          break;
      }
  } catch (e) {
    print(e.toString());
  }
  }

  void _handleSignIn(String type) async {
    if (type == "google") {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

        if (googleAuth != null) {
          final String? accessToken = googleAuth.accessToken;
 
          await _setJwt(accessToken!, _isChecked, "gmail");
          // Use o token de acesso para obter informações do perfil
          if (accessToken != "") {
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
          }
        }
      } catch (error) {
        print(error);
      }
    } else if (type == "ios") {
      appleSignIn();
    }
  }

  void _loginAd() async {
    try {
      final microsoftProvider = OAuthProvider('microsoft.com');
      final credential =
          await FirebaseAuth.instance.signInWithProvider(microsoftProvider);

      var token = await credential.user?.getIdToken(true);

      await _setJwt(token!, _isChecked, "outlook");

      if (token != null) {
        setState(() {
          _isLoading = true; // Ativa a animação
        });

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
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
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
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Container(
                      height: _animation.value,
                      child: Center(
                        child: Image.asset(
                          'assets/imgs/Mobile login-rafiki (2) 1.png',
                          width: _isRegistering ? 84 : 166,
                          height: _isRegistering ? 84 : 166,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: !_isLoading,
              child: Expanded(
                  flex: _isRegistering ? 7 : 6,
                  child: !_forgetPassword
                      ? loginAndRegister(context)
                      : forgetPassword(context)),
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

  /*
  SCREEN - LOGIN AND REGISTER
  */
  Widget loginAndRegister(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: FoundationColors.foundationPrimaryLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  Text(
                    !_isRegistering ? "Entrar" : "Cadastre-se",
                    style: Styles.h5,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      !_isRegistering
                          ? "Conecte-se para continuar para sua conta."
                          : "Cadastre-se para usar o patrimônio",
                      style: Styles.bodySmall
                          .merge(const TextStyle(color: TextColors.text4)),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: formTextFields(context)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        !_isRegistering
                            ? "Não tem uma conta? "
                            : "Já tem uma conta? ",
                        style: Styles.bodySmall.merge(
                            const TextStyle(color: TextColors.text4))),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isRegistering = !_isRegistering;
                        });
                        if (_isRegistering) {
                          _animationController.forward();
                        } else {
                          _animationController.reverse();
                        }
                      },
                      child: Text(
                        !_isRegistering ? "Cadastrar-se" : "Entrar",
                        style: Styles.bodySmall.merge(TextStyle(
                            color: Theme.of(context).primaryColor)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /*
  SCREEN - FORGET PASSWORD
  */
  Widget forgetPassword(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Color(0xFFEFF4FF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: [
                Text(
                  "Esqueceu a senha?",
                  style: Styles.h5,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Insira o e-mail associado com a sua conta para receber um código de verificação",
                    textAlign: TextAlign.center,
                    style: Styles.bodySmall
                        .merge(const TextStyle(color: TextColors.text4)),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_isRegistering)
                            TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  label: const Text("Nome"),
                                  constraints:
                                      const BoxConstraints(maxHeight: 42),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          width: 1.5,
                                          color: TextColors.text5))),
                            ),
                          if (_isRegistering)
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: TextFormField(
                                controller: _cpfController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                      mask: '###.###.###-##',
                                      filter: {"#": RegExp(r'[0-9]')})
                                ],
                                decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 4),
                                      child: SvgPicture.asset(
                                          'assets/svgs/cpf_icon.svg'),
                                    ),
                                    prefixIconConstraints:
                                        const BoxConstraints(maxHeight: 12),
                                    label: const Text("CPF"),
                                    constraints:
                                        const BoxConstraints(maxHeight: 42),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            width: 1.5,
                                            color: TextColors.text5))),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
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
                                label: const Text("E-mail"),
                                constraints:
                                    const BoxConstraints(maxHeight: 42),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1.5, color: TextColors.text5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  _login();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  textStyle: Styles.headline4,
                                ),
                                child: Text(
                                  'Solicitar código',
                                  style: Styles.button.merge(
                                      const TextStyle(color: TextColors.text7)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _forgetPassword = !_forgetPassword;
                              });
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Voltar para o login",
                                style: Styles.caption.merge(TextStyle(
                                    color: Theme.of(context).primaryColor)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 136,
                                child: const Divider(
                                    thickness: 1, color: TextColors.text5),
                              ),
                              Text(
                                "ou",
                                style: Styles.body.merge(
                                    const TextStyle(color: TextColors.text4)),
                              ),
                              Container(
                                width: 136,
                                child: const Divider(
                                  thickness: 1,
                                  color: TextColors.text5,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
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
                                    side: const BorderSide(
                                        width: 1, color: TextColors.text5),
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: Colors.white,
                                textStyle: Styles.headline4,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Conecte-se com SSO',
                                    style: Styles.buttonSmall.merge(
                                        TextStyle(color: TextColors.text1)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child:
                                        SvgPicture.asset('assets/svgs/key.svg'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Não tem uma conta? ",
                              style: Styles.bodySmall.merge(
                                  const TextStyle(color: TextColors.text4))),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _forgetPassword = !_forgetPassword;
                                _isRegistering = !_isRegistering;
                              });
                              if (_isRegistering) {
                                _animationController.forward();
                              } else {
                                _animationController.reverse();
                              }
                            },
                            child: Text(
                              "Cadastrar-se",
                              style: Styles.bodySmall.merge(TextStyle(
                                  color: Theme.of(context).primaryColor)),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /*
  SECTION - FORM TEXT FIELDS
  */
  Widget formTextFields(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.selected,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.transparent;
      }
      return Colors.transparent;
    }

    return Form(
      key: _formKey,
      child: /*Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isRegistering)
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  label: const Text("Nome"),
                  constraints: const BoxConstraints(maxHeight: 42),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          width: 1.5, color: TextColors.text5))),
            ),
          if (_isRegistering)
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: TextFormField(
                controller: _cpfController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MaskTextInputFormatter(
                      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')})
                ],
                decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 4),
                      child: SvgPicture.asset('assets/svgs/cpf_icon.svg'),
                    ),
                    prefixIconConstraints: const BoxConstraints(maxHeight: 12),
                    label: const Text("CPF"),
                    constraints: const BoxConstraints(maxHeight: 42),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 1.5, color: TextColors.text5))),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
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
                label: const Text("E-mail"),
                constraints: const BoxConstraints(maxHeight: 42),
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1.5, color: TextColors.text5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isHidingPassword,
                  decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 16.0),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _isHidingPassword = !_isHidingPassword;
                            });
                          },
                          icon: SvgPicture.asset(
                            'assets/svgs/eye.svg',
                          ),
                        ),
                      ),
                      label: const Text("Senha"),
                      constraints: const BoxConstraints(maxHeight: 42),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1.5, color: TextColors.text5),
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                if (!_isRegistering)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 18,
                              width: 18,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: _isChecked
                                        ? Border.all(
                                            width: 2,
                                            color:
                                                Theme.of(context).primaryColor)
                                        : Border.all(
                                            width: 2, color: TextColors.text2)),
                                child: Checkbox(
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            getColor),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    checkColor: Theme.of(context).primaryColor,
                                    value: _isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isChecked = value!;
                                      });
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text("Lembrar minha conta",
                                  style: Styles.caption),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _forgetPassword = !_forgetPassword;
                            });
                          },
                          child: Text(
                            "Esqueceu a senha?",
                            style: Styles.caption.merge(TextStyle(
                                color: Theme.of(context).primaryColor)),
                          ),
                        )
                      ],
                    ),
                  ),
                formButtonsWidget()
              ],
            ),
          ),
        ],
      ),*/
      formButtonsWidget()
    );
  }

  /*
  SECTION - FORM BUTTONS WIDGET
  */
  Widget formButtonsWidget() {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.selected,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.transparent;
      }
      return Colors.transparent;
    }


    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        children: [
          /*
          Container(
            width: MediaQuery.of(context).size.width,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                _login();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Theme.of(context).primaryColor,
                textStyle: Styles.headline4,
              ),
              child: Text(
                'Entrar',
                style: Styles.button
                    .merge(const TextStyle(color: TextColors.text7)),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 136,
                child: const Divider(thickness: 1, color: TextColors.text5),
              ),
              Text(
                "ou",
                style:
                    Styles.body.merge(const TextStyle(color: TextColors.text4)),
              ),
              Container(
                width: 136,
                child: const Divider(
                  thickness: 1,
                  color: TextColors.text5,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),*/
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
                    'Conecte-se com SSO',
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
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 136,
                child: const Divider(thickness: 1, color: TextColors.text5),
              ),
              Text(
                "ou",
                style:
                    Styles.body.merge(const TextStyle(color: TextColors.text4)),
              ),
              Container(
                width: 136,
                child: const Divider(
                  thickness: 1,
                  color: TextColors.text5,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          if (Platform.isAndroid || Platform.isIOS)
            Container(
              width: MediaQuery.of(context).size.width,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  _handleSignIn("google");
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: TextColors.text5),
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.red,
                  textStyle: Styles.headline4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login com ',
                      style: Styles.buttonSmall,
                    ),
                    Icon(FontAwesomeIcons.google)
                  ],
                ),
              ),
            ),
          const SizedBox(
            height: 16,
          ),
Row(
                          children: [
                            SizedBox(
                              height: 18,
                              width: 18,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: _isChecked
                                        ? Border.all(
                                            width: 2,
                                            color:
                                                Theme.of(context).primaryColor)
                                        : Border.all(
                                            width: 2, color: TextColors.text2)),
                                child: Checkbox(
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            getColor),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    checkColor: Theme.of(context).primaryColor,
                                    value: _isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isChecked = value!;
                                      });
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text("Lembrar minha conta",
                                  style: Styles.caption),
                            ),
                          ],
                        ),  
          //if (Platform.isIOS)
          //  Container(
          //    width: MediaQuery.of(context).size.width,
          //    height: 44,
          //    child: ElevatedButton(
          //      onPressed: () async {
          //        print(FirebaseAuth.instance.currentUser);
          //        _handleSignIn("ios");
          //        FirebaseAuth.instance.signOut();
          //      },
          //      style: ElevatedButton.styleFrom(
          //        elevation: 0,
          //        shape: RoundedRectangleBorder(
          //            side: BorderSide(width: 1, color: TextColors.text5),
          //            borderRadius: BorderRadius.circular(10)),
          //        backgroundColor: Colors.grey,
          //        textStyle: Styles.headline4,
          //      ),
          //      child: Row(
          //        mainAxisAlignment: MainAxisAlignment.center,
          //        children: [
          //          Text(
          //            'Login com ',
          //            style: Styles.buttonSmall,
          //          ),
          //          Icon(FontAwesomeIcons.apple)
          //        ],
          //      ),
          //    ),
          //  ),
        ],
      ),
    );
  }
}
