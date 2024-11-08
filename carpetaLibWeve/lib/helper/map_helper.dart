import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapHelper {
  Future<void> animateMapMove(
    MapController mapController,
    LatLng destination,
    double? targetZoom, {
    int durationMs = 1000,
  }) async {
    final start = mapController.center;
    final zoomStart = mapController.zoom;
    targetZoom ??= 15;
    // La cantidad de pasos que tendrá la animación
    const steps = 30;
    final stepDuration = Duration(milliseconds: (durationMs / steps).round());

    for (int i = 1; i <= steps; i++) {
      // Calcula la interpolación entre la posición inicial y la final
      final lat = start.latitude +
          (destination.latitude - start.latitude) * (i / steps);
      final lng = start.longitude +
          (destination.longitude - start.longitude) * (i / steps);
      final zoom = zoomStart + (targetZoom - zoomStart) * (i / steps);

      // Mueve el mapa progresivamente
      mapController.move(LatLng(lat, lng), zoom);
      await Future.delayed(stepDuration); // Espera entre cada paso
    }
  }
}
