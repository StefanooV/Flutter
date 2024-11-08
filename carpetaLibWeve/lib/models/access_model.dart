// To parse this JSON data, do
//
//     final access = accessFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Access accessFromMap(String str) => Access.fromMap(json.decode(str));

String accessToMap(Access data) => json.encode(data.toMap());

class Access {
  Access({
    required this.token,
    required this.expires,
  });

  final String token;
  final String expires;

  factory Access.fromMap(Map<String, dynamic> json) => Access(
        token: json["token"],
        expires: json["expires"],
      );

  Map<String, dynamic> toMap() => {
        "token": token,
        "expires": expires,
      };
}
