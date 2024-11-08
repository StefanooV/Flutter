import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/filters_screen/connector_element.dart';

class FiltersConnectorSection extends StatefulWidget {
  const FiltersConnectorSection({super.key, required this.appData});

  final AppData appData;
  @override
  State<FiltersConnectorSection> createState() =>
      _FiltersConnectorSectionState();
}

class _FiltersConnectorSectionState extends State<FiltersConnectorSection> {
  late Future<List<ChargerConnectorType>> _getConnectorsFuture;
  @override
  void initState() {
    super.initState();
    _getConnectorsFuture = HttpRequestServices().getChargerTypes(context);
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        scrollOnCollapse: true,
        scrollOnExpand: true,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              FutureBuilder<List<ChargerConnectorType>>(
                future: _getConnectorsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      widget.appData.connectors = snapshot.data!;
                      List<ChargerConnectorType> connectors =
                          widget.appData.connectors;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Expandable(
                              collapsed: GridView.count(
                                shrinkWrap: true,
                                mainAxisSpacing: 20,
                                crossAxisCount: 4,
                                children: List.generate(
                                  8,
                                  (index) => ConnectorElement(
                                    connectors: connectors,
                                    index: index,
                                    appData: widget.appData,
                                  ),
                                ),
                              ),
                              expanded: GridView.count(
                                shrinkWrap: true,
                                mainAxisSpacing: 20,
                                crossAxisCount: 4,
                                children: List.generate(
                                  connectors.length,
                                  (index) => ConnectorElement(
                                    connectors: connectors,
                                    index: index,
                                    appData: widget.appData,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text("No se pudieron obtener los conectores"),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              Builder(
                builder: (context) {
                  ExpandableController controller =
                      ExpandableController.of(context, required: true)!;
                  return TextButton(
                    onPressed: () => setState(
                      () {
                        controller.toggle();
                      },
                    ),
                    child: Text(
                      controller.expanded
                          ? "Menos conectores"
                          : "Más conectores",
                      style: const TextStyle(
                        color: AppTheme.wevePrimaryBlue,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
