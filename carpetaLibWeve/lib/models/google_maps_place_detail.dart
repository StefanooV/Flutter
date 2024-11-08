// To parse this JSON data, do
//
//     final googleMapsPlaceDetail = googleMapsPlaceDetailFromMap(jsonString);

import 'dart:convert';

GoogleMapsPlaceDetail googleMapsPlaceDetailFromMap(String str) =>
    GoogleMapsPlaceDetail.fromMap(json.decode(str));

String googleMapsPlaceDetailToMap(GoogleMapsPlaceDetail data) =>
    json.encode(data.toMap());

class GoogleMapsPlaceDetail {
  final PlusCode plusCode;
  final List<Result> results;
  final String status;

  GoogleMapsPlaceDetail({
    required this.plusCode,
    required this.results,
    required this.status,
  });

  factory GoogleMapsPlaceDetail.fromMap(Map<String, dynamic> json) =>
      GoogleMapsPlaceDetail(
        plusCode: PlusCode.fromMap(json["plus_code"]),
        results:
            List<Result>.from(json["results"].map((x) => Result.fromMap(x))),
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "plus_code": plusCode.toMap(),
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
        "status": status,
      };
}

class PlusCode {
  final String compoundCode;
  final String globalCode;

  PlusCode({
    required this.compoundCode,
    required this.globalCode,
  });

  factory PlusCode.fromMap(Map<String, dynamic> json) => PlusCode(
        compoundCode: json["compound_code"],
        globalCode: json["global_code"],
      );

  Map<String, dynamic> toMap() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
      };
}

class Result {
  final List<AddressComponent> addressComponents;
  final String formattedAddress;
  final Geometry geometry;
  final String placeId;
  final List<String> types;
  final PlusCode? plusCode;

  Result({
    required this.addressComponents,
    required this.formattedAddress,
    required this.geometry,
    required this.placeId,
    required this.types,
    this.plusCode,
  });

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        addressComponents: List<AddressComponent>.from(
            json["address_components"].map((x) => AddressComponent.fromMap(x))),
        formattedAddress: json["formatted_address"],
        geometry: Geometry.fromMap(json["geometry"]),
        placeId: json["place_id"],
        types: List<String>.from(json["types"].map((x) => x)),
        plusCode: json["plus_code"] == null
            ? null
            : PlusCode.fromMap(json["plus_code"]),
      );

  Map<String, dynamic> toMap() => {
        "address_components":
            List<dynamic>.from(addressComponents.map((x) => x.toMap())),
        "formatted_address": formattedAddress,
        "geometry": geometry.toMap(),
        "place_id": placeId,
        "types": List<dynamic>.from(types.map((x) => x)),
        "plus_code": plusCode?.toMap(),
      };
}

class AddressComponent {
  final String longName;
  final String shortName;
  final List<Type?> types;

  AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  factory AddressComponent.fromMap(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: List<Type?>.from(json["types"].map((x) => typeValues.map[x])),
      );

  Map<String, dynamic> toMap() => {
        "long_name": longName,
        "short_name": shortName,
        "types": List<dynamic>.from(types.map((x) => typeValues.reverse[x])),
      };
}

enum Type {
  ADMINISTRATIVE_AREA_LEVEL_1,
  ADMINISTRATIVE_AREA_LEVEL_2,
  COUNTRY,
  LOCALITY,
  PLUS_CODE,
  POLITICAL,
  ROUTE,
  STREET_NUMBER
}

final typeValues = EnumValues({
  "administrative_area_level_1": Type.ADMINISTRATIVE_AREA_LEVEL_1,
  "administrative_area_level_2": Type.ADMINISTRATIVE_AREA_LEVEL_2,
  "country": Type.COUNTRY,
  "locality": Type.LOCALITY,
  "plus_code": Type.PLUS_CODE,
  "political": Type.POLITICAL,
  "route": Type.ROUTE,
  "street_number": Type.STREET_NUMBER
});

class Geometry {
  final Viewport? bounds;
  final Location location;
  final String locationType;
  final Viewport viewport;

  Geometry({
    this.bounds,
    required this.location,
    required this.locationType,
    required this.viewport,
  });

  factory Geometry.fromMap(Map<String, dynamic> json) => Geometry(
        bounds:
            json["bounds"] == null ? null : Viewport.fromMap(json["bounds"]),
        location: Location.fromMap(json["location"]),
        locationType: json["location_type"],
        viewport: Viewport.fromMap(json["viewport"]),
      );

  Map<String, dynamic> toMap() => {
        "bounds": bounds?.toMap(),
        "location": location.toMap(),
        "location_type": locationType,
        "viewport": viewport.toMap(),
      };
}

class Viewport {
  final Location northeast;
  final Location southwest;

  Viewport({
    required this.northeast,
    required this.southwest,
  });

  factory Viewport.fromMap(Map<String, dynamic> json) => Viewport(
        northeast: Location.fromMap(json["northeast"]),
        southwest: Location.fromMap(json["southwest"]),
      );

  Map<String, dynamic> toMap() => {
        "northeast": northeast.toMap(),
        "southwest": southwest.toMap(),
      };
}

class Location {
  final double lat;
  final double lng;

  Location({
    required this.lat,
    required this.lng,
  });

  factory Location.fromMap(Map<String, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "lat": lat,
        "lng": lng,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
