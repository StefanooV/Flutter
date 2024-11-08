import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/theme/app_theme.dart';

class NearServicesSection extends StatefulWidget {
  const NearServicesSection({super.key, required this.appData});
  final AppData appData;
  @override
  State<NearServicesSection> createState() => _NearServicesSectionState();
}

class _NearServicesSectionState extends State<NearServicesSection> {
  late Future<List<FilterService>?> _getServicesFuture;
  @override
  void initState() {
    super.initState();
    _getServicesFuture = HttpRequestServices().getServicesList(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FilterService>?>(
      future: _getServicesFuture,
      builder: (context, snapshot) {
        final appData = widget.appData;
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<FilterService> services = snapshot.data!;
            return Column(
              children: List.generate(
                services.length,
                (index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Text(
                        services[index].description,
                      ),
                    ),
                    CupertinoSwitch(
                      value: appData.filterSwitches[services[index].id]!,
                      onChanged: (value) => setState(
                        () {
                          if (!appData.filtering) appData.filtering = true;
                          List<String> filtersList = [];
                          if (value == true) {
                            if (appData.filtersRequestBody["services"] !=
                                null) {
                              filtersList =
                                  appData.filtersRequestBody["services"];
                            }
                            filtersList.add(services[index].id);
                            appData.filtersRequestBody["services"] =
                                filtersList;
                            appData.filterSwitches[services[index].id] = value;
                          } else {
                            if (appData.filtersRequestBody["services"] !=
                                null) {
                              filtersList =
                                  appData.filtersRequestBody["services"];
                            }
                            filtersList.removeWhere(
                                (element) => element == services[index].id);
                            appData.filtersRequestBody["services"] =
                                filtersList;
                            List<String> servicesList =
                                appData.filtersRequestBody["services"];
                            appData.filterSwitches[services[index].id] = value;
                            if (servicesList.isEmpty) {
                              appData.filtersRequestBody["services"] = null;
                            }
                          }
                          print(
                              "Request body: ${appData.filtersRequestBody.toString()}");
                        },
                      ),
                      activeColor: AppTheme.weveSkyBlue,
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("No se pudieron obtener los servicios!"),
            );
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
