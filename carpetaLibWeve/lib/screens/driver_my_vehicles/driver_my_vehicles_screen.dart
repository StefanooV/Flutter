import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:weveapp/widgets/widgets.dart';

class DriverMyVehiclesScreen extends StatefulWidget {
  const DriverMyVehiclesScreen({Key? key}) : super(key: key);

  @override
  State<DriverMyVehiclesScreen> createState() => _DriverMyVehiclesScreenState();
}

class _DriverMyVehiclesScreenState extends State<DriverMyVehiclesScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Mis Vehículos",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 20),
        child: VehicleCard(),
      ),
    );
  }
}
