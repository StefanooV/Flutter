import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/widgets.dart';

class PlaceBottomSheet extends StatefulWidget {
  final BuildContext screenContext;
  final String provinceName;
  final String streetAddress;
  final LatLng point;
  final LatLng userPosition;
  final MapController mapController;
  const PlaceBottomSheet({
    super.key,
    required this.screenContext,
    required this.provinceName,
    required this.streetAddress,
    required this.userPosition,
    required this.point,
    required this.mapController,
  });

  @override
  State<PlaceBottomSheet> createState() => _PlaceBottomSheetState();
}

class _PlaceBottomSheetState extends State<PlaceBottomSheet> {
  late Future<double?> _drivingTimeFuture;
  late Future<int> _nearStationsFuture;

  @override
  void initState() {
    super.initState();
    _drivingTimeFuture = HttpRequestServices().getDrivingTime(
      widget.userPosition.latitude,
      widget.userPosition.longitude,
      widget.point.latitude,
      widget.point.longitude,
    );
    _nearStationsFuture =
        MarkersProvider().getNearbyStationsCount(widget.point, context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.streetAddress != "")
                  Expanded(
                    child: Text(
                      widget.streetAddress,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ElevatedButton(
                  onPressed: () => context.push("/filters"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.wevePrimaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(8),
                      )),
                  child: const Text(
                    'Ver filtros',
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                FutureBuilder<double?>(
                  future: _drivingTimeFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Obteniendo tiempo de conducción...");
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasData) {
                        if (snapshot.data != null) {
                          double drivingTime = snapshot.data!;
                          if (drivingTime >= 60) {
                            drivingTime = drivingTime / 60;
                            return Text(
                              "${widget.provinceName} - ${drivingTime.toStringAsFixed(0)} hs",
                              style: TextStyle(color: Colors.grey[700]),
                            );
                          } else {
                            return Text(
                              "${widget.provinceName} - ${drivingTime.toStringAsFixed(0)} min",
                              style: TextStyle(color: Colors.grey[700]),
                            );
                          }
                        } else {
                          return Text(
                            "No se pudo obtener tu tiempo de conducción.",
                            style: TextStyle(color: Colors.grey[700]),
                          );
                        }
                      } else {
                        return Text(
                          "No se pudo obtener tu tiempo de conducción.",
                          style: TextStyle(color: Colors.grey[700]),
                        );
                      }
                    } else {
                      return Text(
                        "No se pudo obtener tu tiempo de conducción.",
                        style: TextStyle(color: Colors.grey[700]),
                      );
                    }
                  },
                ),
                const SizedBox(
                  width: 12,
                ),
                FaIcon(
                  FontAwesomeIcons.car,
                  size: 14,
                  color: Colors.grey[700],
                ),
              ],
            ),
            const SizedBox(
              height: 18,
            ),
            Row(
              children: [
                const Icon(
                  Icons.ev_station,
                ),
                const SizedBox(
                  width: 8,
                ),
                FutureBuilder<int>(
                  future: _nearStationsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text(
                        "${snapshot.data} estaciones cercanas",
                        style: const TextStyle(fontSize: 16),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GoToPlaceButton(
                  point: widget.point,
                  userPosition: widget.userPosition,
                ),
                NearStationButton(
                  userPosition: widget.point,
                  mapController: widget.mapController,
                  screenContext: widget.screenContext,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
