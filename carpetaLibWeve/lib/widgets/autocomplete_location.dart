import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/services/app_constants.dart';

class AutocompleteLocationField extends StatefulWidget {
  const AutocompleteLocationField({
    Key? key,
    required this.hintTextField,
    required this.controller,
    this.saveHistory,
    this.decoration,
  }) : super(key: key);

  final String hintTextField;
  final TextEditingController controller;
  final bool? saveHistory;
  final InputDecoration? decoration;

  @override
  State<AutocompleteLocationField> createState() =>
      AutocompleteLocationFieldState();
}

class AutocompleteLocationFieldState extends State<AutocompleteLocationField> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: GooglePlacesAutoCompleteTextFormField(
      decoration: widget.decoration ??
          InputDecoration(
            suffixIcon: const Icon(Icons.search),
            hintText: widget.hintTextField,
          ),
      textEditingController: widget.controller,
      googleAPIKey: AppConstants.googleMapsApiKey,
      debounceTime: 600,
      countries: const ["ar"],
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: (Prediction prediction) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        widget.controller.text = prediction.description!;

        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(
            offset: prediction.description!.length,
          ),
        );

        setNavigationData(
          widget.hintTextField,
          prediction,
          widget.controller.text,
          context,
        );
        if (widget.saveHistory == true) {
          HttpRequestServices().addToSearchHistory(
            prediction,
            prediction.description!,
            double.parse(prediction.lat!),
            double.parse(prediction.lng!),
          );
        }
      },
    ));
  }
}

void setNavigationData(
    String field, Prediction predict, String? name, BuildContext context) {
  print("Entro $context, $field, $predict");
  final navigationDataProvider = Provider.of<AppData>(context, listen: false);
  if (field == "Ingresa un punto de partida") {
    if (predict.lat != null) {
      navigationDataProvider.setPointData("start", name,
          LatLng(double.parse(predict.lat!), double.parse(predict.lng!)));
    }
  }
  if (field == "Ingresa un destino") {
    if (predict.lat != null) {
      navigationDataProvider.setPointData("destination", name,
          LatLng(double.parse(predict.lat!), double.parse(predict.lng!)));
    }
  }
}
