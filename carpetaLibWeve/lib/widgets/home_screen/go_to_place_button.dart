import 'dart:io';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weveapp/theme/app_theme.dart';

class GoToPlaceButton extends StatelessWidget {
  final LatLng point;
  final LatLng userPosition;
  const GoToPlaceButton({
    super.key,
    required this.point,
    required this.userPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: () async {
            if (Platform.isAndroid) {
              final mapsLauncherUrl = Uri.https(
                'www.google.com',
                '/maps/dir/',
                {
                  'api': '1',
                  'origin':
                      '${userPosition.latitude},${userPosition.longitude}',
                  'destination': '${point.latitude},${point.longitude}',
                  'travelmode': 'driving',
                  'units': 'metric',
                },
              );
              try {
                await launchUrl(mapsLauncherUrl,
                    mode: LaunchMode.externalApplication);
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
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
