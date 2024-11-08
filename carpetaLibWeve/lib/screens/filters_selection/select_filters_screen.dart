import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/widgets.dart';

class SelectFilters extends StatefulWidget {
  const SelectFilters({super.key});

  @override
  State<SelectFilters> createState() => _SelectFiltersState();
}

class _SelectFiltersState extends State<SelectFilters> {
  bool swvar = false;
  @override
  Widget build(BuildContext context) {
    final globalInfo = Provider.of<MarkersProvider>(context, listen: false);
    final appData = Provider.of<AppData>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Filtros",
          style: TextStyle(fontFamily: "Montserrat"),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: IconButton(
              onPressed: () {
                print("Filtering: ${appData.filtering}");
                print("base: ${appData.baseFiltersBody}");
                print("base: ${appData.filtersRequestBody}");
                checkFiltering(appData, globalInfo);
                print("Filtering: ${appData.filtering}");
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check),
            ),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 24,
              ),
              const FilterTitle(text: "CONECTORES"),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => setState(() {
                      clearFilters(appData, globalInfo);
                    }),
                    child: const Text(
                      "Limpiar filtros",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ),
                ],
              ),
              FiltersConnectorSection(
                appData: appData,
              ),
              const SizedBox(
                height: 12,
              ),
              const FilterTitle(text: "POTENCIA"),
              const SizedBox(
                height: 24,
              ),
              PowerSection(
                globalInfo: globalInfo,
                appData: appData,
              ),
              const SizedBox(
                height: 24,
              ),
              const FilterTitle(text: "DISPONIBILIDAD"),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Expanded(
                    child: Text(
                      "Ocultar puntos de carga fuera de servicio / acceso restringido",
                    ),
                  ),
                  CupertinoSwitch(
                    value:
                        appData.filtersRequestBody["hideInvisibleChargers"] ??
                            false,
                    onChanged: (value) => setState(
                      () {
                        if (!appData.filtering) appData.filtering = true;
                        if (appData
                                .filtersRequestBody["hideInvisibleChargers"] ==
                            null) {
                          appData.filtersRequestBody["hideInvisibleChargers"] =
                              true;
                        } else {
                          appData.filtersRequestBody["hideInvisibleChargers"] =
                              null;
                        }
                      },
                    ),
                    activeColor: AppTheme.weveSkyBlue,
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              const FilterTitle(text: "SERVICIOS CERCANOS"),
              const SizedBox(
                height: 12,
              ),
              NearServicesSection(
                appData: appData,
              ),
              const SizedBox(
                height: 12,
              ),
              const FilterTitle(text: "OTROS FILTROS"),
              const SizedBox(
                height: 12,
              ),
              OtherFiltersSection(
                appData: appData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void clearFilters(AppData appData, MarkersProvider globalInfo) {
  globalInfo.selectedIndex = 5;
  appData.filtersRequestBody["hideInvisibleChargers"] = false;
  List<String> filterSwitchesKeys = appData.filterSwitches.keys.toList();
  for (String key in filterSwitchesKeys) {
    appData.filterSwitches[key] = false;
  }
  for (var element in appData.connectors) {
    element.status = false;
  }
  for (var element in appData.filtersRequestBody.keys) {
    appData.filtersRequestBody[element] = null;
  }
  appData.filtering = false;
}

void checkFiltering(AppData appData, MarkersProvider markersProvider) {
  bool filtering = false;
  List<String> keys = appData.filtersRequestBody.keys.toList();
  Map<String, dynamic> filtersRequestBody = appData.filtersRequestBody;
  Map<String, dynamic> activeFilters = {};
  for (String key in keys) {
    if (filtersRequestBody[key] != null) {
      filtering = true;
      activeFilters[key] = filtersRequestBody[key];
    }
  }

  if (filtering) {
    markersProvider.filterStations(appData, activeFilters);
  }
}
