import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internalinformationmanagement/screens/home_screen.dart';
import 'package:internalinformationmanagement/service/auth_ad_service.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../util/Palette.dart';

class LoginScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const LoginScreen({super.key, required this.navigatorKey});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late Config config;
  late AuthService authService;

  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isLoading = false;
  bool _isRegistering = false;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animation = Tween<double>(
            begin: !_isRegistering ? 166 : 84, end: !_isRegistering ? 84 : 166)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOutCubic));

    config = Config(
        customDomainUrlWithTenantId:
            'https://login.microsoftonline.com/common/${dotenv.env['AAD_TENANT_ID']}',
        clientId: '${dotenv.env['AAD_CLIENT_ID']}',
        tenant: '${dotenv.env['AAD_TENANT_ID']}',
        scope: 'user.read openid profile offline_access',
        redirectUri: '${dotenv.env['AAD_REDIRECT_URI']}',
        navigatorKey: widget.navigatorKey);

    authService = AuthService(oAuth: AadOAuth(config));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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

  void _loginAd() async {
    final result = await authService.login();
    if (result) {
      //String? token = await authService.getAccessToken();
      //if (token != null) {
      setState(() {
        _isLoading = true; // Ativa a animação
      });

      // Simula um tempo de espera antes de navegar para a próxima tela
      Future.delayed(Duration(seconds: 2), () {
        widget.navigatorKey.currentState?.pushNamed('/home').then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      });
      //}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Evita que a tela seja redimensionada quando o teclado é exibido
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Visibility(
                visible: !_isLoading,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Container(
                        height: _animation.value,
                        child: Center(
                          child: Image.asset(
                            'assets/imgs/Computer login-amico 1.png',
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
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    decoration: BoxDecoration(
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
                                  style: Styles.bodySmall.merge(
                                      TextStyle(color: TextColors.text4)),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: formTextFields(context)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Não tem uma conta? ",
                                            style: Styles.bodySmall.merge(
                                                TextStyle(
                                                    color: TextColors.text4))),
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
                                            "Cadastrar-se",
                                            style: Styles.bodySmall.merge(
                                                TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor)),
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
                  ),
                ),
              ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isRegistering)
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  label: Text("Nome"),
                  constraints: BoxConstraints(maxHeight: 42),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(width: 1.5, color: TextColors.text5))),
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
                    prefixIconConstraints: BoxConstraints(maxHeight: 12),
                    label: Text("CPF"),
                    constraints: BoxConstraints(maxHeight: 42),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(width: 1.5, color: TextColors.text5))),
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
                label: Text("E-mail"),
                constraints: BoxConstraints(maxHeight: 42),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.5, color: TextColors.text5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(left: 12, right: 16.0),
                        child: SvgPicture.asset(
                          'assets/svgs/eye.svg',
                        ),
                      ),
                      label: Text("Senha"),
                      constraints: BoxConstraints(maxHeight: 42),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.5, color: TextColors.text5),
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
                              child: Text("Lembrar minha senha",
                                  style: Styles.caption),
                            ),
                          ],
                        ),
                        Text(
                          "Esqueceu a senha?",
                          style: Styles.caption.merge(
                              TextStyle(color: Theme.of(context).primaryColor)),
                        )
                      ],
                    ),
                  ),
                formButtonsWidget()
              ],
            ),
          ),
        ],
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
                _login();
              },
              child: Text(
                'Entrar',
                style: Styles.button.merge(TextStyle(color: TextColors.text7)),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Theme.of(context).primaryColor,
                textStyle: Styles.headline4,
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 136,
                child: Divider(thickness: 1, color: TextColors.text5),
              ),
              Text(
                "ou",
                style: Styles.body.merge(TextStyle(color: TextColors.text4)),
              ),
              Container(
                width: 136,
                child: Divider(
                  thickness: 1,
                  color: TextColors.text5,
                ),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                _loginAd();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Conecte-se com SSO',
                    style: Styles.buttonSmall,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SvgPicture.asset('assets/svgs/key.svg'),
                  )
                ],
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: TextColors.text5),
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.white,
                textStyle: Styles.headline4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
