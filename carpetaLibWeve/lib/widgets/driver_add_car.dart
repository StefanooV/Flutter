import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:weveapp/providers/providers.dart';

import '../models/car_model.dart';
import '../models/get_list_model.dart';
import '../theme/app_theme.dart';
import 'brand_selector.dart';
import 'form_titles.dart';
import 'model_selector.dart';

class DriverAddCar extends StatefulWidget {
  const DriverAddCar({super.key, this.updateParentState});
  final VoidCallback? updateParentState;

  @override
  State<DriverAddCar> createState() => _DriverAddCarState();
}

class _DriverAddCarState extends State<DriverAddCar> {
  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context, listen: true);
    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
    final Map<String, String> formValues = {
      "brand": "",
      "model": "",
    };
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Agregá tu vehículo",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                  fontSize: 22),
            ),
            Expanded(
              child: ListView(
                  padding: const EdgeInsets.all(0),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: myFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 10,
                          ),
                          const FormTitle(text: "Marca"),
                          const SizedBox(height: 5),
                          appData.brandsReady
                              ? BrandSelect(
                                  prefix: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: DropdownButtonHideUnderline(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: DropdownButton<String>(
                                          elevation: 0,
                                          dropdownColor: const Color.fromARGB(
                                              255, 236, 236, 236),
                                          value: appData.selectedBrand,
                                          isExpanded: true,
                                          onChanged: (newValue) {
                                            setState(() {
                                              appData.selectedBrand = newValue!;
                                              appData.getBrandModels(appData
                                                  .brandsList
                                                  .firstWhere((element) =>
                                                      element.description ==
                                                      newValue)
                                                  .id);
                                            });
                                          },
                                          items: appData.brandsList
                                              .map((GetList getList) {
                                            return DropdownMenuItem<String>(
                                              value: getList.description,
                                              child: Text(getList.description),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  formValues: formValues,
                                  formProperty: "brand",
                                  errorMessage: "¡Seleccioná una marca!",
                                  brand: appData.selectedBrand,
                                )
                              : const SizedBox(
                                  height: 100,
                                  width: 300,
                                  child: Center(
                                    child: LoadingIndicator(
                                        indicatorType: Indicator.ballPulseSync,
                                        colors: AppTheme.colorsCollection),
                                  ),
                                ),
                          const SizedBox(height: 15),
                          appData.brandSelected
                              ? const FormTitle(text: "Modelo")
                              : const SizedBox.shrink(),
                          const SizedBox(height: 5),
                          appData.modelsReady
                              ? ModelSelect(
                                  prefix: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: DropdownButtonHideUnderline(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: DropdownButton<String>(
                                          elevation: 0,
                                          dropdownColor: const Color.fromARGB(
                                              255, 236, 236, 236),
                                          value: appData.selectedModel,
                                          isExpanded: true,
                                          onChanged: (newValue) {
                                            setState(() {
                                              appData.selectedModel = newValue!;
                                            });
                                          },
                                          items: appData.carModelsList
                                              .map((Car carModel) {
                                            return DropdownMenuItem<String>(
                                              value: carModel.description,
                                              child: Text(carModel.description),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  formValues: formValues,
                                  formProperty: "brand",
                                  errorMessage: "¡Seleccioná una marca!",
                                  model: appData.selectedModel,
                                )
                              : const SizedBox(
                                  height: 100,
                                  width: 300,
                                  child: Center(
                                    child: LoadingIndicator(
                                        indicatorType: Indicator.ballPulseSync,
                                        colors: AppTheme.colorsCollection),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    "Siguiente",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                ),
                onPressed: () async {
                  String vehicleModelId = appData.carModelsList
                      .firstWhere((element) =>
                          element.description == appData.selectedModel)
                      .id;
                  String vehicleBrandId = appData.brandsList
                      .firstWhere((element) =>
                          element.description == appData.selectedBrand)
                      .id;
                  print("brand: $vehicleBrandId");
                  print("model: $vehicleModelId");
                  if (myFormKey.currentState!.validate()) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    await HttpRequestServices().addUserVehicle(
                        context, vehicleBrandId, vehicleModelId);
                  }
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
