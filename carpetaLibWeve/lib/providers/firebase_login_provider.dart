import 'package:flutter/material.dart';

import '../models/user_model.dart';

class FirebaseAuthData extends ChangeNotifier {
  Map userData = {
    "email": "",
    "password": "",
    "name": "",
    "lastname": "",
    "photo": "",
    "phone": ""
  };
}
