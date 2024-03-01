import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/util/Styles.dart';

class LastUpdatesButtonsWidgets extends StatefulWidget {
  const LastUpdatesButtonsWidgets({super.key});

  @override
  State<LastUpdatesButtonsWidgets> createState() =>
      _LastUpdatesButtonsWidgetsState();
}

class _LastUpdatesButtonsWidgetsState extends State<LastUpdatesButtonsWidgets> {
  int _selectedButton = 0;

  void _setSelectedButton(int index) {
    setState(() {
      _selectedButton = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /*
                              
                                  Todos Button
                              
                                  */
          Container(
            height: 30,
            child: ElevatedButton(
              onPressed: () {
                _setSelectedButton(0);
              },
              child: Text(
                "Todos",
                style: Styles.bodySmall.merge(TextStyle(
                    color: _selectedButton == 0
                        ? Theme.of(context).primaryColor
                        : Color(0xFFDEDDE4))),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedButton == 0
                      ? Color(0xFFE6F4FF)
                      : Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(
                          width: 1,
                          color: _selectedButton == 0
                              ? Theme.of(context).primaryColor
                              : Color(0xFFDEDDE4)))),
            ),
          ),
          /*
                              
                                  Manual Button
                              
                                  */
          Container(
            height: 30,
            child: ElevatedButton.icon(
              onPressed: () {
                _setSelectedButton(1);
              },
              icon: Icon(
                Icons.assignment_ind_outlined,
                color: _selectedButton == 1
                    ? Theme.of(context).primaryColor
                    : Color(0xFFDEDDE4),
              ),
              label: Text(
                "Manual",
                style: Styles.bodySmall.merge(TextStyle(
                    color: _selectedButton == 1
                        ? Theme.of(context).primaryColor
                        : Color(0xFFDEDDE4))),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedButton == 1
                      ? Color(0xFFE6F4FF)
                      : Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(
                          width: 1,
                          color: _selectedButton == 1
                              ? Theme.of(context).primaryColor
                              : Color(0xFFDEDDE4)))),
            ),
          ),
          /*
                              
                              
                                  Patrimônio Button
                              
                                  */
          Container(
            height: 30,
            child: ElevatedButton.icon(
              onPressed: () {
                _setSelectedButton(2);
              },
              icon: Icon(
                Icons.holiday_village,
                color: _selectedButton == 2
                    ? Theme.of(context).primaryColor
                    : Color(0xFFDEDDE4),
              ),
              label: Text(
                "Patrimônio",
                style: Styles.bodySmall.merge(TextStyle(
                    color: _selectedButton == 2
                        ? Theme.of(context).primaryColor
                        : Color(0xFFDEDDE4))),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedButton == 2
                      ? Color(0xFFE6F4FF)
                      : Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(
                          width: 1,
                          color: _selectedButton == 2
                              ? Theme.of(context).primaryColor
                              : Color(0xFFDEDDE4)))),
            ),
          ),
        ],
      ),
    );
  }
}
