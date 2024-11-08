import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:weveapp/models/models.dart';

class ShareButton extends StatelessWidget {
  final ChargingStation station;
  const ShareButton({
    super.key,
    required this.station,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: () => Share.share(
            "Mira la estación de carga ${station.name}! https://wevemobility.com/station?lat=${station.latitude}&long=${station.longitude}",
          ),
          style: OutlinedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10),
          ),
          child: const Center(
            child: Icon(
              Icons.share,
              color: Color.fromARGB(255, 40, 40, 40),
              size: 24,
            ),
          ),
        ),
        const Text(
          "Compartir\n",
          style: TextStyle(fontFamily: "Montserrat"),
        ),
      ],
    );
  }
}
