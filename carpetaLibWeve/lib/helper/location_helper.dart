// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:weveapp/theme/app_theme.dart';

class LocationHelper {
  final Location _location = Location();
  bool _isListening = false; // Controla si ya se está escuchando
  StreamSubscription<LocationData>? _locationSubscription;

  /// Método para inicializar la ubicación
  Future<void> initializeLocation(
      BuildContext context, Function(LatLng) onLocationUpdate) async {
    // Mostrar el modal antes de pedir permisos

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied ||
        permissionGranted == PermissionStatus.deniedForever) {
      bool proceed = await _showLocationUsageDialog(context, permissionGranted);
      if (!proceed) return; // Si el usuario cancela, no continuamos

      permissionGranted = await _location.requestPermission();
      if (permissionGranted == PermissionStatus.deniedForever) {
        _showDeniedForeverDialog(context);
      }
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _location.changeSettings(accuracy: LocationAccuracy.high);
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    // Obtener ubicación inicial y notificar
    LocationData locationData = await _location.getLocation();
    onLocationUpdate(LatLng(locationData.latitude!, locationData.longitude!));

    // Configurar la escucha solo si no está ya activa
    if (!_isListening) {
      _isListening = true;
      _locationSubscription =
          _location.onLocationChanged.listen((LocationData locationData) {
        onLocationUpdate(
            LatLng(locationData.latitude!, locationData.longitude!));
      });
    }
  }

  Future<LatLng?> getUserLocation(BuildContext context) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Verificar si ya se tienen permisos
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied ||
        permissionGranted == PermissionStatus.deniedForever) {
      // Mostrar el primer diálogo de solicitud de permisos
      bool proceed = await _showLocationUsageDialog(context, permissionGranted);
      if (!proceed) return null;

      // Solicitar permisos nuevamente
      permissionGranted = await _location.requestPermission();

      // Si los permisos siguen denegados para siempre
      if (permissionGranted == PermissionStatus.deniedForever) {
        if (context.mounted) {
          // Solo mostrar el diálogo si el contexto está aún disponible
          _showDeniedForeverDialog(context);
        }
        return null; // Devolver null si no se otorgan permisos
      }
    }

    // Configurar precisión y habilitar servicio de ubicación
    _location.changeSettings(accuracy: LocationAccuracy.high);
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return null; // Devolver null si el servicio no se habilita
      }
    }

    // Obtener ubicación del usuario
    LocationData locationData = await _location.getLocation();
    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  Future<void> _showDeniedForeverDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        title: const Text("Parece que no podemos acceder a tu ubicación..."),
        content: const Text(
            "Para poder permitir a Weve acceder a tu ubicación deberás habilitar los permisos desde las configuraciones de tu dispositivo."),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(
              "Cancelar",
              style: TextStyle(
                color: Colors.red[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await ph.openAppSettings();
              context.pop();
            },
            child: const Text(
              "Abrir Configuraciones",
              style: TextStyle(
                color: AppTheme.weveSkyBlue,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Mostrar modal explicativo del uso de la ubicación
  Future<bool> _showLocationUsageDialog(
      BuildContext screenContext, PermissionStatus permissionStatus) async {
    bool deniedForever = permissionStatus == PermissionStatus.deniedForever;

    return await showDialog<bool>(
          context: screenContext,
          builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            title: const Text('Acceso a la ubicación'),
            content: const Text(
                'Weve utilizará tu ubicación mientras estés usando la aplicación. Esto nos permitirá mostrarte en el mapa y trazar rutas hacia los destinos que elijas'),
            actions: [
              TextButton(
                onPressed: () => context.pop(false),
                child: Text(
                  "No permitir",
                  style: TextStyle(
                    color: Colors.red[600],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (deniedForever) {
                    ph.openAppSettings();
                  } else {
                    Navigator.of(context).pop(true);
                  }
                },
                child: const Text(
                  "Permitir",
                  style: TextStyle(
                    color: AppTheme.weveSkyBlue,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false; //Si cierran el menú sin aceptar, devolvemos false igual.
  }

  Future<bool> getPermissionStatus() async {
    PermissionStatus permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied ||
        permissionStatus == PermissionStatus.deniedForever) {
      return false;
    } else {
      return true;
    }
  }

  /// Método para detener la escucha si es necesario
  void stopListening() {
    _locationSubscription?.cancel();
    _isListening = false;
  }
}
