// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:weveapp/helper/helpers.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/autocomplete_location.dart';

class SearchLocation extends StatefulWidget {
  final TextEditingController originController;
  final TextEditingController destinationController;
  const SearchLocation(
      {super.key,
      required this.originController,
      required this.destinationController});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  late TextEditingController originController;
  late TextEditingController destinationController;
  late AppData navigationDataProvider;
  final LocationHelper _locationHelper = LocationHelper();
  bool gettingLocation = false;

  @override
  void initState() {
    super.initState();
    originController = widget.originController;
    destinationController = widget.destinationController;
    navigationDataProvider = Provider.of<AppData>(context, listen: false);
  }

  void _swapNavigationData() {
    // Intercambiar los datos de navegación
    final tempNavData = navigationDataProvider.startNavigationData;
    navigationDataProvider.startNavigationData =
        navigationDataProvider.destinationNavigationData;
    navigationDataProvider.destinationNavigationData = tempNavData;

    // Intercambiar los textos de los campos de texto
    final tempTextfieldText = originController.text;
    originController.text = destinationController.text;
    destinationController.text = tempTextfieldText;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final navigationDataProvider = Provider.of<AppData>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (gettingLocation)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: CircularProgressIndicator(
                      color: AppTheme.weveSkyBlue,
                    ),
                  ),
                ),
              if (!gettingLocation)
                IconButton(
                  icon: const Icon(
                    Icons.my_location_outlined,
                    color: AppTheme.weveSkyBlue,
                  ),
                  onPressed: () async {
                    setState(() {
                      gettingLocation = true;
                    });
                    LatLng? userLocation =
                        await _locationHelper.getUserLocation(context);

                    if (userLocation != null) {
                      navigationDataProvider.setPointData(
                        "start",
                        "User Location",
                        userLocation,
                      );
                      originController.text = "Tu ubicación";
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "No se pudo obtener tu ubicación actual.",
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.red[400],
                          duration: const Duration(seconds: 3),
                          dismissDirection: DismissDirection.down,
                        ),
                      );
                    }

                    setState(() {
                      gettingLocation = false;
                    });
                  },
                ),
              AutocompleteLocationField(
                hintTextField: "Ingresa un punto de partida",
                controller: originController,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            _swapNavigationData();
          },
          icon: const Icon(Icons.swap_vert),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.place,
                  color: AppTheme.weveSkyBlue,
                ),
              ),
              AutocompleteLocationField(
                hintTextField: "Ingresa un destino",
                controller: destinationController,
                saveHistory: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
