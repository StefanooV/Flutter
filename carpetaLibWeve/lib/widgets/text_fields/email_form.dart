// ignore_for_file: body_might_complete_normally_nullable, must_be_immutable

import 'package:flutter/material.dart';
import 'package:weveapp/helper/helper.dart';

class EmailForm extends StatelessWidget {
  final String hintText;
  final String fieldName;
  Map<String, String> formValues;
  String? errorText;
  EmailForm({
    super.key,
    required this.hintText,
    required this.fieldName,
    required this.formValues,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
      ),
      validator: (value) {
        if (value != null) {
          if (value.isEmpty) {
            return "Ingrese e-mail";
          }
          if (!Helper().isValidEmail(value)) {
            return "Ingrese un e-mail válido";
          }
        }
      },
      onChanged: (value) {
        formValues[fieldName] = value;
        print(formValues);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
