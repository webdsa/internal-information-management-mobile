import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/theme/theme.dart';
import 'package:internalinformationmanagement/theme/theme_provider.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeDrawer({super.key, required this.scaffoldKey});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', '');
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20))),
      backgroundColor: Provider.of<ThemeProvider>(context).themeData == darkMode
          ? MainColors.primary03
          : MainColors.primary02,
      key: scaffoldKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/imgs/image.png',
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Amanda Gonçalves",
                            style: Styles.titleSmall
                                .merge(TextStyle(color: MainColors.primary03))),
                        Text(
                          "Cargo",
                          style: Styles.bodyText
                              .merge(TextStyle(color: MainColors.primary03)),
                        ),
                      ],
                    ),
                  )
                ],
              )),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 10),
                child: Column(
                  children: [
                    ListTile(
                      leading: SvgPicture.asset(
                        'assets/svgs/settings.svg',
                        color: Colors.white,
                        height: 24,
                      ),
                      title: Text('Configurações',
                          style: Styles.titleMedium
                              .merge(TextStyle(color: MainColors.primary03))),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: SvgPicture.asset(
                        'assets/svgs/account_circle.svg',
                        color: Colors.white,
                        height: 24,
                      ),
                      title: Text('Perfil',
                          style: Styles.titleMedium
                              .merge(TextStyle(color: MainColors.primary03))),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: SvgPicture.asset('assets/svgs/chart_data.svg',
                          height: 24, color: Colors.white),
                      title: Text('Atividades',
                          style: Styles.titleMedium
                              .merge(TextStyle(color: MainColors.primary03))),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: SvgPicture.asset('assets/svgs/rule_settings.svg',
                          height: 24, color: Colors.white),
                      title: Text('Trocar usuário',
                          style: Styles.titleMedium
                              .merge(TextStyle(color: MainColors.primary03))),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: SvgPicture.asset('assets/svgs/mail.svg',
                          height: 22, color: Colors.white),
                      title: Text(
                        'Contato RH',
                        style: Styles.titleMedium
                            .merge(TextStyle(color: MainColors.primary03)),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 30),
            child: ListTile(
              onTap: () {
                _logout(context);
              },
              leading: SvgPicture.asset('assets/svgs/logout.svg',
                  height: 24, color: Colors.white),
              title: Text("Sair da conta",
                  style: Styles.titleMedium
                      .merge(TextStyle(color: MainColors.primary03))),
            ),
          )
        ],
      ),
    );
  }
}
