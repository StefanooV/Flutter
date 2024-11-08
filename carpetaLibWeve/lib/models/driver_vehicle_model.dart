// To parse this JSON data, do
//
//     final driverVehicle = driverVehicleFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DriverVehicle driverVehicleFromMap(String str) =>
    DriverVehicle.fromMap(json.decode(str));

String driverVehicleToMap(DriverVehicle data) => json.encode(data.toMap());

class DriverVehicle {
  final String id;
  final String vehicleBrandId;
  final String vehicleBrandDescription;
  final String vehicleModelId;
  final String vehicleModelDescription;
  final String vehicleTypeId;
  final String vehicleTypeDescription;
  final String vehicleConnectorTypeId;
  final String vehicleConnectorTypeDescription;

  DriverVehicle({
    required this.id,
    required this.vehicleBrandId,
    required this.vehicleBrandDescription,
    required this.vehicleModelId,
    required this.vehicleModelDescription,
    required this.vehicleTypeId,
    required this.vehicleTypeDescription,
    required this.vehicleConnectorTypeId,
    required this.vehicleConnectorTypeDescription,
  });

  factory DriverVehicle.fromMap(Map<String, dynamic> json) => DriverVehicle(
        id: json["id"],
        vehicleBrandId: json["vehicleBrandId"],
        vehicleBrandDescription: json["vehicleBrandDescription"],
        vehicleModelId: json["vehicleModelId"],
        vehicleModelDescription: json["vehicleModelDescription"],
        vehicleTypeId: json["vehicleTypeId"],
        vehicleTypeDescription: json["vehicleTypeDescription"],
        vehicleConnectorTypeId: json["vehicleConnectorTypeId"],
        vehicleConnectorTypeDescription:
            json["vehicleConnectorTypeDescription"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "vehicleBrandId": vehicleBrandId,
        "vehicleBrandDescription": vehicleBrandDescription,
        "vehicleModelId": vehicleModelId,
        "vehicleModelDescription": vehicleModelDescription,
        "vehicleTypeId": vehicleTypeId,
        "vehicleTypeDescription": vehicleTypeDescription,
        "vehicleConnectorTypeId": vehicleConnectorTypeId,
        "vehicleConnectorTypeDescription": vehicleConnectorTypeDescription,
      };
}
