import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internalinformationmanagement/flavors.dart';
import 'package:internalinformationmanagement/widgets/custom_modal.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/Palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:internalinformationmanagement/theme/theme.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import 'package:internalinformationmanagement/theme/theme_provider.dart';
import 'package:internalinformationmanagement/widgets/home_listview_widget.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  Map<String, dynamic> _userData = {};
  String fullName = "";
  late Future<String> _fullNameFuture;
  String? _jwt;

  @override
  void initState() {
    super.initState();
    _fullNameFuture = _loadUserData();
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomModal();
        });
  }

  Future<String> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt_token');
    final login_type = prefs.getString('login_type');
    if (jwt == null || jwt.isEmpty) {
      Navigator.pushReplacementNamed(context, "/login");
      return "";
    }

    if (login_type == 'apple') {
      _userData = Jwt.parseJwt(jwt);
      var document = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userData['user_id'])
          .get();

      Map<String, dynamic>? data = document.data();

      if ((data!['given_name'].contains("DSA") ||
              data['given_name'].contains("IATec")) &&
          data['given_name'].split(" ").length > 3) {
        return "${data['given_name'].split(" ")[2]} ${data['given_name'].split(" ")[3]}";
      } else {
        return "${data['given_name'].split(" ")[0]}";
      }
    } else if (login_type == "outlook") {
      try {
        _userData = Jwt.parseJwt(jwt);
        if ((_userData['name'].contains("DSA") ||
                _userData['name'].contains("IATec")) &&
            _userData['name'].split(" ").length > 3) {
          return "${_userData['name'].split(" ")[2]} ${_userData['name'].split(" ")[3]}";
        } else {
          return "${_userData['name'].split(" ")[0]} ${_userData['name'].split(" ")[1]}";
        }
      } catch (e) {
        print("Error parsing JWT: $e");
        return "";
      }
    } else {
      final response = await http.get(
        Uri.parse('https://www.googleapis.com/oauth2/v1/userinfo?alt=json'),
        headers: {'Authorization': 'Bearer $jwt'},
      );

      if (response.statusCode == 200) {
        try {
          _userData = json.decode(response.body);
          if ((_userData['name'].contains("DSA") ||
                  _userData['name'].contains("IATec")) &&
              _userData['name'].split(" ").length > 3) {
            return "${_userData['name'].split(" ")[2]} ${_userData['name'].split(" ")[3]}";
          } else {
            return "${_userData['name'].split(" ")[0]} ${_userData['name'].split(" ")[1]}";
          }
        } catch (e) {
          print(e);
        }
        return "";
      } else {
        return "Usuário";
      }
    }
  }

  String getName() {
    return fullName.split(" ")[0];
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', '');
    await prefs.setBool('auto_login', false);
    await prefs.setString("login_type", "");
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          /*
        
        SECTION - Drawer
        
        */
          drawer: Drawer(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            backgroundColor:
                Provider.of<ThemeProvider>(context).themeData == darkMode
                    ? MainColors.primary03
                    : MainColors.primary02,
            key: _scaffoldKey,
            child: FutureBuilder<String>(
              future: _loadUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LinearProgressIndicator();
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  fullName = snapshot.data ?? "";
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          DrawerHeader(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                child: Text(
                                  fullName.isNotEmpty
                                      ? "${fullName.split("")[0]}"
                                      : "",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("$fullName",
                                        style: Styles.titleSmall.merge(
                                            TextStyle(
                                                color: MainColors.primary03))),
                                  ],
                                ),
                              )
                            ],
                          )),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 30,
                            ),
                            child: ListTile(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext build) {
                                      return AlertDialog(
                                        title: const Text('Excluir conta!'),
                                        content: Text(
                                            "Você tem certeza que quer excluir sua conta?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                _logout(context);
                                              },
                                              child: Text("Sim")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Não")),
                                        ],
                                      );
                                    });
                              },
                              leading: Icon(
                                CupertinoIcons.clear_circled_solid,
                                color: Colors.white,
                              ),
                              title: Text("Excluir conta",
                                  style: Styles.titleMedium.merge(
                                      TextStyle(color: MainColors.primary03))),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 30, bottom: 30),
                            child: ListTile(
                              onTap: () {
                                _logout(context);
                              },
                              leading: SvgPicture.asset(
                                  'assets/svgs/logout.svg',
                                  height: 24,
                                  color: Colors.white),
                              title: Text("Sair da conta",
                                  style: Styles.titleMedium.merge(
                                      TextStyle(color: MainColors.primary03))),
                            ),
                          )
                        ],
                      )
                    ],
                  );
                } else {
                  return Text("Ixi");
                }
              },
            ),
          ),
          /*
      
          SECTION - Body
      
          */
          body: Banner(
            message: F.env,
            location: BannerLocation.topEnd,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient:
                      Provider.of<ThemeProvider>(context).themeData == darkMode
                          ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                  MainColors.primary03,
                                  FoundationColors.foundationSecondaryDarkest
                                ])
                          : LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.white, MainColors.primary02])),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Column(
                        children: [
                          SafeArea(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Builder(builder: (context) {
                                return IconButton(
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                  icon: Icon(Icons.menu),
                                  iconSize: 35,
                                );
                              })
                            ],
                          )),
                          FutureBuilder(
                              future: _loadUserData(),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  fullName = snapshot.data ?? "";
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 44.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Olá, ",
                                          style: AppTextStyles.largeTitle.merge(
                                              TextStyle(
                                                  color: TailwindColors
                                                      .tailwindBlack)),
                                        ),
                                        Text(
                                          "${fullName.split(" ")[0]}",
                                          style: DesktopTextStyles.headlineH4
                                              .merge(TextStyle(
                                                  color: TailwindColors
                                                      .tailwindBlack)),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Text("Eita");
                                }
                              })),
                          Padding(
                            padding: const EdgeInsets.only(top: 28.0),
                            child: GestureDetector(
                              onTap: () {
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: ShadeColors.shadeLight
                                        .withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.search),
                                    Padding(
                                      padding: EdgeInsets.only(left: 12),
                                      child:
                                          Text("Pesquise por um conteudo..."),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          /*
                                        
                              The section below contains 3 buttons that
                              can change the content of the cards on the section below
                              this one.
                                        
                              */

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 33.0),
                                child: HomeListViewWidget(),
                              ),
                              /*
                              Padding(
                                padding: EdgeInsets.only(top: 33),
                                child: Text(
                                  "Acompanhe aqui as sua",
                                  style: AppTextStyles.boldCaption1.merge(
                                      TextStyle(
                                          color: FoundationColors
                                              .foundationPrimaryDarkest)),
                                ),
                              ),
                              Text(
                                "últimas atualizações",
                                style: Styles.titleSmall.merge(TextStyle(
                                    color: Theme.of(context).primaryColor)),
                              ),
                              Divider(
                                color: TextColors.text5,
                                height: 10,
                                thickness: 2,
                              ),
                              LastUpdatesButtonsWidgets(),
                              /*
                                      
                                  The section below contains a
                                  Column with cards. The cards shown will be 
                                  static content, and soon their contents will change
                                  turning them dynamic.
                                                        
                                  */
                              LastUpdatesWidget()*/
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
