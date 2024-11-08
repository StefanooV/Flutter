import 'dart:convert';

Favorites favoritesFromMap(String str) => Favorites.fromMap(json.decode(str));

String favoritesToMap(Favorites data) => json.encode(data.toMap());

class Favorites {
  Favorites({
    required this.results,
    required this.pageCount,
    required this.totalCount,
  });

  final List<Result> results;
  final int pageCount;
  final int totalCount;

  factory Favorites.fromMap(Map<String, dynamic> json) => Favorites(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromMap(x))),
        pageCount: json["pageCount"],
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toMap() => {
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
        "pageCount": pageCount,
        "totalCount": totalCount,
      };
}

class Result {
  Result({
    required this.id,
    required this.chargerId,
    required this.name,
    required this.address,
  });

  final String id;
  final String chargerId;
  final String name;
  final String address;

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        id: json["id"],
        chargerId: json["stationId"],
        name: json["name"],
        address: json["address"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "stationId": chargerId,
        "name": name,
        "address": address,
      };
}
