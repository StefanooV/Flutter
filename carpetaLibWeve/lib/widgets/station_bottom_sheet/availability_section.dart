import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/widgets.dart';

class Availability extends StatelessWidget {
  const Availability({super.key, required this.chargerAvailability});

  final List<AvailabilityOnTheDay> chargerAvailability;

  @override
  Widget build(BuildContext context) {
    if (chargerAvailability.isEmpty) {
      return const InformationSectionText(
          title: "El cargador no se encuentra disponible actualmente\n");
    }
    return ExpandableNotifier(
      child: ScrollOnExpand(
        scrollOnExpand: true,
        scrollOnCollapse: true,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Horarios: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expandable(
                  collapsed: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      1,
                      (index) {
                        var availabilityDay = chargerAvailability[0];
                        return Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: availabilityDay.day,
                              ),
                              if (availabilityDay.allDay)
                                const TextSpan(
                                    text: " • Disponible todo el día"),
                              if (!availabilityDay.allDay)
                                ...availabilityDay.availabilityHours.map(
                                  (e) => TextSpan(
                                    text: "• ${e.init} / ${e.end}",
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  expanded: chargerAvailability.length > 1
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                            chargerAvailability.length,
                            (index) {
                              var availabilityDay = chargerAvailability[index];
                              return Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: availabilityDay.day,
                                    ),
                                    if (availabilityDay.allDay)
                                      const TextSpan(
                                          text: " • Disponible todo el día"),
                                    if (!availabilityDay.allDay)
                                      ...availabilityDay.availabilityHours.map(
                                        (e) => TextSpan(
                                          text: "• ${e.init} / ${e.end}",
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
            chargerAvailability.length > 1
                ? Builder(
                    builder: (context) {
                      var controller =
                          ExpandableController.of(context, required: true)!;
                      return TextButton(
                        child: Text(
                          controller.expanded
                              ? "Ver menos horarios"
                              : "Ver todos los horarios",
                          style: const TextStyle(
                              color: AppTheme.wevePrimaryBlue,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          controller.toggle();
                        },
                      );
                    },
                  )
                : const TextButton(
                    onPressed: null,
                    child: Text("Ver todos los horarios"),
                  ),
          ],
        ),
      ),
    );
  }
}
