// To parse this JSON data, do
//
//     final getList = getListFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<GetList> getListFromMap(String str) =>
    List<GetList>.from(json.decode(str).map((x) => GetList.fromMap(x)));

String getListToMap(List<GetList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class GetList {
  GetList({
    required this.id,
    required this.description,
  });

  final String id;
  final String description;

  factory GetList.fromMap(Map<String, dynamic> json) => GetList(
        id: json["id"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
      };
}
