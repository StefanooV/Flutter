import 'package:meta/meta.dart';
import 'dart:convert';

DriverUser driverUserFromMap(String str) =>
    DriverUser.fromMap(json.decode(str));

String driverUserToMap(DriverUser data) => json.encode(data.toMap());

class DriverUser {
  DriverUser({
    this.displayName,
    this.name,
    this.lastName,
    this.phoneNumber,
    this.city,
    this.country,
    required this.bornDate,
    required this.uid,
    required this.email,
    this.photo,
    this.createdOn,
    this.modifiedOn,
    required this.id,
  });

  final String? displayName;
  final String? name;
  final String? lastName;
  String? phoneNumber;
  final String? city;
  final String? country;
  final DateTime bornDate;
  final String uid;
  final String email;
  final String? photo;
  final DateTime? createdOn;
  final DateTime? modifiedOn;
  final String id;

  factory DriverUser.fromMap(Map<String, dynamic> json) => DriverUser(
        displayName: json["displayName"],
        name: json["name"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        city: json["city"],
        country: json["country"],
        bornDate: DateTime.parse(json["bornDate"]),
        uid: json["uid"],
        email: json["email"],
        photo: json["photo"],
        createdOn: DateTime.parse(json["createdOn"]),
        modifiedOn: DateTime.parse(json["modifiedOn"]),
        id: json["id"],
      );
  void clearPhone() {
    phoneNumber = "";
  }

  Map<String, dynamic> toMap() => {
        "displayName": displayName,
        "name": name,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "city": city,
        "country": country,
        "bornDate": bornDate.toIso8601String(),
        "uid": uid,
        "email": email,
        "photo": photo,
        "createdOn": createdOn?.toIso8601String(),
        "modifiedOn": modifiedOn?.toIso8601String(),
        "id": id,
      };
}
