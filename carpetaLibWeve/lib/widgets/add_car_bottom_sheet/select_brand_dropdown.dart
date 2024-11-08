// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/screens/router/app_routes.dart';
import 'package:weveapp/widgets/widgets.dart';

class SelectBrandDropdown extends StatefulWidget {
  final List<VehicleBrand> vehiclesBrandList;
  final List<DropdownMenuItem<String>> brandsListDescription;
  final BuildContext? sheetContext;
  final bool isRegistering;
  const SelectBrandDropdown({
    super.key,
    required this.vehiclesBrandList,
    required this.brandsListDescription,
    this.sheetContext,
    required this.isRegistering,
  });

  @override
  State<SelectBrandDropdown> createState() => _SelectBrandDropdownState();
}

class _SelectBrandDropdownState extends State<SelectBrandDropdown> {
  String selectedBrand = "";
  String selectedModel = "";
  String selectedBrandId = "";
  String selectedModelId = "";
  bool connectionError = true;

  late Future<List<VehicleModel>?> _vehicleModelFuture;
  @override
  void initState() {
    super.initState();
    selectedBrand = widget.vehiclesBrandList.first.description;
    selectedBrandId = widget.vehiclesBrandList.first.id;
    _vehicleModelFuture = HttpRequestServices().getCarModels(
      widget.vehiclesBrandList.first.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
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
                        dropdownColor: const Color.fromARGB(255, 236, 236, 236),
                        items: widget.brandsListDescription,
                        value: selectedBrand,
                        onChanged: (value) {
                          print("Value: $value");
                          String brandId = widget.vehiclesBrandList
                              .firstWhere((e) => e.description == value)
                              .id;
                          setState(
                            () {
                              selectedBrandId = brandId;
                              _vehicleModelFuture =
                                  HttpRequestServices().getCarModels(brandId);
                              selectedBrand = value!;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FutureBuilder<List<VehicleModel>?>(
                  future: _vehicleModelFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data == null) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            connectionError = true;
                          });
                        });
                        return Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.grey[200],
                          ),
                          child: const Center(
                            child: Text(
                                "No encontramos ningún modelo de esta marca!"),
                          ),
                        );
                      } else {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            connectionError = false;
                          });
                        });
                        List<VehicleModel> vehicleModelsList = snapshot.data!;
                        List<DropdownMenuItem<String>> modelsListDescription =
                            [];
                        selectedModel = vehicleModelsList.first.description;
                        selectedModelId = vehicleModelsList.first.id;
                        for (var element in vehicleModelsList) {
                          modelsListDescription.add(
                            DropdownMenuItem(
                              value: element.description,
                              child: Text(element.description),
                            ),
                          );
                        }
                        return Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
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
                                dropdownColor:
                                    const Color.fromARGB(255, 236, 236, 236),
                                items: modelsListDescription,
                                value: selectedModel,
                                onChanged: (value) {
                                  String modelId = vehicleModelsList
                                      .firstWhere((e) => e.description == value)
                                      .id;

                                  print("Value: $value");
                                  setState(
                                    () {
                                      selectedModel = value!;
                                      selectedModelId = modelId;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          connectionError = true;
                        });
                      });
                      return ShimmerContainer(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        borderRadius: 8,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: connectionError
                ? null
                : () async {
                    await HttpRequestServices().addUserVehicle(
                      context,
                      selectedBrandId,
                      selectedModelId,
                    );
                    widget.sheetContext!.pop();
                    if (widget.isRegistering) {
                      AppRoutes().clearNavigationStack(context, "/");
                    }
                  },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Text(
                "Siguiente",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
