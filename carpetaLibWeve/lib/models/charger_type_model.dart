// To parse this JSON data, do
//
//     final ChargerConnectorType = ChargerConnectorTypeFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ChargerConnectorType ChargerConnectorTypeFromMap(String str) =>
    ChargerConnectorType.fromMap(json.decode(str));

String ChargerConnectorTypeToMap(ChargerConnectorType data) =>
    json.encode(data.toMap());

class ChargerConnectorType {
  ChargerConnectorType({
    required this.id,
    required this.description,
    required this.imageLink,
    required this.status,
  });

  final String id;
  final String description;
  final String imageLink;
  bool status;

  factory ChargerConnectorType.fromMap(Map<String, dynamic> json) =>
      ChargerConnectorType(
        id: json["id"],
        description: json["description"],
        imageLink: json["imageLink"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
        "imageLink": imageLink,
        "status": status,
      };
}
