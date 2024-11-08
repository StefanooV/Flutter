import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:weveapp/widgets/near_station_bottom_sheet.dart';

class NearStationButton extends StatelessWidget {
  final LatLng userPosition;
  final MapController mapController;
  final BuildContext screenContext;
  const NearStationButton(
      {super.key,
      required this.userPosition,
      required this.mapController,
      required this.screenContext});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: () async {
            showModalBottomSheet(
              isDismissible: false,
              isScrollControlled: true,
              enableDrag: false,
              useSafeArea: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              context: context,
              builder: (context) => NearStationBottomSheet(
                mapController: mapController,
                userlocation: userPosition,
                screenContext: screenContext,
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10),
          ),
          child: const Center(
            child: Icon(
              Icons.info,
              color: Color.fromARGB(255, 40, 40, 40),
              size: 24,
            ),
          ),
        ),
        const Text(
          "Ver estaciones\ncercanas",
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
