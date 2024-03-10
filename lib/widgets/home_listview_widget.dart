import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:internalinformationmanagement/util/Styles.dart';

class HomeListViewWidget extends StatelessWidget {
  const HomeListViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: ListView(
        padding: EdgeInsets.only(left: 30, right: 10),
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            width: 200,
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFFFFFFF)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFFFFEAEA),
                    child: SvgPicture.asset(
                      'assets/svgs/assignment_ind.svg',
                      height: 24,
                      color: StatusColor.statusRed1,
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Manual de",
                      style: Styles.bodyText
                          .merge(TextStyle(color: TextColors.text4)),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "Orientações".toUpperCase(),
                      style: Styles.headline4
                          .merge(TextStyle(color: StatusColor.statusRed1)),
                      textAlign: TextAlign.left,
                    )
                  ],
                )
              ])
            ]),
            // Seu primeiro container
          ),
          SizedBox(width: 12),
          Container(
            width: 200,
            margin: EdgeInsets.all(4),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFFFFFFF),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFFFFFBEA),
                    child: SvgPicture.asset(
                      'assets/svgs/holiday_village.svg',
                      color: OtherColors.otherYellow1,
                      height: 24,
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sobre meu",
                      style: Styles.bodyText
                          .merge(TextStyle(color: TextColors.text4)),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "Patrimônio".toUpperCase(),
                      style: Styles.headline4
                          .merge(TextStyle(color: OtherColors.otherYellow1)),
                      textAlign: TextAlign.left,
                    )
                  ],
                )
              ])
            ]),
            // Seu segundo container
          ),
        ],
      ),
    );
  }
}
