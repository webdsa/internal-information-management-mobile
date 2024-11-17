// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internalinformationmanagement/models/news_model.dart';
import 'package:internalinformationmanagement/screens/login_screen.dart';
import 'package:internalinformationmanagement/theme/theme.dart';
import 'package:internalinformationmanagement/theme/theme_provider.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import 'package:internalinformationmanagement/util/news_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/new.dart';
final _navigatorKey = GlobalKey<NavigatorState>();
class LastNewsScreen extends StatefulWidget {
  final SharedPreferences prefs;
  const LastNewsScreen({super.key, required this.prefs});

  @override
  State<LastNewsScreen> createState() => _LastNewsScreenState();
}

class _LastNewsScreenState extends State<LastNewsScreen> {
  final FocusNode focusNode = FocusNode();
  List<NewsModel> listNewsFakeSearch = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    listNewsFakeSearch = listNewsFake;
  }

  initPrefs() async {
    preferences = await SharedPreferences.getInstance();
  }

  searchNews(String text) {
    if (text.isEmpty) {
      setState(() {
        listNewsFakeSearch = listNewsFake;
      });
      return;
    }
    setState(() {
      listNewsFakeSearch = listNewsFake.where((element) {
        return element.title.toLowerCase().contains(text.toLowerCase());
      }).toList();
    });
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', '');
    await prefs.setBool('auto_login', false);
    await prefs.setString("login_type", "");
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    initPrefs();
    return Scaffold(
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
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (preferences.getBool("is_logged_in") == false)
                         DrawerHeader(
                                child: 
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Align(alignment: Alignment.topCenter, child: TextButton(child: Text("Realizar Login"), onPressed: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => LoginScreen(navigatorKey: _navigatorKey, prefs: widget.prefs,)));
                                  },),),
                                )),
                      if (preferences.getBool("is_logged_in") == true)
                        Column(
                          children: [
                            DrawerHeader(
                                child: 
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(child: Image.asset("assets/imgs/image 1.png"),),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Amanda Gonçalves",
                                              style: Styles.titleSmall.merge(
                                                  TextStyle(
                                                      color: MainColors.primary03))),
                                          
                                          Text("Cargo",
                                              style: TextStyle(
                                                      color: MainColors.primary03)),

                                        ],
                                      ),
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          if (widget.prefs.getBool("is_logged_in") == true)
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
                                                      widget.prefs.setBool("is_logged_in", false);
                                                      _logout(context);
                                                    },
                                                    child: Text("Sim")),
                                                TextButton(
                                                    onPressed: () {
                                                      widget.prefs.setBool("is_logged_in", false);
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
                                      widget.prefs.setBool("is_logged_in", false);
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
                    ]
                  )
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFDEE9F7),
              Color(0xFFB2D6FF),
              Color(0xFFB2D6FF),
            ],
          ),
        ),
        child: Column(children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 7),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
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
            ),
          ),
          SizedBox(height: 7),
          Expanded(
            child: Stack(children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 27),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 41),
                      Text('Últimas notícias', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 34, color: Color(0xFF000000))),
                      Text('Igreja Adventista', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32, color: Color(0xFF1E5799))),
                      SizedBox(height: 31),
                      TextField(
                        onChanged: searchNews,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0x0D000000),
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(width: 1, color: Color(0xFFBAC7D5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(width: 1, color: Color(0xFFBAC7D5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(width: 1, color: Color(0xFFBAC7D5)),
                          ),
                          hintText: 'Pesquise por um conteúdo...',
                          prefixIcon: SizedBox(child: Center(child: SvgPicture.asset('assets/svgs/nav_search.svg', width: 30)), width: 10),
                        ),
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black),
                      ),
                      SizedBox(height: 25),
                      ...listNewsFakeSearch.map((e) => News(newsModel: e, prefs: widget.prefs,)).toList(),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              Positioned(
                // alignment: Alignment.bottomCenter,
                bottom: -2,
                child: Container(
                  height: 141,
                  width: MediaQuery.of(context).size.width,
                  child: SvgPicture.asset('assets/svgs/transparent_box.svg'),
                ),
              ),
            ]),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFB2D6FF),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF99B7DA),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0, -6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 53,
                    child: SvgPicture.asset('assets/svgs/nav_home.svg'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    focusNode.requestFocus();
                  },
                  child: Container(
                    child: SvgPicture.asset('assets/svgs/nav_search.svg'),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    child: SvgPicture.asset('assets/svgs/nav_newspaper.svg'),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    child: SvgPicture.asset('assets/svgs/nav_user.svg'),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
