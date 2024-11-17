import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internalinformationmanagement/app.dart';
import 'package:internalinformationmanagement/screens/blog_screen.dart';
import 'package:internalinformationmanagement/service/login_service.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreenWidget extends StatefulWidget {
  final SharedPreferences preferences;
  const LoginScreenWidget({super.key, required this.preferences});

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> with SingleTickerProviderStateMixin {
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
    _animationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _animation = Tween<double>(begin: !_isRegistering ? 166 : 84, end: !_isRegistering ? 84 : 166).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCubic));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
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
      final token = await _loginService.login(context, _emailController.text, _passwordController.text);

      if (token != "") {
        setState(() {
          _isLoading = true; // Ativa a animação
        });

        // Simula um tempo de espera antes de navegar para a próxima tela
        Future.delayed(const Duration(seconds: 2), () {
          prefs.setBool('is_logged_in', true);
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

  void _handleSignIn(String type) async {
    if (type == "google") {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

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
              prefs.setBool('is_logged_in', true);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BlogScreen(prefs: widget.preferences,)),
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
      _signInWithApple();
    }
  }

  Future<void> _signInWithApple() async {
    try {
      final appleIdCredential = await SignInWithApple.getAppleIDCredential(
        webAuthenticationOptions:
            WebAuthenticationOptions(clientId: 'adventistas.org.internalinformationmanagement.prod', redirectUri: Uri.parse('https://iatech-83ac9.firebaseapp.com/__/auth/handler')),
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );
      final resultCredential = await _loginUserWithCredential(credential);

      var token = await resultCredential?.user!.getIdToken(true);

      bool? isNewUser = resultCredential?.additionalUserInfo!.isNewUser;

      if (isNewUser! == false) {
        Map<String, dynamic> userIdMapped = Jwt.parseJwt(token!);

        await _setJwt(token, _isChecked, "apple");

        var documents = await FirebaseFirestore.instance.collection('users').doc(userIdMapped['user_id']).get();

        if (documents.exists) {
          setState(() {
            _isLoading = true; // Ativa a animação
          });

          // Simula um tempo de espera antes de navegar para a próxima tela
          Future.delayed(const Duration(seconds: 2), () {
            prefs.setBool('is_logged_in', true);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BlogScreen(prefs: widget.preferences,))
              //MaterialPageRoute(builder: (context) => const AppScreens()),
            ).then((value) {
              setState(() {
                _isLoading = false;
              });
            });
          });
        }
      } else {
        Map<String, dynamic> userIdMapped = Jwt.parseJwt(token!);

        await _setJwt(token, _isChecked, "apple");

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userIdMapped['user_id'])
            .set({'user_id': userIdMapped['user_id'], 'given_name': appleIdCredential.givenName, 'family_name': appleIdCredential.familyName});

        setState(() {
          _isLoading = true; // Ativa a animação
        });

        // Simula um tempo de espera antes de navegar para a próxima tela
        Future.delayed(const Duration(seconds: 2), () {
          prefs.setBool('is_logged_in', true);
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
    }
  }

  Future<UserCredential?> _loginUserWithCredential(
      OAuthCredential credential) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
    }
    return null;
  }

  void _loginAd() async {
    try {
      final microsoftProvider = OAuthProvider('microsoft.com');

      final credential = await FirebaseAuth.instance.signInWithProvider(microsoftProvider);

      var token = await credential.user?.getIdToken(true);

      await _setJwt(token!, _isChecked, "outlook");

      setState(() {
        _isLoading = true; // Ativa a animação
      });

      // Simula um tempo de espera antes de navegar para a próxima tela
      Future.delayed(const Duration(seconds: 2), () {
        prefs.setBool('is_logged_in', true);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BlogScreen(prefs: widget.preferences))
          //MaterialPageRoute(builder: (context) => const AppScreens()),
        ).then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${e.toString()}')));
    }
  }

  /*
  Essa função vai levar o usuário para a tela fake de login
  porem como nao existe ainda, está em branco
  */
  void _fakeLogin() {
    if (_emailController.text.contains("@") && _passwordController.text.length > 3) {
      widget.preferences.setBool('is_logged_in', true);
      Navigator.push(context, MaterialPageRoute(builder: (context) => BlogScreen(prefs: widget.preferences,)));
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("E-mail or password are not right.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [MainColors.primary03, FoundationColors.foundationSecondaryDarkest])),
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
              child: Expanded(flex: _isRegistering ? 7 : 6, child: !_isRegistering ? loginAndRegister(context) : registerAccount(context)),
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
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Text(
                    !_isRegistering ? "Entrar" : "Cadastre-se",
                    style: Styles.h5,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      !_isRegistering ? "Conecte-se para continuar para sua conta." : "Cadastre-se para usar o patrimônio",
                      style: Styles.bodySmall.merge(const TextStyle(color: TextColors.text4)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: formTextFields(context),
                  ),
                ],
              ),
            ),
          ),
          /*Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _isRegistering = !_isRegistering;
                });
              },
              child: Text(
                !_isRegistering ? "Cadastre-se" : "Entrar",
                style: Styles.bodySmall.merge(
                  const TextStyle(color: MainColors.primary03),
                ),
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  /*
  SCREEN - REGISTER
  */
  Widget registerAccount(BuildContext context) {
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
                  "Cadastre sua conta!",
                  style: Styles.h5,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Insira o e-mail e senha para cadastrar sua conta",
                    textAlign: TextAlign.center,
                    style: Styles.bodySmall.merge(const TextStyle(color: TextColors.text4)),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
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
                                  borderSide: const BorderSide(width: 1.5, color: TextColors.text5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),

                          //if (_isRegistering)
                          //  Padding(
                          //    padding: const EdgeInsets.only(top: 24.0),
                          //    child: TextFormField(
                          //      controller: _cpfController,
                          //      keyboardType: TextInputType.number,
                          //      inputFormatters: [
                          //        MaskTextInputFormatter(
                          //            mask: '###.###.###-##',
                          //            filter: {"#": RegExp(r'[0-9]')})
                          //      ],
                          //      decoration: InputDecoration(
                          //          prefixIcon: Padding(
                          //            padding: const EdgeInsets.only(
                          //                left: 15.0, right: 4),
                          //            child: SvgPicture.asset(
                          //                'assets/svgs/cpf_icon.svg'),
                          //          ),
                          //          prefixIconConstraints:
                          //              const BoxConstraints(maxHeight: 12),
                          //          label: const Text("CPF"),
                          //          constraints:
                          //              const BoxConstraints(maxHeight: 42),
                          //          border: OutlineInputBorder(
                          //              borderRadius: BorderRadius.circular(10),
                          //              borderSide: const BorderSide(
                          //                  width: 1.5,
                          //                  color: TextColors.text5))),
                          //    ),
                          //  ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: TextFormField(
                              controller: _passwordController,
                              keyboardType: TextInputType.name,
                              obscureText: true,
                              decoration: InputDecoration(
                                  label: const Text("Senha"),
                                  constraints: const BoxConstraints(maxHeight: 42),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 1.5, color: TextColors.text5))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  _fakeLogin();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Theme.of(context).primaryColor,
                                  textStyle: Styles.headline4,
                                ),
                                child: Text(
                                  'Login',
                                  style: Styles.button.merge(const TextStyle(color: TextColors.text7)),
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
                                _isRegistering = !_isRegistering;
                              });
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Voltar para o login",
                                style: Styles.bodySmall.merge(const TextStyle(color: MainColors.primary03)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /*
  SECTION - FORM TEXT FIELDS
  */
  Widget formTextFields(BuildContext context) {
    Color getColor(Set<WidgetState> states) {
      const Set<WidgetState> interactiveStates = <WidgetState>{
        WidgetState.pressed,
        WidgetState.selected,
        WidgetState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.transparent;
      }
      return Colors.transparent;
    }

    return Form(key: _formKey, child: formButtonsWidget());
  }

  /*
  SECTION - FORM BUTTONS WIDGET
  */
  Widget formButtonsWidget() {
    Color getColor(Set<WidgetState> states) {
      const Set<WidgetState> interactiveStates = <WidgetState>{
        WidgetState.pressed,
        WidgetState.selected,
        WidgetState.focused,
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
          Container(
            width: MediaQuery.of(context).size.width,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                _loginAd();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(side: BorderSide(width: 1, color: TextColors.text5), borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.white,
                textStyle: Styles.headline4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Entrar com Microsoft',
                    style: Styles.buttonSmall.merge(TextStyle(color: TextColors.text1)),
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
                  shape: RoundedRectangleBorder(side: BorderSide(width: 1, color: TextColors.text5), borderRadius: BorderRadius.circular(10)),
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
          if (Platform.isIOS)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    _handleSignIn("ios");
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(side: BorderSide(width: 1, color: TextColors.text5), borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.grey[400],
                    textStyle: Styles.headline4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login com ',
                        style: Styles.buttonSmall
                            .merge(TextStyle(color: Colors.black)),
                      ),
                      Icon(
                        FontAwesomeIcons.apple,
                        color: Colors.black,
                      )
                    ],
                  ),
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
                style: Styles.body.merge(const TextStyle(color: TextColors.text4)),
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

          SizedBox(height: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
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
                      borderSide: const BorderSide(width: 1.5, color: TextColors.text5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
          
              //if (_isRegistering)
              //  Padding(
              //    padding: const EdgeInsets.only(top: 24.0),
              //    child: TextFormField(
              //      controller: _cpfController,
              //      keyboardType: TextInputType.number,
              //      inputFormatters: [
              //        MaskTextInputFormatter(
              //            mask: '###.###.###-##',
              //            filter: {"#": RegExp(r'[0-9]')})
              //      ],
              //      decoration: InputDecoration(
              //          prefixIcon: Padding(
              //            padding: const EdgeInsets.only(
              //                left: 15.0, right: 4),
              //            child: SvgPicture.asset(
              //                'assets/svgs/cpf_icon.svg'),
              //          ),
              //          prefixIconConstraints:
              //              const BoxConstraints(maxHeight: 12),
              //          label: const Text("CPF"),
              //          constraints:
              //              const BoxConstraints(maxHeight: 42),
              //          border: OutlineInputBorder(
              //              borderRadius: BorderRadius.circular(10),
              //              borderSide: const BorderSide(
              //                  width: 1.5,
              //                  color: TextColors.text5))),
              //    ),
              //  ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.name,
                  obscureText: true,
                  decoration: InputDecoration(
                      label: const Text("Senha"),
                      constraints: const BoxConstraints(maxHeight: 42),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 1.5, color: TextColors.text5))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      _fakeLogin();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Theme.of(context).primaryColor,
                      textStyle: Styles.headline4,
                    ),
                    child: Text(
                      'Cadastrar',
                      style: Styles.button.merge(const TextStyle(color: TextColors.text7)),
                    ),
                  ),
                ),
                
          ),
          SizedBox(height: 16,),
                    Row(
                      children: [
                        SizedBox(
                          height: 18,
                          width: 18,
                          child: Container(
                            decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), border: _isChecked ? Border.all(width: 2, color: Theme.of(context).primaryColor) : Border.all(width: 2, color: TextColors.text2)),
                            child: Checkbox(
          fillColor: WidgetStateProperty.resolveWith(getColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
                          child: Text("Lembrar minha conta", style: Styles.caption),
                        ),
                      ],
                    ),
          ]),
        ],
      ),
    );
  }
}
