import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:internalinformationmanagement/util/Styles.dart';

class HomeDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeDrawer({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20))),
      backgroundColor: Theme.of(context).primaryColor,
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
                                .merge(TextStyle(color: Colors.white))),
                        Text(
                          "Cargo",
                          style: Styles.bodyText
                              .merge(TextStyle(color: Colors.white)),
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
                      leading: Icon(
                        Icons.settings_outlined,
                        color: Colors.white,
                      ),
                      title: Text('Configurações',
                          style: Styles.titleMedium
                              .merge(TextStyle(color: TextColors.text6))),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.account_circle_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      title: Text('Perfil',
                          style: Styles.titleMedium
                              .merge(TextStyle(color: TextColors.text6))),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.data_exploration_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      title: Text('Atividades',
                          style: Styles.titleMedium
                              .merge(TextStyle(color: TextColors.text6))),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.change_circle_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      title: Text('Trocar usuário',
                          style: Styles.titleMedium
                              .merge(TextStyle(color: TextColors.text6))),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.mail_outline_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      title: Text(
                        'Contato RH',
                        style: Styles.titleMedium
                            .merge(TextStyle(color: TextColors.text6)),
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
                Navigator.pop(context);
              },
              leading: Icon(
                Icons.logout_outlined,
                color: Colors.white,
                size: 24,
              ),
              title: Text("Sair da conta",
                  style: Styles.titleMedium
                      .merge(TextStyle(color: TextColors.text6))),
            ),
          )
        ],
      ),
    );
  }
}
