// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  final String hintText;
  final String
      fieldContent; //esto debería ser nombre/apellido/otra cosa de este estilo
  final String fieldName;
  Map<String, String> formValues;
  TextForm({
    super.key,
    required this.hintText,
    required this.fieldContent,
    required this.fieldName,
    required this.formValues,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
      ),
      // ignore: body_might_complete_normally_nullable
      validator: (value) {
        if (value != null) {
          if (value.isEmpty) {
            return 'Ingrese un $fieldContent';
          }
          if (value.length < 2) {
            return 'Ingrese un $fieldContent válido';
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
