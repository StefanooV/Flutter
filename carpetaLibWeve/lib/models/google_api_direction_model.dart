import 'dart:convert';

GoogleApiDirectionModel gogleApiDirectionModelFromMap(String str) =>
    GoogleApiDirectionModel.fromMap(json.decode(str));

String moogleApiDirectionModelToMap(GoogleApiDirectionModel data) =>
    json.encode(data.toMap());

class GoogleApiDirectionModel {
  GoogleApiDirectionModel({
    required this.durationText,
    required this.durationValue,
    required this.distanceText,
    required this.distanceValue,
    required this.polylinePoints,
  });

  final String durationText;
  final int durationValue;
  final String distanceText;
  final int distanceValue;
  final String polylinePoints;

  factory GoogleApiDirectionModel.fromMap(Map<String, dynamic> json) =>
      GoogleApiDirectionModel(
        durationText: json['routes'][0]['legs'][0]['duration']['text'],
        durationValue: json['routes'][0]['legs'][0]['duration']['value'],
        distanceText: json['routes'][0]['legs'][0]['distance']['text'],
        distanceValue: json['routes'][0]['legs'][0]['distance']['value'],
        polylinePoints: json['routes'][0]['overview_polyline']['points'],
      );

  Map<String, dynamic> toMap() => {
        "durationText": durationText,
        "durationValue": durationValue,
        "distanceText": distanceText,
        "distanceValue": distanceValue,
        "polylinePoints": polylinePoints,
      };
}
