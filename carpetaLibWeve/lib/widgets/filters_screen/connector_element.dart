import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/theme/app_theme.dart';

class ConnectorElement extends StatefulWidget {
  const ConnectorElement(
      {super.key,
      required this.connectors,
      required this.index,
      required this.appData});
  final AppData appData;
  final int index;
  final List<ChargerConnectorType> connectors;
  final Color nonSelectedColor = const Color.fromRGBO(255, 255, 255, 0.5);
  final Color selectedColor = const Color.fromRGBO(255, 255, 255, 1);

  @override
  State<ConnectorElement> createState() => _ConnectorElementState();
}

class _ConnectorElementState extends State<ConnectorElement> {
  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context, listen: false);

    ChargerConnectorType connector = widget.connectors[widget.index];
    return InkWell(
      onTap: () => setState(
        () {
          if (widget.connectors[widget.index].status == false) {
            List<String> connectors = [];
            if (appData.filtersRequestBody["connectorId"] != null) {
              connectors = appData.filtersRequestBody["connectorId"];
            }
            connectors.add(widget.connectors[widget.index].id);
            appData.filtersRequestBody["connectorId"] = connectors;
            widget.connectors[widget.index].status = true;
          } else {
            List<String> connectors = appData.filtersRequestBody["connectorId"];
            connectors.removeWhere((element) => element == connector.id);
            appData.filtersRequestBody["connectorId"] = connectors;
            connectors = appData.filtersRequestBody["connectorId"];

            if (connectors.isEmpty) {
              appData.filtersRequestBody["connectorId"] = null;
            }
            widget.connectors[widget.index].status = false;
          }
          print("Request body: ${appData.filtersRequestBody}");
        },
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (connector.status)
            const Align(
              alignment: Alignment.topRight,
              child: Icon(
                CupertinoIcons.checkmark_square_fill,
                color: AppTheme.weveSkyBlue,
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 65,
                height: 70,
                child: Image.network(
                  connector.imageLink,
                  color: connector.status
                      ? widget.selectedColor
                      : widget.nonSelectedColor,
                  colorBlendMode: BlendMode.modulate,
                ),
              ),
              Expanded(
                child: Text(
                  connector.description,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
