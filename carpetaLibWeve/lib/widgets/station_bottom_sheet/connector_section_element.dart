import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weveapp/widgets/widgets.dart';

class ConnectorElement extends StatelessWidget {
  const ConnectorElement({
    super.key,
    required this.connectorId,
    required this.connectorDescription,
    required this.connectorPower,
    required this.connectorCount,
  });

  final String connectorId;
  final String connectorDescription;
  final String connectorPower;
  final int connectorCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: CachedNetworkImage(
            imageUrl:
                "https://media.wevemobility.com/charger-connector-type-images/$connectorId.png",
            progressIndicatorBuilder: (context, url, progress) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: ShimmerContainer(
                  height: 50,
                  width: 50,
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                connectorDescription,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$connectorPower kW",
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              "x$connectorCount",
            ),
          ),
        ),
      ],
    );
  }
}
