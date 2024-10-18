import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:internalinformationmanagement/util/Styles.dart';

class CustomModal extends StatelessWidget {
  const CustomModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  children: [
                    Align(alignment: Alignment.topRight, child: IconButton(icon: Icon(Icons.close,),onPressed: () => Navigator.pop(context),),),
                    Text(
              "Ops!",
              textAlign: TextAlign.center,
              style: AppTextStyles.boldTitle3
                  .merge(TextStyle(color: MainColors.primary03)),
            ),
                    SvgPicture.asset("assets/svgs/workingOn.svg"),
                    Text(
                      "Ainda estamos trabalhando nisso... Em breve estará disponível para você!",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption2,
                    ),
                  ],
                ),
              ),
      );
  }
}