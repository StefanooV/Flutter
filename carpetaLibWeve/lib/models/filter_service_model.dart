// To parse this JSON data, do
//
//     final filterService = filterServiceFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

FilterService filterServiceFromMap(String str) =>
    FilterService.fromMap(json.decode(str));

String filterServiceToMap(FilterService data) => json.encode(data.toMap());

class FilterService {
  final String id;
  final String description;
  bool status;

  FilterService({
    required this.id,
    required this.description,
    required this.status,
  });

  factory FilterService.fromMap(Map<String, dynamic> json) => FilterService(
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
