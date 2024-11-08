import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/widgets/widgets.dart';

class ChargerConnector extends StatelessWidget {
  final StationConnector stationConnector;
  const ChargerConnector({
    super.key,
    required this.stationConnector,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Container(
        height: 60,
        width: 140,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CachedNetworkImage(
                imageUrl:
                    "https://media.wevemobility.com/charger-connector-type-images/${stationConnector.id}.png",
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
                    stationConnector.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${stationConnector.power} kW",
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text("x${stationConnector.total}"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
