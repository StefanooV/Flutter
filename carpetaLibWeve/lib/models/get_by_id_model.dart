// To parse this JSON data, do
//
//     final GetById = GetByIdFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetById GetByIdFromMap(String str) => GetById.fromMap(json.decode(str));

String GetByIdToMap(GetById data) => json.encode(data.toMap());

class GetById {
  GetById({
    required this.id,
    required this.description,
  });

  final String id;
  final String description;

  factory GetById.fromMap(Map<String, dynamic> json) => GetById(
        id: json["id"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
      };
}
