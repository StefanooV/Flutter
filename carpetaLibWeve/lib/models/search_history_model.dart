import 'dart:convert';
import 'package:google_places_flutter/model/prediction.dart';

class SearchHistory {
  final String title;
  final double latitude;
  final double longitude;
  final Prediction? prediction;

  SearchHistory({
    required this.title,
    required this.latitude,
    required this.longitude,
    this.prediction,
  });

  factory SearchHistory.fromJson(String str) =>
      SearchHistory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchHistory.fromMap(Map<String, dynamic> json) => SearchHistory(
        title: json["title"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        prediction: Prediction.fromJson(json["prediction"]),
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "latitude": latitude,
        "longitude": longitude,
        "prediction": prediction?.toJson(),
      };
}
