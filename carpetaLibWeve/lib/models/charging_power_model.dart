// To parse this JSON data, do
//
//     final chargingPower = chargingPowerFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ChargingPower chargingPowerFromMap(String str) =>
    ChargingPower.fromMap(json.decode(str));

String chargingPowerToMap(ChargingPower data) => json.encode(data.toMap());

class ChargingPower {
  ChargingPower({
    required this.id,
    required this.description,
    required this.status,
  });

  final String id;
  final String description;
  bool status;

  factory ChargingPower.fromMap(Map<String, dynamic> json) => ChargingPower(
        id: json["id"],
        description: json["description"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
        "status": status,
      };
}
