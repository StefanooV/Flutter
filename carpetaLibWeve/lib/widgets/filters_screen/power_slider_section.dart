import 'package:flutter/material.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/theme/app_theme.dart';

class PowerSection extends StatefulWidget {
  const PowerSection(
      {super.key, required this.globalInfo, required this.appData});
  final MarkersProvider globalInfo;
  final AppData appData;
  @override
  State<PowerSection> createState() => _PowerSectionState();
}

class _PowerSectionState extends State<PowerSection> {
  @override
  Widget build(BuildContext context) {
    final appData = widget.appData;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        "${widget.globalInfo.values[widget.globalInfo.selectedIndex].toString()} kW ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text:
                          "• ${getChargingType(widget.globalInfo.selectedIndex, widget.globalInfo.chargingTypes)}"),
                ],
              ),
            ),
          ],
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Slider(
            secondaryActiveColor: Colors.grey,
            activeColor: AppTheme.weveSkyBlue,
            value: widget.globalInfo.selectedIndex.toDouble(),
            min: 0,
            max: widget.globalInfo.values.length - 1,
            divisions: widget.globalInfo.values.length - 1,
            onChanged: (double value) {
              setState(
                () {
                  if (!appData.filtering) appData.filtering = true;
                  widget.globalInfo.selectedIndex = value.toInt();
                  appData.filtersRequestBody["power"] = widget
                      .globalInfo.values[widget.globalInfo.selectedIndex]
                      .toInt();
                  print(
                      "Request body: ${appData.filtersRequestBody.toString()}");
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

String? getChargingType(int index, List<String> chargingTypes) {
  if (index == 0) return chargingTypes.first;
  if (index > 0 && index < 3) return chargingTypes[1];
  if (index >= 3 && index < 5) return chargingTypes[2];
  if (index == 5) return chargingTypes.last;
  return null;
}
