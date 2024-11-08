// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:weveapp/helper/helpers.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/services/app_constants.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/widgets.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({super.key});

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen>
    with WidgetsBindingObserver {
  late MapController _mapController;
  DraggableScrollableController draggableController =
      DraggableScrollableController();
  final LocationHelper _locationHelper = LocationHelper();
  LatLng _currentPosition = const LatLng(0, 0);
  List<Marker> additionalMarkers = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? _retryTimer;
  bool screenColdStart = true;
  bool centered = false;

  void _moveToLocation(double latitude, double longitude,
      [double? targetZoom]) {
    _mapController.move(LatLng(latitude, longitude), targetZoom ?? 18);
  }

  bool locationSelected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  //- Método para inicializar la ubicación al cargar la pantalla - //
  void _initializeLocation() {
    _locationHelper.initializeLocation(context, (position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // -- Localización -- //

  void _moveCameraToUser() {
    if (screenColdStart == true) {
      if (_currentPosition.latitude != 0 || _currentPosition.longitude != 0) {
        _mapController.move(
            LatLng(_currentPosition.latitude, _currentPosition.longitude), 18);
        _retryTimer
            ?.cancel(); // Si las coordenadas ya son válidas, dejo de reintentar
        screenColdStart = false;
        setState(() {
          centered = true;
        });
      } else {
        // Si las coordenadas son (0,0) quiere decir que aún no localizamos al usuario. Esperamos e intentamos de nuevo
        _retryTimer = Timer(const Duration(seconds: 2), _moveCameraToUser);
      }
    }
  }

// - Método que muestra la información del punto tocado del mapa - //
  Future<void> _showPlaceBottomSheet(BuildContext context, LatLng point) async {
    additionalMarkers.add(
      Marker(
        point: point,
        builder: (context) {
          return const Icon(
            Icons.place,
            color: Colors.red,
            size: 50.0,
          );
        },
      ),
    );
    String formattedAddress = "";
    String province = "";
    (formattedAddress, province) =
        await HttpRequestServices().getPlaceInfo(point);
    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      context: context,
      builder: (sheetContext) => PlaceBottomSheet(
        screenContext: context,
        provinceName: province,
        streetAddress: formattedAddress,
        point: point,
        userPosition: LatLng(
          _currentPosition.latitude,
          _currentPosition.longitude,
        ),
        mapController: _mapController,
      ),
    ).then((value) {
      setState(() {
        additionalMarkers.removeLast();
      });
    });
  }

  // - Método que escucha a los cambios de los viewInsets para levantar el menú. - //

  @override
  void didChangeMetrics() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    if (locationSelected == false) {
      if (bottomInset != 0) {
        // Levantar el menú al aparecer el teclado
        draggableController.animateTo(
          0.8,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _hideSheet() {
    FocusScope.of(context).unfocus();
    draggableController.animateTo(
      0.1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _moveToSelectedLocation(double latitude, double longitude) async {
    setState(() {
      locationSelected = true;
    });
    FocusScope.of(context).unfocus();
    _moveToLocation(latitude, longitude);
    await draggableController.animateTo(
      0.1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _showPlaceBottomSheet(context, LatLng(latitude, longitude));
    setState(() {
      locationSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // -- Usamos provider para ir cambiando los markers de manera dinámica para los filtros -- //
    final markersProvider = Provider.of<MarkersProvider>(context, listen: true);
    final appData = Provider.of<AppData>(context, listen: false);

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: WeveDrawer(
        scaffoldKey: _scaffoldKey,
        homeContext: context,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              onTap: (tapPosition, point) async {
                _hideSheet();
                // Si se toca el mapa se cierra el menú, si ya está cerrado, desplegamos el sheet
                if (draggableController.size == 0.1) {
                  _showPlaceBottomSheet(context, point);
                }
              },
              onPositionChanged: (position, hasGesture) {
                setState(() {
                  centered = false;
                });
              },
              onMapReady: () async {
                _moveCameraToUser();

                markersProvider.getChargingStationMarkers(
                  context,
                ); // Cuando esté listo el mapa, se traen los marcadores. Mejora rendimiento.
              },
              center: const LatLng(-35.2856484, -65.1973575), //Argentina
              minZoom: 10,
              maxZoom: 18,
              zoom: 10,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/vulleticev/cl74ss40u000014lbjp1udy3d/tiles/256/{z}/{x}/{y}@2x?access_token=${AppConstants.mapboxAccessToken}",
                additionalOptions: const {
                  "accessToken": AppConstants.mapboxAccessToken,
                  "id": "mapbox://styles/vulleticev/cl74ss40u000014lbjp1udy3d",
                },
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: LatLng(
                      _currentPosition.latitude,
                      _currentPosition.longitude,
                    ),
                    color: AppTheme.wevePrimaryBlue,
                    borderColor: AppTheme.weveSkyBlue,
                    borderStrokeWidth: 2.5,
                    radius: 10.0,
                    useRadiusInMeter: false,
                  ),
                ],
              ),
              MarkerLayer(
                markers: markersProvider.markers,
              ),
              MarkerLayer(
                markers: additionalMarkers,
              ),
            ],
          ),
          Positioned(
            right: 16.0,
            top: 40,
            bottom: 100,
            child: SizedBox(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        heroTag: null,
                        child: const Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () async {
                          if (await _locationHelper.getPermissionStatus()) {
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
                                mapController: _mapController,
                                userlocation: LatLng(
                                  _currentPosition.latitude,
                                  _currentPosition.longitude,
                                ),
                              ),
                            );
                          } else {
                            _initializeLocation();
                          }
                        },
                        heroTag: null,
                        child: const Icon(
                          Symbols.explore_nearby,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: () =>
                                context.push("/filters").then((value) {
                              setState(() {
                                markersProvider.markersReady = false;
                                markersProvider.markers = [];
                                markersProvider
                                    .getChargingStationMarkers(context);
                              });
                            }),
                            heroTag: null,
                            child: const Icon(
                              Icons.tune,
                              color: AppTheme.wevePrimaryBlue,
                            ),
                          ),
                          if (appData.filtering)
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 10,
                                bottom: 10,
                              ),
                              child: StrokeText(
                                text: appData.totalFilters.toString(),
                                textStyle: const TextStyle(
                                  color: Color.fromARGB(255, 6, 84, 118),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                strokeColor: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () {
                          context.push("/search");
                        },
                        heroTag: null,
                        child: const FaIcon(
                          FontAwesomeIcons.route,
                          size: 18,
                          color: AppTheme.wevePrimaryBlue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton(
                        onPressed: () async {
                          // Obtén el estado del permiso
                          bool permission =
                              await _locationHelper.getPermissionStatus();

                          // Verifica si el permiso fue concedido o está limitado
                          if (permission) {
                            // Mueve el mapa a la posición actual
                            _mapController.move(
                              LatLng(
                                _currentPosition.latitude,
                                _currentPosition.longitude,
                              ),
                              18,
                            );
                            // Actualiza el estado de la UI
                            setState(() {
                              centered = true;
                            });
                          } else {
                            _initializeLocation();
                          }
                        },
                        heroTag: null,
                        child: Icon(
                          centered
                              ? Icons.my_location
                              : Icons.location_searching_outlined,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          MapBottomSheet(
            onLocationSelected: _moveToSelectedLocation,
            draggableController: draggableController,
          ),
        ],
      ),
    );
  }
}
