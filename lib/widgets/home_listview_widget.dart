import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:internalinformationmanagement/util/Styles.dart';

class HomeListViewWidget extends StatelessWidget {
  const HomeListViewWidget({super.key});

  void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Ops!",
              textAlign: TextAlign.center,
              style: AppTextStyles.boldTitle3
                  .merge(TextStyle(color: MainColors.primary03)),
            ),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                height: 150,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(50)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/svgs/workingOn.svg"),
                      Text(
                        "Ainda estamos trabalhando nisso... Em breve estará disponível para você!",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "FECHAR",
                  style: TextStyle(color: MainColors.primary03),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/feed');
          },
          child: Container(
            width: 152,
            padding: EdgeInsets.all(16),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: FoundationColors.foundationPrimaryLightActive,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                      radius: 26,
                      backgroundColor:
                          FoundationColors.foundationPrimaryLightHover,
                      child: SvgPicture.asset(
                        'assets/svgs/assignment_ind.svg',
                        height: 24,
                        color: MainColors.primary01,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manual de",
                          style: AppTextStyles.caption1.merge(
                              const TextStyle(color: MainColors.primary01)),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "Orientações".toUpperCase(),
                          style: DesktopTextStyles.buttonRegular.merge(
                              const TextStyle(
                                  color: FoundationColors
                                      .foundationTertiaryNormal)),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  )
                ]),
            // Seu primeiro container
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            _showAlertDialog(context);
          },
          child: Container(
            width: 152,
            padding: EdgeInsets.all(16),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: FoundationColors.foundationPrimaryLightActive,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                      radius: 26,
                      backgroundColor:
                          FoundationColors.foundationPrimaryLightHover,
                      child: SvgPicture.asset(
                        'assets/svgs/holiday_village.svg',
                        color: MainColors.primary01,
                        height: 24,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sobre meu",
                          style: AppTextStyles.caption1
                              .merge(TextStyle(color: MainColors.primary01)),
                        ),
                        Text(
                          "Patrimônio".toUpperCase(),
                          style: DesktopTextStyles.buttonRegular.merge(
                              const TextStyle(
                                  color: TailwindColors.tailwindAmber500)),
                        )
                      ],
                    ),
                  )
                ]),
            // Seu segundo container
          ),
        ),
      ],
    );
  }
}
