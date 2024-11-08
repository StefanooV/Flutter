// ignore_for_file: use_build_context_synchronously
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:weveapp/models/driver_vehicle_model.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/add_car_bottom_sheet/add_car_bottom_sheet.dart';
import '../services/http_request_service.dart';

class VehicleCard extends StatefulWidget {
  const VehicleCard({
    Key? key,
  }) : super(key: key);

  @override
  State<VehicleCard> createState() => _VehicleCardState();
}

class _VehicleCardState extends State<VehicleCard> {
  late Future<List<DriverVehicle>?> _getDriverVehiclesFuture;
  @override
  void initState() {
    super.initState();
    _getDriverVehiclesFuture = HttpRequestServices().getDriverVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DriverVehicle>?>(
      future: _getDriverVehiclesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print("Lada ta ${snapshot.data}");
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox.shrink(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: NetworkImage(
                          HttpRequestServices().getFillerImageUrl("MyVehicles"),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Todavía no has agregado ningún vehículo",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w200,
                            fontFamily: "Montserrat",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Text(
                          "Añadir vehículo",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      onPressed: () {
                        double desiredHeight = 400;
                        double screenHeight =
                            MediaQuery.of(context).size.height;
                        double multiplier = desiredHeight / screenHeight;
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
                          builder: (sheetContext) => AddCarBottomSheet(
                            multiplier: multiplier,
                            sheetContext: sheetContext,
                            isRegistering: false,
                          ),
                        ).then(
                          (value) => setState(() {
                            _getDriverVehiclesFuture =
                                HttpRequestServices().getDriverVehicles();
                          }),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            if (snapshot.data!.isNotEmpty) {
              List<DriverVehicle> vehiclesList = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: List.generate(
                        vehiclesList.length,
                        (index) => Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                        title: const Text(
                                          "Eliminar vehiculo",
                                        ),
                                        content: Text(
                                          "Se eliminará ${vehiclesList[index].vehicleBrandDescription} ${vehiclesList[index].vehicleModelDescription} permanentemente!",
                                        ),
                                        actions: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                    "Cancelar",
                                                    style: TextStyle(
                                                        color: AppTheme
                                                            .weveSkyBlue),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await HttpRequestServices()
                                                        .deleteUserVehicle(
                                                            vehiclesList[index]
                                                                .id);
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            "${vehiclesList[index].vehicleModelDescription} eliminado con éxito"),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        backgroundColor:
                                                            Colors.red[600],
                                                        dismissDirection:
                                                            DismissDirection
                                                                .down,
                                                      ),
                                                    );
                                                    setState(
                                                      () {
                                                        _getDriverVehiclesFuture =
                                                            HttpRequestServices()
                                                                .getDriverVehicles();
                                                      },
                                                    );
                                                  },
                                                  child: Text(
                                                    "Confirmar",
                                                    style: TextStyle(
                                                      color: Colors.red[600],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    icon: const Icon(Icons.delete,
                                        color: Colors.grey, size: 25),
                                  ),
                                ],
                              ),
                              leading: const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: FaIcon(FontAwesomeIcons.car,
                                    color: AppTheme.weveSkyBlue, size: 25),
                              ),
                              title: Text(
                                vehiclesList[index].vehicleBrandDescription,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                vehiclesList[index].vehicleModelDescription,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Text(
                          "Añadir vehículo",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      onPressed: () {
                        double desiredHeight = 400;
                        double screenHeight =
                            MediaQuery.of(context).size.height;
                        double multiplier = desiredHeight / screenHeight;
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
                          builder: (sheetContext) => AddCarBottomSheet(
                            multiplier: multiplier,
                            sheetContext: sheetContext,
                            isRegistering: false,
                          ),
                        ).then(
                          (value) => setState(() {
                            _getDriverVehiclesFuture =
                                HttpRequestServices().getDriverVehicles();
                          }),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(120),
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballPulseSync,
                    colors: AppTheme.colorsCollection,
                  ),
                ),
              );
            }
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage("assets/images/connerr.png"),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Oops!\nAlgo salió mal",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Montserrat",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: AppTheme.weveSkyBlue,
                        width: 1.5,
                      ),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text(
                        "Volver",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.weveSkyBlue,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(120),
              child: LoadingIndicator(
                  indicatorType: Indicator.ballPulseSync,
                  colors: AppTheme.colorsCollection),
            ),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/images/connerr.png"),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Oops!\nAlgo salió mal",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: AppTheme.weveSkyBlue,
                      width: 1.5,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Text(
                      "Volver",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.weveSkyBlue,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

setStatusBarColor() {
  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark));
    }
  });
}
