import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/Palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:internalinformationmanagement/flavors.dart';
import 'package:internalinformationmanagement/theme/theme.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import 'package:internalinformationmanagement/theme/theme_provider.dart';
import 'package:internalinformationmanagement/widgets/home_listview_widget.dart';
import 'package:internalinformationmanagement/widgets/last_updates_cards_widget.dart';
import 'package:internalinformationmanagement/widgets/last_updates_buttons_widget.dart';
import 'package:internalinformationmanagement/widgets/ScaffoldWidgets/drawer_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchContentController =
      TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MotionTabBarController? _motionTabBarController;
  int selectedIndex = 0;
  Map<String, dynamic> _userData = {};
  String? _jwt;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
        length: 3, initialIndex: selectedIndex, vsync: this);
    _checkJWT();
  }

  Future<void> _checkJWT() async {
    final prefs = await SharedPreferences.getInstance();
    _jwt = prefs.getString('jwt_token');
    if (_jwt != null || _jwt != "") {
      try {
        _userData = Jwt.parseJwt(_jwt!);
      } catch (e) {
        print("error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: MotionTabBar(
          initialSelectedTab: "Início",
          labels: ["Início", "Pesquisar", "Perfil"],
          icons: [Icons.home, Icons.search, Icons.person],
          controller: _motionTabBarController,
          tabIconColor: MainColors.primary04,
          tabBarColor: MainColors.primary02,
          tabIconSize: 28,
          onTabItemSelected: (index) => setState(() => selectedIndex = index),
          tabSelectedColor: MainColors.primary01,
          tabIconSelectedSize: 30,
          textStyle: TextStyle(
              color: MainColors.primary01,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        /*
      
      SECTION - Drawer
      
      */
        drawer: HomeDrawer(scaffoldKey: _scaffoldKey),
        /*

        SECTION - Body

        */
        body: Banner(
          location: BannerLocation.topEnd,
          message: F.env,
          textStyle: TextStyle(color: Colors.white, fontSize: 22),
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
                            IconButton(
                              onPressed: () =>
                                  _scaffoldKey.currentState?.openDrawer(),
                              icon: Icon(Icons.menu),
                              iconSize: 35,
                            )
                          ],
                        )),
                        FutureBuilder(
                            future: _checkJWT(),
                            builder: ((context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 44.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Olá,",
                                            style: AppTextStyles.largeTitle
                                                .merge(TextStyle(
                                                    color: TailwindColors
                                                        .tailwindBlack)),
                                          ),
                                          Text(
                                            "${_userData['name'].split(" ")[0]}",
                                            style: DesktopTextStyles.headlineH4
                                                .merge(TextStyle(
                                                    color: TailwindColors
                                                        .tailwindBlack)),
                                          ),
                                        ],
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
                          child: TextField(
                            controller: _searchContentController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                filled: true,
                                fillColor:
                                    ShadeColors.shadeLight.withOpacity(0.05),
                                label: Text("Pesquise por um conteudo..."),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10))),
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
                            LastUpdatesWidget()
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
