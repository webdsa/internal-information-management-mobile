import 'package:internalinformationmanagement/flavors.dart';

import '../util/Palette.dart';
import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import 'package:internalinformationmanagement/widgets/home_app_bar_widget.dart';
import 'package:internalinformationmanagement/widgets/home_listview_widget.dart';
import 'package:internalinformationmanagement/widgets/last_updates_cards_widget.dart';
import 'package:internalinformationmanagement/widgets/last_updates_buttons_widget.dart';
import 'package:internalinformationmanagement/widgets/ScaffoldWidgets/drawer_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*
      
      SECTION - Drawer
      
      */
        drawer: HomeDrawer(scaffoldKey: _scaffoldKey),
        /*

        SECTION - Bottom Nav Bar

        */
        bottomNavigationBar: DotNavigationBar(
          backgroundColor: Color(0xFFFFFFFF),
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Color(0xFFDEDDE4),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            DotNavigationBarItem(icon: Icon(Icons.person)),
            DotNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
            ),
            DotNavigationBarItem(
              icon: Icon(
                Icons.mail_outline,
              ),
            )
          ],
        ),
        /*

        SECTION - Body

        */
        body: Banner(
          location: BannerLocation.topEnd,
          message: F.env,
          textStyle: TextStyle(color: Colors.white, fontSize: 22),
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 80) {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
            child: SingleChildScrollView(
                child: Stack(
              children: [
                Column(
                  children: [
                    /*
                    
                    This section is the actual AppBar.
                    
                    */
                    HomeAppBarWidget(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        children: [
                          /*
                                    
                          The section below contains 3 buttons that
                          can change the content of the cards on the section below
                          this one.
                                    
                          */
                          Padding(
                            padding:
                                EdgeInsets.only(left: 40, right: 40, top: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 14),
                                  child: Text(
                                    "Acompanhe aqui as sua",
                                    style: Styles.bodyText,
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  child: HomeListViewWidget(),
                  left: 0,
                  right: 0,
                  top: 135,
                )
              ],
            )
          
                /*
          
                  This section contains a ListView with two containers
                  that we can scroll and will direct somewhere
          
                  */
                ),
          ),
        ));
  }
}
