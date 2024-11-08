// ignore_for_file: must_be_immutable, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:weveapp/theme/app_theme.dart';

class PasswordForm extends StatefulWidget {
  final String hintText;
  final String? fieldName;
  String? errorText;
  Map<String, String>? formValues;
  String? password;
  PasswordForm({
    super.key,
    this.password,
    required this.hintText,
    this.fieldName,
    this.errorText,
    this.formValues,
  });

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: widget.hintText,
        errorText: widget.errorText,
        prefixIcon: InkWell(
          onTap: () => switchObscureText(),
          child: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: obscureText ? Colors.grey : AppTheme.weveSkyBlue,
          ),
        ),
      ),
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        List<String> messages = [];
        if (widget.formValues!["password"] != null) {
          if (value != widget.formValues!["password"]) {
            return "Las contraseñas no coinciden!";
          }
        }
        if (value == "") {
          return "Ingrese su contraseña";
        }
        if (value!.length < 8) {
          messages.add("La contraseña debe tener al menos 8 caracteres");
        }
        if (!RegExp(r'\d').hasMatch(value)) {
          messages.add("La contraseña debe contener al menos un número");
        }
        if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
          messages.add(
              "La contraseña debe contener al menos\nun carácter especial");
        }
        if (!value.contains(RegExp(r'[A-Z]'))) {
          messages
              .add("La contraseña debe contener al\nmenos una letra mayúscula");
        }
        return messages.isNotEmpty ? messages.join("\n") : null;
      },
      onChanged: (value) {
        if (widget.fieldName != null) {
          widget.formValues![widget.fieldName!] = value;
          print(widget.formValues);
        }
      },
    );
  }

  void switchObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
