import 'dart:convert';

class VehicleBrand {
  final String id;
  final String description;

  VehicleBrand({
    required this.id,
    required this.description,
  });

  factory VehicleBrand.fromJson(String str) =>
      VehicleBrand.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VehicleBrand.fromMap(Map<String, dynamic> json) => VehicleBrand(
        id: json["id"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
      };
}
