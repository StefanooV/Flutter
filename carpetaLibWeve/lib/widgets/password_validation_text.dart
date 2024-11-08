import 'package:flutter/material.dart';

class PasswordValidationText extends StatelessWidget {
  final String password;
  const PasswordValidationText({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    bool typing = false;
    String text = buildString(password);
    if (password == "dns" || password == "") {
      typing = false;
    } else {
      typing = true;
    }
    if (typing) {
      return Row(
        children: [
          Icon(
            Icons.error,
            color: Colors.red[600],
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(
              text,
              style: TextStyle(color: Colors.red[600]),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

String buildString(String password) {
  List<String> passwordRequirements = [];

  if (!checkCapitalLetters(password)) {
    passwordRequirements.add("Al menos una mayúscula.\n");
  }
  if (!checkLowerCaseLetters(password)) {
    passwordRequirements.add("Al menos una minúscula.\n");
  }
  if (!checkNumber(password)) {
    passwordRequirements.add("Al menos un número.\n");
  }
  if (!checkSpecialCharacters(password)) {
    passwordRequirements.add("Al menos un carácter especial.\n");
  }
  if (checkSpaces(password)) {
    passwordRequirements.add("No puede contener espacios.");
  }
  if (passwordRequirements.isEmpty) {
    return "";
  } else {
    if (passwordRequirements.length == 1) {
      if (passwordRequirements[0] == "No puede contener espacios") {
        return passwordRequirements.join();
      } else {
        return "La contraseña debe contener: ${passwordRequirements.join()}";
      }
    } else {
      return "La contraseña debe contener:\n${passwordRequirements.join()}";
    }
  }
}

bool checkNumber(String password) {
  bool valid;
  RegExp regex = RegExp(r'\d+');
  valid = regex.hasMatch(password);
  return valid;
}

bool checkCapitalLetters(String password) {
  bool valid;
  RegExp regex = RegExp(r'[A-Z]');
  valid = regex.hasMatch(password);
  return valid;
}

bool checkLowerCaseLetters(String password) {
  bool valid;
  RegExp regex = RegExp(r'[a-z]');
  valid = regex.hasMatch(password);
  return valid;
}

bool checkSpecialCharacters(String password) {
  bool valid;
  RegExp regex = RegExp(r'[!@#\$%\^&\*\(\)\-=_\+{}\[\]|;:"<>,\.\?\/\\]');
  valid = regex.hasMatch(password);
  return valid;
}

bool checkSpaces(String password) {
  bool valid;
  RegExp regex = RegExp(r'\s');
  valid = regex.hasMatch(password);
  return valid;
}
