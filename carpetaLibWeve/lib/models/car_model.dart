// To parse this JSON data, do
//
//     final car = carFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Car> carFromMap(String str) =>
    List<Car>.from(json.decode(str).map((x) => Car.fromMap(x)));

String carToMap(List<Car> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Car {
  Car({
    required this.description,
    required this.brandId,
    required this.createdOn,
    required this.modifiedOn,
    required this.id,
  });

  String description;
  String brandId;
  DateTime createdOn;
  DateTime modifiedOn;
  String id;

  factory Car.fromMap(Map<String, dynamic> json) => Car(
        description: json["description"],
        brandId: json["brandId"],
        createdOn: DateTime.parse(json["createdOn"]),
        modifiedOn: DateTime.parse(json["modifiedOn"]),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "description": description,
        "brandId": brandId,
        "createdOn": createdOn.toIso8601String(),
        "modifiedOn": modifiedOn.toIso8601String(),
        "id": id,
      };
}
