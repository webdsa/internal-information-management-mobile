import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import 'package:internalinformationmanagement/widgets/custom_modal.dart';

class LastUpdatesButtonsWidgets extends StatefulWidget {
  const LastUpdatesButtonsWidgets({super.key});

  @override
  State<LastUpdatesButtonsWidgets> createState() =>
      _LastUpdatesButtonsWidgetsState();
}

class _LastUpdatesButtonsWidgetsState extends State<LastUpdatesButtonsWidgets> {
  int _selectedButton = 0;

  void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomModal();
        });
  }

  void _setSelectedButton(int index) {
    setState(() {
      _selectedButton = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          /*
                              
          Todos Button
                              
          */
          Container(
            height: 24,
            child: ElevatedButton(
              onPressed: () {
                _setSelectedButton(0);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedButton == 0
                      ? MainColors.primary02
                      : ShadeColors.shadeNormalHover.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(
                          width: 0.5,
                          color: _selectedButton == 0
                              ? Theme.of(context).primaryColor
                              : Colors.white.withOpacity(0.9)))),
              child: Text(
                "Todos",
                style: AppTextStyles.caption2.merge(TextStyle(
                    color: _selectedButton == 0
                        ? Theme.of(context).primaryColor
                        : Colors.white.withOpacity(0.9))),
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          /*
                              
          Manual Button
                              
          */
          Container(
            height: 24,
            child: ElevatedButton.icon(
              onPressed: () {
                _showAlertDialog(context);
                //_setSelectedButton(1);
              },
              icon: SvgPicture.asset(
                'assets/svgs/assignment_ind.svg',
                color: _selectedButton == 1
                    ? MainColors.primary01
                    : Colors.white.withOpacity(0.9),
                height: 14,
              ),
              label: Text(
                "Manual",
                style: AppTextStyles.caption2.merge(TextStyle(
                    color: _selectedButton == 1
                        ? MainColors.primary01
                        : Colors.white.withOpacity(0.9))),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedButton == 1
                      ? MainColors.primary02
                      : ShadeColors.shadeNormalHover.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(
                          width: 0.5,
                          color: _selectedButton == 1
                              ? Theme.of(context).primaryColor
                              : const Color(0xFFDEDDE4)))),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          /*
                              
                              
          Patrimônio Button
      
          */
          Container(
            height: 24,
            child: ElevatedButton.icon(
              onPressed: () {
                _showAlertDialog(context);
                //_setSelectedButton(2);
              },
              icon: SvgPicture.asset(
                'assets/svgs/holiday_village.svg',
                color: _selectedButton == 2
                    ? MainColors.primary01
                    : Colors.white.withOpacity(0.9),
                height: 14,
              ),
              label: Text(
                "Patrimônio",
                style: AppTextStyles.caption2.merge(TextStyle(
                    color: _selectedButton == 2
                        ? Theme.of(context).primaryColor
                        : Colors.white.withOpacity(0.9))),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedButton == 2
                      ? MainColors.primary02
                      : ShadeColors.shadeNormalHover.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(
                          width: 0.5,
                          color: _selectedButton == 2
                              ? Theme.of(context).primaryColor
                              : const Color(0xFFDEDDE4)))),
            ),
          ),
        ],
      ),
    );
  }
}
