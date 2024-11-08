import 'package:flutter/material.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/theme/app_theme.dart';

class DriverCarSelectionScreen extends StatefulWidget {
  const DriverCarSelectionScreen({super.key});

  @override
  State<DriverCarSelectionScreen> createState() =>
      _DriverCarSelectionScreenState();
}

class _DriverCarSelectionScreenState extends State<DriverCarSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Agregar un vehículo",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Agregá tu vehículo",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 22,
                    width: 22,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: AppTheme.wevePrimaryBlue,
                      ),
                    ),
                    child: const Material(
                      color: AppTheme.wevePrimaryBlue,
                      shape: CircleBorder(),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  Container(
                    height: 22,
                    width: 22,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: AppTheme.wevePrimaryBlue,
                      ),
                    ),
                    child: const Material(
                      color: AppTheme.wevePrimaryBlue,
                      shape: CircleBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FutureBuilder<List<VehicleBrand>?>(
                          future: HttpRequestServices().getCarBrands(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.data == null) {
                                return Expanded(
                                  child: Center(
                                    child: Text(
                                        "No se pudieron obtener marcas de vehículos"),
                                  ),
                                );
                              } else {
                                List<VehicleBrand> vehicleBrandsList =
                                    snapshot.data!;
                                List<DropdownMenuItem<String>>
                                    brandsListDescription = [];

                                for (var element in vehicleBrandsList) {
                                  brandsListDescription.add(
                                    DropdownMenuItem(
                                      value: element.description,
                                      child: Text(element.description),
                                    ),
                                  );
                                }
                                String selectedValue =
                                    brandsListDescription.first.value!;

                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.grey[200],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        elevation: 0,
                                        dropdownColor: const Color.fromARGB(
                                            255, 236, 236, 236),
                                        items: brandsListDescription,
                                        value: selectedValue,
                                        onChanged: (value) {
                                          print("Value: $value");
                                          setState(
                                            () {
                                              selectedValue = value!;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return Text("opax");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
