import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:latlong2/latlong.dart';
import 'package:weveapp/widgets/widgets.dart';

class NearStationBottomSheet extends StatefulWidget {
  final LatLng userlocation;
  final MapController mapController;
  final BuildContext? screenContext;

  const NearStationBottomSheet(
      {super.key,
      required this.userlocation,
      required this.mapController,
      this.screenContext});

  @override
  State<NearStationBottomSheet> createState() => _NearStationBottomSheetState();
}

class _NearStationBottomSheetState extends State<NearStationBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.95,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 14,
              right: 14,
              top: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.screenContext == null
                  ? "Estaciones cerca tuyo"
                  : "Estaciones cercanas",
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<(List<ChargingStation>, Map<String, String>)>(
            future: MarkersProvider()
                .getNearbyStations(widget.userlocation, context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<ChargingStation> nearbyStations = List.empty();
                  Map<String, String> distances = {};
                  (nearbyStations, distances) = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: nearbyStations.length,
                      addAutomaticKeepAlives: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: NearStationCard(
                            context: context,
                            mapController: widget.mapController,
                            station: nearbyStations[index],
                            distance: distances[nearbyStations[index].id]!,
                            sheetContext: widget.screenContext,
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Center(
                      child: Text("No hay estaciones cercanas!"),
                    ),
                  );
                }
              } else {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
