// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:location/location.dart' as lc;
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/providers/firebase_login_provider.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/services/app_constants.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  const HomeScreen({
    Key? key,
    this.latitude,
    this.longitude,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PanelController panelController;
  late MapController mapController;
  late lc.Location location;
  lc.LocationData? currentUserLocation;
  bool _permission = false;
  bool centered = false;
  bool _mapReady = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController panelTextFieldController = TextEditingController();
  final FocusNode focusScopeNode = FocusNode();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  bool _deepLinkAccess = false;
  late Future<List<SearchHistory>?> _searchHistoryFuture;
  late Future<String> _cachePathFuture;
  Future<String> getPath() async {
    final cacheDirectory = await getTemporaryDirectory();
    return cacheDirectory.path;
  }

  String search = "";

  @override
  void initState() {
    super.initState();
    setStatusBarColor();
    panelController = PanelController();
    mapController = MapController();
    location = lc.Location();
    _searchHistoryFuture = HttpRequestServices().getUserSearchHistory();
    _cachePathFuture = getPath();
    if (widget.latitude != null && widget.longitude != null) {
      _deepLinkAccess = true;
    }
    final webSockerProvider =
        Provider.of<WebSocketProvider>(context, listen: false);
    webSockerProvider.connect("wss://ocpp-test.wevemobility.com/mobile");
  }

  Future<void> showLocationDisclosure() {
    bool locating = false;
    return showDialog(
      context: context,
      barrierDismissible:
          !locating, // Cuando está localizando, no se puede cerrar el modal
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              title: Text(
                locating ? "Obteniendo tu ubicación" : "Acceso a la ubicación",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: locating
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 6,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: LoadingIndicator(
                                indicatorType: Indicator.ballPulseSync,
                                colors: AppTheme.colorsCollection,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Esto puede tomar unos\nsegundos, por favor espera...",
                          ),
                        ],
                      ),
                    )
                  : const Text(
                      "Weve utilizará tu ubicación mientras estés usando la aplicación. Esto nos permitirá mostrarte en el mapa y trazar rutas hacia los destinos que elijas",
                      textAlign: TextAlign.start,
                    ),
              actions: [
                if (!locating)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          "No permitir",
                          style: TextStyle(
                            color: Colors.red[600],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            locating = true;
                          });
                          Permission.location.request().then(
                            (value) async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool("locationPermissionGranted", true);
                              if (!_deepLinkAccess) {
                                await initLocationService();
                                await moveCameraToUser();
                                context.pop();
                              } else {
                                context.pop();
                              }
                            },
                          );
                        },
                        child: const Text(
                          "Permitir",
                          style: TextStyle(
                            color: AppTheme.weveSkyBlue,
                          ),
                        ),
                      )
                    ],
                  ),
              ],
            );
          },
        );
      },
    );
  }

  bool modifiedMarkers = false;

  void checkLocationPermissions() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool("locationPermissionGranted", true);
      initLocationService();
    }
  }

  initLocationService() async {
    await location.changeSettings(
      accuracy: lc.LocationAccuracy.high,
      interval: 1000,
    );
    lc.LocationData? locationData;
    bool serviceEnabled;
    bool serviceRequestResult;
    try {
      serviceEnabled = await location.serviceEnabled();
      if (serviceEnabled) {
        final prefs = await SharedPreferences.getInstance();
        _permission = true;
        locationData = await location.getLocation();
        currentUserLocation = locationData;
        if (currentUserLocation != null) {
          prefs.setStringList(
            "latLng",
            [
              currentUserLocation!.latitude.toString(),
              currentUserLocation!.longitude.toString()
            ],
          );
        }
        location.onLocationChanged.listen(
          (lc.LocationData result) async {
            prefs.setStringList(
              "latLng",
              [
                result.latitude.toString(),
                result.longitude.toString(),
              ],
            );
            if (mounted) {
              setState(
                () {
                  if (widget.latitude != null && widget.longitude != null) {
                    _deepLinkAccess = true;
                    currentUserLocation = result;
                  }
                  currentUserLocation = result;
                },
              );
            }
          },
        );
      } else {
        serviceRequestResult = await location.requestService();
        if (serviceRequestResult) {
          initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      print(e.toString());
      locationData = null;
    }
  }

  moveCameraToUser() async {
    print("entró?");
    if (_permission) {
      if (!centered) {
        print("acá tamos");
        currentUserLocation = await location.getLocation();
        print("Currloc $currentUserLocation");
        print("entro $currentUserLocation");
        mapController.move(
            LatLng(currentUserLocation!.latitude!,
                currentUserLocation!.longitude!),
            18);
        centered = true;
      }
    }
  }

  TextEditingController overlayController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final firebaseData = Provider.of<FirebaseAuthData>(context, listen: false);
    final markersProvider = Provider.of<MarkersProvider>(context, listen: true);
    final appData = Provider.of<AppData>(context, listen: false);
    if (mounted) {
      if (widget.latitude != null && widget.longitude != null) {}
      if (!markersProvider.markersReady) {
        print("Se volvieron a dibujar los marcadores");
        markersProvider.getMarkers(appData, context);
      }
    }

    if (_mapReady) {
      if (!_scaffoldKey.currentState!.isEndDrawerOpen &&
          !panelController.isPanelOpen &&
          !panelController.isPanelAnimating &&
          ModalRoute.of(context)!.isCurrent) {
        print("opa");
        if (FocusManager.instance.primaryFocus != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      }
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      // drawer: WeveDrawer(
      //   scaffoldKey: _scaffoldKey,
      //   showLocationDisclosure: showLocationDisclosure,
      //   homeContext: context,
      // ),
      body: SafeArea(
        bottom: false,
        top: false,
        child: SlidingUpPanel(
          controller: panelController,
          backdropTapClosesPanel: true,
          backdropEnabled: true,
          parallaxEnabled: true,
          panelBuilder: (sc) => _panel(sc, appData, overlayController),
          maxHeight: MediaQuery.of(context).size.height * .80,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
          body: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              FutureBuilder<String>(
                future: _cachePathFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    String path = snapshot.data!;
                    return FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        onTap: (tapPosition, point) async {
                          if (_permission) {
                            String formattedAddress = "";
                            String province = "";
                            (formattedAddress, province) =
                                await HttpRequestServices().getPlaceInfo(point);
                            markersProvider.markers.add(
                              Marker(
                                rotate: true,
                                height: 50,
                                width: 50,
                                point: point,
                                builder: ((context) => const Icon(Icons.place,
                                    color: Colors.red, size: 50.0)),
                              ),
                            );
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
                                  currentUserLocation!.latitude!,
                                  currentUserLocation!.longitude!,
                                ),
                                mapController: mapController,
                              ),
                            ).then(
                              (value) => setState(() {
                                markersProvider.markers.removeLast();
                              }),
                            );
                          } else {
                            showLocationDisclosure();
                          }
                        },
                        onPositionChanged: (position, hasGesture) {
                          setState(() {
                            centered = false;
                          });
                        },
                        onMapReady: () async {
                          final prefs = await SharedPreferences.getInstance();
                          String? chargerName =
                              prefs.getString("lastPointedCharger");
                          bool? coldStart = prefs.getBool("coldStart");
                          if (!_deepLinkAccess) {
                            if (!await Permission.location.isGranted) {
                              showLocationDisclosure();
                              await moveCameraToUser();
                            }
                            if (await Permission.location.isGranted) {
                              await initLocationService();
                              await moveCameraToUser();
                            }
                            if (coldStart!) {
                              if (chargerName != null) showChargeNotification();
                            }
                          } else {
                            if (!await Permission.location.isGranted) {
                              await showLocationDisclosure();
                              setState(() {});
                            }
                            if (await Permission.location.isGranted) {
                              mapController.move(
                                  LatLng(widget.latitude!, widget.longitude!),
                                  16);
                              _onDeepLinkAccess(
                                  widget.latitude, widget.longitude);
                              _addRedMarker();
                            }
                          }
                          _mapReady = true;
                        },
                        center: const LatLng(-35.2856484, -65.1973575),
                        minZoom: 7,
                        maxZoom: 20,
                        zoom: 5,
                      ),
                      children: [
                        TileLayer(
                          tileProvider: CachedTileProvider(
                            maxStale: const Duration(days: 15),
                            store: HiveCacheStore(
                              path,
                              hiveBoxName: "HiveCacheStore",
                            ),
                          ),
                          urlTemplate:
                              "https://api.mapbox.com/styles/v1/vulleticev/cl74ss40u000014lbjp1udy3d/tiles/256/{z}/{x}/{y}@2x?access_token=${AppConstants.mapboxAccessToken}",
                          additionalOptions: const {
                            "accessToken": AppConstants.mapboxAccessToken,
                            "id":
                                "mapbox://styles/vulleticev/cl74ss40u000014lbjp1udy3d",
                          },
                        ),
                        if (_mapReady)
                          CircleLayer(
                            circles: [
                              CircleMarker(
                                point: LatLng(
                                  currentUserLocation?.latitude ?? 0,
                                  currentUserLocation?.longitude ?? 0,
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
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              Visibility(
                visible: !appData.searching,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 48, 16, 36),
                  child: Column(
                    children: [
                      FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        heroTag: null,
                        child: const Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (currentUserLocation != null)
                        FloatingActionButton(
                          backgroundColor: Colors.white,
                          onPressed: () => showModalBottomSheet(
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
                              userlocation: LatLng(
                                currentUserLocation!.latitude!,
                                currentUserLocation!.longitude!,
                              ),
                            ),
                          ),
                          heroTag: null,
                          child: const Icon(
                            Symbols.explore_nearby,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !appData.searching,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 110),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: () =>
                                context.push("/filters").then((value) {
                              setState(() {
                                print("Setteando el state padre");
                                markersProvider.markers = [];
                                markersProvider.markersReady = false;
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
                      const SizedBox(
                        height: 10,
                      ),
                      FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () {
                          if (!_permission) {
                            showLocationDisclosure().then((value) {
                              if (_permission) {
                                context.push("/search");
                              }
                            });
                            if (_permission) {
                              context.push("/search");
                            }
                          } else {
                            context.push("/search");
                          }
                        },
                        heroTag: null,
                        child: const FaIcon(
                          FontAwesomeIcons.route,
                          size: 18,
                          color: AppTheme.wevePrimaryBlue,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          if (await Permission.location.isGranted) {
                            mapController.move(
                              LatLng(
                                currentUserLocation!.latitude!,
                                currentUserLocation!.longitude!,
                              ),
                              18,
                            );
                            setState(
                              () {
                                centered = true;
                              },
                            );
                          } else {
                            showLocationDisclosure();
                          }
                        },
                        heroTag: null,
                        child: Icon(
                          getIcon(
                            _permission,
                            centered,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Visibility(
              //   visible: appData.searching,
              //   child: Align(
              //     alignment: Alignment.topCenter,
              //     child: Padding(
              //       padding: EdgeInsets.only(
              //         top: MediaQuery.of(context).size.height * 0.07,
              //         right: 8,
              //         left: 8,
              //       ),
              //       child: Container(
              //         width: MediaQuery.of(context).size.width,
              //         height: 50.0,
              //         decoration: const BoxDecoration(
              //             color: Colors.transparent,
              //             borderRadius: BorderRadius.all(Radius.circular(18))),
              //         child: GooglePlaceAutoCompleteTextField(
              //           textEditingController: overlayController,
              //           googleAPIKey: AppConstants.googleMapsApiKey,
              //           inputDecoration: InputDecoration(
              //             contentPadding:
              //                 const EdgeInsets.symmetric(vertical: 10),
              //             prefixIcon: Padding(
              //               padding: const EdgeInsets.only(left: 6, right: 6),
              //               child: Container(
              //                 alignment: Alignment.center,
              //                 width: 25.0,
              //                 height: 25.0,
              //                 decoration: const BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   color: AppTheme.wevePrimaryBlue,
              //                 ),
              //                 child: IconButton(
              //                   padding: const EdgeInsets.all(0),
              //                   icon: const Icon(
              //                     Icons.arrow_back,
              //                     color: Colors.white,
              //                   ),
              //                   onPressed: () {
              //                     appData.searchSheetContext!.pop();
              //                   },
              //                 ),
              //               ),
              //             ),
              //             suffixIcon: const Padding(
              //               padding: EdgeInsets.all(8.0),
              //               child: Image(
              //                 image: AssetImage(
              //                   "assets/images/logowevesintexto.png",
              //                 ),
              //                 width: 20,
              //                 height: 20,
              //               ),
              //             ),
              //             enabledBorder: OutlineInputBorder(
              //               borderSide: const BorderSide(
              //                 color: Color.fromARGB(255, 236, 236, 236),
              //                 width: 1,
              //               ),
              //               borderRadius: BorderRadius.circular(100),
              //             ),
              //             focusedBorder: OutlineInputBorder(
              //               borderSide: const BorderSide(
              //                 color: Color.fromARGB(255, 236, 236, 236),
              //                 width: 1,
              //               ),
              //               borderRadius: BorderRadius.circular(100),
              //             ),
              //             filled: true,
              //             hintText: "¿A dónde vas?",
              //             hintStyle: const TextStyle(
              //               fontFamily: "Montserrat",
              //               fontWeight: FontWeight.w200,
              //               color: Colors.grey,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _panel(ScrollController sc, AppData appData,
      TextEditingController overlayTextController) {
    final markersProvider =
        Provider.of<MarkersProvider>(context, listen: false);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Column(
        children: [
          const SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 40,
                height: 5,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
              ),
            ],
          ),
          // Flexible(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(
          //       horizontal: 10,
          //       vertical: 16,
          //     ),
          //     child: GooglePlaceAutoCompleteTextField(
          //       onTap: () {
          //         if (panelController.isPanelOpen == false) {
          //           panelController.open();
          //         }
          //       },
          //       textEditingController: overlayTextController,
          //       googleAPIKey: AppConstants.googleMapsApiKey,
          //       debounceTime: 800,
          //       isLatLngRequired: true,
          //       getPlaceDetailWithLatLng: (Prediction prediction) {
          //         mapController.move(
          //           LatLng(
          //             double.parse(prediction.lat!),
          //             double.parse(prediction.lng!),
          //           ),
          //           16,
          //         );
          //         centered = false;

          //         if (modifiedMarkers) {
          //           if (markersProvider.markers.isNotEmpty) {
          //             markersProvider.markers.removeLast();
          //           }
          //           markersProvider.markers.add(
          //             Marker(
          //               rotate: true,
          //               height: 50,
          //               width: 50,
          //               point: LatLng(
          //                 double.parse(prediction.lat!),
          //                 double.parse(prediction.lng!),
          //               ),
          //               builder: ((context) => const Icon(Icons.place,
          //                   color: Colors.red, size: 50.0)),
          //             ),
          //           );
          //         } else {
          //           markersProvider.markers.add(
          //             Marker(
          //               rotate: true,
          //               height: 50,
          //               width: 50,
          //               point: LatLng(
          //                 double.parse(prediction.lat!),
          //                 double.parse(prediction.lng!),
          //               ),
          //               builder: ((context) => const Icon(
          //                     Icons.place,
          //                     color: Colors.red,
          //                     size: 50.0,
          //                   )),
          //             ),
          //           );
          //         }
          //         _onSearch(
          //           prediction,
          //           currentUserLocation?.latitude == null
          //               ? 0
          //               : currentUserLocation!.latitude,
          //           currentUserLocation?.longitude == null
          //               ? 0
          //               : currentUserLocation!.longitude,
          //           prediction.lat!,
          //           prediction.lng!,
          //           appData,
          //           markersProvider,
          //         );
          //         // HttpRequestServices().addToSearchHistory(
          //         //   prediction,
          //         //   prediction.description!,
          //         //   double.parse(prediction.lat!),
          //         //   double.parse(prediction.lng!),
          //         // );
          //         _searchHistoryFuture =
          //             HttpRequestServices().getUserSearchHistory();
          //         modifiedMarkers = true;
          //         FocusScope.of(context).unfocus();
          //       },
          //       itmClick: (Prediction prediction) {
          //         FocusScopeNode currentFocus = FocusScope.of(context);
          //         if (!currentFocus.hasPrimaryFocus) {
          //           currentFocus.unfocus();
          //         }
          //         overlayTextController.text = prediction.description!;
          //         overlayTextController.selection = TextSelection.fromPosition(
          //           TextPosition(
          //             offset: prediction.description!.length,
          //           ),
          //         );
          //         panelController.close();
          //       },
          //       inputDecoration: InputDecoration(
          //         prefixIcon: const Padding(
          //           padding: EdgeInsets.all(6.0),
          //           child: Image(
          //             image: AssetImage("assets/images/logowevesintexto.png"),
          //             width: 20,
          //             height: 20,
          //           ),
          //         ),
          //         suffixIcon: const Icon(Icons.search),
          //         enabledBorder: OutlineInputBorder(
          //           borderSide: const BorderSide(
          //               color: Color.fromARGB(255, 236, 236, 236), width: 1),
          //           borderRadius: BorderRadius.circular(100),
          //         ),
          //         focusedBorder: OutlineInputBorder(
          //           borderSide: const BorderSide(
          //               color: Color.fromARGB(255, 236, 236, 236), width: 1),
          //           borderRadius: BorderRadius.circular(100),
          //         ),
          //         filled: false,
          //         hintText: "¿A dónde vas?",
          //         hintStyle: const TextStyle(
          //           fontFamily: "Montserrat",
          //           fontWeight: FontWeight.w200,
          //           color: Colors.grey,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(100, 157, 157, 157),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.route,
                      size: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
                  child: TextButton(
                    onPressed: () {
                      context.push("/search");
                    },
                    child: const Text(
                      "Trazar una ruta A - B",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              controller: sc,
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<SearchHistory>?>(
                  future: _searchHistoryFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data == null) {
                        return const Center(
                          child: Text("Aún no realizaste búsquedas"),
                        );
                      } else {
                        List<SearchHistory> searchHistory = snapshot.data!;
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 24),
                                child: SearchTitle(text: "Búsquedas recientes"),
                              ),
                              ListView(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                children: List.generate(searchHistory.length,
                                    (index) {
                                  SearchHistory element = searchHistory[index];
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          panelController.close();
                                          mapController.move(
                                            LatLng(element.latitude,
                                                element.longitude),
                                            14,
                                          );

                                          FocusScopeNode currentFocus =
                                              FocusScope.of(context);
                                          if (!currentFocus.hasPrimaryFocus &&
                                              currentFocus.focusedChild !=
                                                  null) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          }

                                          _addRedMarker(element.latitude,
                                              element.longitude);
                                          _onSearch(
                                            element.prediction!,
                                            currentUserLocation!.latitude,
                                            currentUserLocation!.longitude,
                                            element.latitude.toString(),
                                            element.longitude.toString(),
                                            appData,
                                            markersProvider,
                                          );
                                          overlayTextController.text =
                                              element.title;
                                        },
                                        child: SearchHistoryElement(
                                          updateParent: () {},
                                          origin: "Panel",
                                          destinationController:
                                              overlayTextController,
                                          searchHistoryElement: element,
                                        ),
                                      ),
                                      const Divider(),
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ),
                        );
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          "Error recuperando tu historial de búsqueda!",
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "No realizaste ninguna búsqueda todavía!",
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.push("/filters").then((value) {
              setState(() {
                print("Setteando el state padre");
                markersProvider.markers = [];
                markersProvider.markersReady = false;
              });
            }),
            child: const Text(
              "Ver filtros",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  setStatusBarColor() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark));
      }
    });
  }

  IconData getIcon(status, centered) {
    if (status) {
      if (!centered) {
        return Icons.location_searching;
      }
      return Icons.my_location;
    } else {
      return Icons.location_disabled;
    }
  }

  void _onDeepLinkAccess(double? searchLat, double? searchLong) async {
    modifiedMarkers = true;
    List<String>? userLocation = List.empty();
    final prefs = await SharedPreferences.getInstance();
    userLocation = prefs.getStringList("latLng");
    String token = prefs.getString("token")!;
    if (userLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Recuperando información de la estación. Por favor espere",
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.wevePrimaryBlue,
          duration: Duration(seconds: 2),
          dismissDirection: DismissDirection.down,
        ),
      );
      await initLocationService();
      userLocation = prefs.getStringList("latLng");
    }
    List<ChargingStation> stationsList =
        await MarkersProvider().getChargingStations(token);
    ChargingStation charger = stationsList.firstWhere((element) =>
        element.latitude == searchLat.toString() &&
        element.longitude == searchLong.toString());

    HttpRequestServices().onStationTapped(context, charger);
  }

  void _onSearch(
      Prediction prediction,
      double? startLat,
      double? startLng,
      String endLat,
      String endLng,
      AppData appData,
      MarkersProvider markersProvider) async {
    print("Prediction: ${jsonEncode(prediction.toJson())}");
    String province = "";
    final structuredFormatting = prediction.structuredFormatting;
    final mainText = structuredFormatting?.mainText;
    final secondaryText = structuredFormatting?.secondaryText;
    if (secondaryText != null) {
      final addressComponents = secondaryText.split(',');
      if (addressComponents.length == 2) {
        province = addressComponents[0].trim();
        province = province.replaceFirst("Province", "");
      } else if (addressComponents.length > 2) {
        province = addressComponents[1].trim();
        province = province.replaceFirst("Province", "");
      }
    }
    appData.searching = true;
    showModalBottomSheet(
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      context: context,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetcontext) {
        appData.searchSheetContext = context;
        return PlaceBottomSheet(
          screenContext: context,
          provinceName: province,
          streetAddress: mainText!,
          userPosition: LatLng(startLat!, startLng!),
          point: LatLng(double.parse(endLat), double.parse(endLng)),
          mapController: mapController,
        );
      },
    ).then(
      (value) {
        setState(
          () {
            appData.searching = false;
            appData.searchSheetContext = null;
            overlayController.clear();
            FocusScope.of(context).unfocus();
            if (markersProvider.markers.isNotEmpty) {
              markersProvider.markers.removeLast();
            }
          },
        );
      },
    );
  }

  void _addRedMarker([double? latitude, double? longitude]) {
    final markersProvider =
        Provider.of<MarkersProvider>(context, listen: false);
    if (modifiedMarkers) {
      markersProvider.markers.removeLast();
      markersProvider.markers.add(
        Marker(
          rotate: true,
          height: 50,
          width: 50,
          point: LatLng(
            latitude ?? widget.latitude!,
            longitude ?? widget.longitude!,
          ),
          builder: ((context) => const Icon(
                Icons.place,
                color: Colors.red,
                size: 50.0,
              )),
        ),
      );
    } else {
      markersProvider.markers.add(
        Marker(
          rotate: true,
          height: 50,
          width: 50,
          point: LatLng(
            latitude ?? widget.latitude!,
            longitude ?? widget.longitude!,
          ),
          builder: ((context) => const Icon(
                Icons.place,
                color: Colors.red,
                size: 50.0,
              )),
        ),
      );
    }
  }

  void showChargeNotification() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("coldStart", false);
    String chargerName = prefs.getString("lastPointedCharger")!;
    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          title: Text(
            "¿Cargaste en $chargerName?",
          ),
          content: const Text(
            "Confirmá si cargaste en esta estación para añadirlo a tu historial!",
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    prefs.remove("lastPointedCharger");
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Descartar",
                    style: TextStyle(
                      color: Colors.red[600],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //llamado a la api para guardar en el historial
                    prefs.remove("lastPointedCharger");
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Confirmar",
                    style: TextStyle(color: AppTheme.weveSkyBlue),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
