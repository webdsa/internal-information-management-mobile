import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import 'package:internalinformationmanagement/widgets/custom_modal.dart';

class HomeListViewWidget extends StatelessWidget {
  const HomeListViewWidget({super.key});

  void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomModal();
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/feed');
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: FoundationColors.foundationPrimaryLightActive,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Column(
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
              )
            ]),
        // Seu primeiro container
      ),
    );
  }
}
