import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/flavors.dart';
import 'package:internalinformationmanagement/theme/theme.dart';
import 'package:internalinformationmanagement/theme/theme_provider.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import 'package:provider/provider.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen({super.key, required this.title, required this.description, required this.text});

  final String title;
  final String description;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close), iconSize: 35,),
                    ],)
                  ),
                  Padding(padding: EdgeInsets.only(top: 36),
                    child: Text("${title}", style: DesktopTextStyles.headlineH4,
                    textAlign: TextAlign.start,),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 42),
                    child: Text("${description}",
                      style: DesktopTextStyles.subtitle,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 22), 
                    child: Text("${text}",
                      style: AppTextStyles.footnote,
                      textAlign: TextAlign.justify,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}