import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/shimmer_container.dart';

class NearStationCard extends StatefulWidget {
  final ChargingStation station;
  final String distance;
  final MapController mapController;
  final BuildContext context;
  final BuildContext? sheetContext;
  const NearStationCard({
    super.key,
    required this.station,
    required this.distance,
    required this.mapController,
    required this.context,
    this.sheetContext,
  });

  @override
  State<NearStationCard> createState() => _NearStationCardState();
}

class _NearStationCardState extends State<NearStationCard> {
  List<StationConnector> connectors = [];
  @override
  void initState() {
    super.initState();
    connectors = widget.station.getConnectorsSummary();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.sheetContext != null) widget.sheetContext!.pop();
        context.pop();
        widget.mapController.move(
          LatLng(
            double.parse(widget.station.latitude),
            double.parse(
              widget.station.longitude,
            ),
          ),
          18,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Colors.grey.shade400,
          ),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.station.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Chip(
                    backgroundColor: AppTheme.wevePrimaryBlue,
                    label: Row(
                      children: [
                        const Icon(
                          Icons.turn_slight_right_outlined,
                          color: Colors.white,
                        ),
                        Text(
                          "${widget.distance} km",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.station.isAllDay)
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Abierto 24/7",
                        style: TextStyle(
                          color: AppTheme.availableGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.station.isAllDay)
                const SizedBox(
                  height: 6,
                ),
              const SizedBox(
                height: 6,
              ),
              SizedBox(
                height: 60,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    connectors.length,
                    (index) {
                      return Row(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://media.wevemobility.com/charger-connector-type-images/${connectors[index].id}.png",
                              progressIndicatorBuilder:
                                  (context, url, progress) {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: ShimmerContainer(
                                    height: 50,
                                    width: 50,
                                  ),
                                );
                              },
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "${connectors[index].power}kW\n",
                                ),
                                TextSpan(
                                  text: "${connectors[index].total}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "/${connectors[index].total}",
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
