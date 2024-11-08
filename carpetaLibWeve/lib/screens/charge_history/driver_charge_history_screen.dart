import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/widgets/widgets.dart';

class DriverChargeHistory extends StatefulWidget {
  const DriverChargeHistory({Key? key}) : super(key: key);

  @override
  State<DriverChargeHistory> createState() => _DriverChargeHistoryState();
}

class _DriverChargeHistoryState extends State<DriverChargeHistory> {
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
          "Mis Cargas",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                HttpRequestServices().getFillerImageUrl("MyCharges"),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Todavía no has realizado ninguna carga.\nCuando lo hagas las verás reflejadas aquí",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
