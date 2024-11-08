// ignore_for_file: body_might_complete_normally_nullable, must_be_immutable

import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/widgets/widgets.dart';

class PhoneForm extends StatefulWidget {
  final String fieldName;
  Map<String, String> formValues;
  PhoneForm({
    super.key,
    required this.fieldName,
    required this.formValues,
  });

  @override
  State<PhoneForm> createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {
  late String flagString;
  late String countryPhoneCode;
  @override
  void initState() {
    super.initState();
    flagString = "AR";
    countryPhoneCode = "+54";
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => showModalBottomSheet(
                  showDragHandle: true,
                  isDismissible: true,
                  isScrollControlled: true,
                  enableDrag: true,
                  useSafeArea: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  context: context,
                  builder: (context) => const CountrySelectionBottomSheet(),
                ).then(
                  (value) => setState(
                    () {
                      if (value != null) {
                        CountrySelection countrySelection = value;
                        flagString = countrySelection.flagString;
                        countryPhoneCode = countrySelection.phoneCode;
                      }
                    },
                  ),
                ),
                child: Flag.fromString(
                  flagString,
                  width: 30,
                  height: 30,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                countryPhoneCode,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
      validator: (value) {
        if (value != null) {
          if (value.length < 2) {
            return "Ingrese un número de teléfono válido";
          }
        }
      },
      onChanged: (value) {
        widget.formValues[widget.fieldName] = countryPhoneCode + value;
        print(widget.formValues);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
