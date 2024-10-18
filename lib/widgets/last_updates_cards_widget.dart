import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import 'package:internalinformationmanagement/widgets/custom_modal.dart';

// ignore: must_be_immutable
class LastUpdatesWidget extends StatefulWidget {
  LastUpdatesWidget({super.key});

  @override
  State<LastUpdatesWidget> createState() => _LastUpdatesWidgetState();
}

class _LastUpdatesWidgetState extends State<LastUpdatesWidget> {
  List<String> months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomModal();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(children: [
        Container(
          color: Colors.transparent,
          width: double.infinity,
          child: Card(
            color: Colors.transparent,
            elevation: 0,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      child: SvgPicture.asset(
                        'assets/svgs/holiday_village.svg',
                        color: MainColors.primary01,
                        height: 14,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Hoje - ${DateTime.now().day} de ${months[DateTime.now().month - 1]}",
                      style: AppTextStyles.caption2
                          .merge(const TextStyle(color: TextColors.text4)),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Agendamento de Serviço".toUpperCase(),
                      textAlign: TextAlign.left,
                      style: DesktopTextStyles.buttonSmall
                          .merge(TextStyle(color: MainColors.primary01)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        "Precisa trocar a cortina? Ou dedetização na sua casa? Agende um serviço!",
                        style: AppTextStyles.caption2,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: 100,
                        height: 24,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: StatusColor.statusOrange1,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                            onPressed: () => _showAlertDialog(context),
                            child: Text(
                              "Agendar",
                              style: AppTextStyles.caption2.merge(
                                  const TextStyle(color: TextColors.text7)),
                            )),
                      ),
                    )
                  ],
                ),
              )
            ]),
          ),
        ),
        /*

                              Card 2

                              */
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                            backgroundColor: Colors.white,
                            child: SvgPicture.asset(
                              'assets/svgs/assignment_ind.svg',
                              color: MainColors.primary01,
                              height: 14,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Hoje - ${DateTime.now().day} de ${months[DateTime.now().month - 1]}",
                            style: AppTextStyles.caption2.merge(
                                const TextStyle(color: TextColors.text4)),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60, top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Agendamento de Serviço".toUpperCase(),
                            textAlign: TextAlign.left,
                            style: DesktopTextStyles.buttonSmall
                                .merge(TextStyle(color: MainColors.primary01)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              "O relatório tem novas atualizações, que tal conferir o que mudou?",
                              style: AppTextStyles.caption2,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              width: 100,
                              height: 24,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: StatusColor.statusGreen1,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)))),
                                  onPressed: () => _showAlertDialog(context),
                                  child: Text(
                                    "Conferir",
                                    style: AppTextStyles.caption2.merge(
                                        const TextStyle(
                                            color: TextColors.text7)),
                                  )),
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ),
        /*

        Card 3

        */
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                            backgroundColor: Colors.white,
                            child: SvgPicture.asset(
                              'assets/svgs/for_you.svg',
                              color: MainColors.primary01,
                              height: 14,
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Hoje - ${DateTime.now().day} de ${months[DateTime.now().month - 1]}",
                            style: AppTextStyles.caption2.merge(
                                const TextStyle(color: TextColors.text4)),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60, top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Boas-vindas".toUpperCase(),
                            textAlign: TextAlign.left,
                            style: DesktopTextStyles.buttonSmall
                                .merge(TextStyle(color: MainColors.primary01)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              "Seja bem-vinda ao nosso aplicativo interno! Com informações atualizadas e disponíveis para você a qualquer momento.",
                              style: AppTextStyles.caption2,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              width: 100,
                              height: 24,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)))),
                                  onPressed: () => _showAlertDialog(context),
                                  child: Text(
                                    "Ver painel",
                                    style: AppTextStyles.caption2.merge(
                                        const TextStyle(
                                            color: TextColors.text7)),
                                  )),
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        )
      ]),
    );
  }
}
