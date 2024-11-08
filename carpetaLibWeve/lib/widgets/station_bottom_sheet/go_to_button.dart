// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/services/http_request_service.dart';
import 'package:weveapp/theme/app_theme.dart';

class GotoButton extends StatelessWidget {
  final ChargingStation station;
  const GotoButton({
    super.key,
    required this.station,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.setString("lastPointedCharger", station.name);
            List<String> userLocation = prefs.getStringList("latLng")!;
            HttpRequestServices().registerChargerPointing(station.id);
            if (Platform.isAndroid) {
              final mapsLauncherUrl = Uri.https(
                'www.google.com',
                '/maps/dir/',
                {
                  'api': '1',
                  'origin': '${userLocation[0]},${userLocation[1]}',
                  'destination': '${station.latitude},${station.longitude}',
                  'travelmode': 'driving',
                  'units': 'metric',
                },
              );
              try {
                await launchUrl(mapsLauncherUrl,
                    mode: LaunchMode.externalApplication);
                await HttpRequestServices().registerChargerPointing(station.id);
              } catch (err) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "No pudimos iniciar la navegación, intentalo nuevamente.",
                    ),
                  ),
                );
              }
            }
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: AppTheme.wevePrimaryBlue,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(8),
          ),
          child: const Center(
            child: Icon(
              Icons.directions,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        const Text(
          "Ir\n",
          style: TextStyle(fontFamily: "Montserrat"),
        ),
      ],
    );
  }
}
