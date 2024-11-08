import 'dart:convert';

class VehicleModel {
  final String id;
  final String description;
  final String brandId;

  VehicleModel({
    required this.id,
    required this.description,
    required this.brandId,
  });

  factory VehicleModel.fromJson(String str) =>
      VehicleModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VehicleModel.fromMap(Map<String, dynamic> json) => VehicleModel(
        id: json["id"],
        description: json["description"],
        brandId: json["brandId"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
        "brandId": brandId,
      };
}
