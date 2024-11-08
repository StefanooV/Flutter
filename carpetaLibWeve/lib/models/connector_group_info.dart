import 'package:meta/meta.dart';
import 'dart:convert';

class ConnectorGroupInfo {
  final String id;
  final String name;
  final String power;
  int count;

  ConnectorGroupInfo({
    required this.id,
    required this.name,
    required this.power,
    required this.count,
  });

  factory ConnectorGroupInfo.fromJson(String str) =>
      ConnectorGroupInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConnectorGroupInfo.fromMap(Map<String, dynamic> json) =>
      ConnectorGroupInfo(
        id: json["id"],
        name: json["name"],
        power: json["power"],
        count: json["count"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "power": power,
        "count": count,
      };
}
