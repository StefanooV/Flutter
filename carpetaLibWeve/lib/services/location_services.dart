// location_service.dart
import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Future<LocationData?> initializeLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Verificar si el servicio está habilitado
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return null;
    }

    // Verificar permisos
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return null;
    }

    // Obtener la ubicación actual
    return await _location.getLocation();
  }

  Stream<LocationData> onLocationChanged() {
    return _location.onLocationChanged;
  }
}
