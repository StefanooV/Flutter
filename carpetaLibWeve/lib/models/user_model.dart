import 'package:flutter/material.dart';

class UserData {
  final String name;
  final String password;
  final String email;
  final String? photo;

  UserData(
      {required this.name,
      required this.password,
      required this.email,
      this.photo});
}
