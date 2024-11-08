import 'package:flutter/material.dart';

class BrandSelect extends StatefulWidget {
  final Widget prefix;
  final String brand;
  final String errorMessage;
  final String formProperty;
  final Map<String, dynamic> formValues;

  const BrandSelect({
    Key? key,
    required this.prefix,
    required this.brand,
    required this.errorMessage,
    required this.formProperty,
    required this.formValues
    }): super(key: key);

  @override
  State<BrandSelect> createState() => _BrandSelectState();
}

class _BrandSelectState extends State<BrandSelect> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.brand,
      onChanged: (value) => widget.formValues[widget.formProperty] = value,
      validator: (value){
        if(value == null || value.isEmpty){
          return widget.errorMessage;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        prefixIcon: widget.prefix,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 236, 236, 236), width: 0),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 236, 236, 236), width: 0),
          borderRadius: BorderRadius.circular(5),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Color.fromARGB(255, 255, 0, 0), width: 0),
          borderRadius: BorderRadius.circular(5),
        ),
        hintStyle: const TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.w200),
        filled: true,
        fillColor: const Color.fromARGB(255, 236, 236, 236),
      ),
    );
  }
}
