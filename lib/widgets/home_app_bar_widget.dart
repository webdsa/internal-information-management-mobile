import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:internalinformationmanagement/util/Styles.dart';

class HomeAppBarWidget extends StatelessWidget {
  const HomeAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: EdgeInsets.only(top: 14, left: 40),
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: "Olá ",
                      style: Styles.headline3
                          .merge(TextStyle(color: Color(0xFFFFFFFF)))),
                  TextSpan(
                      text: "Amanda",
                      style: Styles.headline3
                          .merge(TextStyle(color: OtherColors.otherYellow1))),
                  TextSpan(
                      text: ",",
                      style: Styles.headline3
                          .merge(TextStyle(color: Color(0xFFFFFFFF))))
                ])),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.menu,
                  size: 40,
                  color: Color(0xFFFFFFFF),
                ),
              )
            ]),
            Padding(
              padding: EdgeInsets.only(left: 40),
              child: Text(
                "O que deseja ver hoje?",
                style: Styles.titleSmall
                    .merge(TextStyle(color: Color(0xFFFFFFFF))),
              ),
            )
          ],
        ),
      )),
    );
  }
}
