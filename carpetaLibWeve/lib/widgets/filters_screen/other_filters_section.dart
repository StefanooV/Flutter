import 'package:flutter/cupertino.dart';
import 'package:weveapp/providers/switches_provider.dart';
import 'package:weveapp/theme/app_theme.dart';

class OtherFiltersSection extends StatefulWidget {
  const OtherFiltersSection({super.key, required this.appData});
  final AppData appData;

  @override
  State<OtherFiltersSection> createState() => _OtherFiltersSectionState();
}

class _OtherFiltersSectionState extends State<OtherFiltersSection> {
  List<String> otherFiltersDescriptions = [
    "Sólo puntos de recarga gratuitos",
    "Sólo puntos de recarga 24/7",
    "Solo ruta o autopistas",
  ];
  Map<String, String> filtersReference = {
    "Sólo puntos de recarga gratuitos": "hidePaidChargers",
    "Sólo puntos de recarga 24/7": "onlyAllDay",
    "Solo ruta o autopistas": "isFreeWay"
  };
  @override
  Widget build(BuildContext context) {
    final appData = widget.appData;

    return Column(
      children: List.generate(
        otherFiltersDescriptions.length,
        (index) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Text(
                otherFiltersDescriptions[index],
              ),
            ),
            CupertinoSwitch(
              value: appData.filtersRequestBody[
                      filtersReference[otherFiltersDescriptions[index]]] ??
                  false,
              onChanged: (value) => setState(
                () {
                  if (!appData.filtering) appData.filtering = true;
                  if (appData.filtersRequestBody[
                          filtersReference[otherFiltersDescriptions[index]]] ==
                      null) {
                    appData.filtersRequestBody[filtersReference[
                        otherFiltersDescriptions[index]]!] = true;
                  } else {
                    appData.filtersRequestBody[filtersReference[
                        otherFiltersDescriptions[index]]!] = null;
                  }
                  print("Request body: ${appData.filtersRequestBody}");
                },
              ),
              activeColor: AppTheme.weveSkyBlue,
            )
          ],
        ),
      ),
    );
  }
}
