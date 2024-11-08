import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/providers/switches_provider.dart';

class SearchHistoryElement extends StatelessWidget {
  final VoidCallback? updateParent;
  final String origin;
  final TextEditingController destinationController;
  final SearchHistory searchHistoryElement;
  final AppData? navigationDataProvider;
  const SearchHistoryElement({
    super.key,
    required this.updateParent,
    required this.origin,
    required this.destinationController,
    required this.searchHistoryElement,
    this.navigationDataProvider,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: origin == "SearchScreen"
            ? () {
                navigationDataProvider!.setPointData(
                  "destination",
                  searchHistoryElement.title,
                  LatLng(
                    searchHistoryElement.latitude,
                    searchHistoryElement.longitude,
                  ),
                );
                destinationController.text = searchHistoryElement.title;
                updateParent;
              }
            : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(100, 157, 157, 157),
              ),
              child: const Icon(
                Icons.history_outlined,
                size: 20,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
                child: Text(
                  softWrap: false,
                  searchHistoryElement.title,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
