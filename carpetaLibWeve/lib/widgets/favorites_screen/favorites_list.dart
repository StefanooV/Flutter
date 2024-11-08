import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weveapp/models/favorites_model.dart';
import 'package:weveapp/services/http_request_service.dart';
import 'package:weveapp/theme/app_theme.dart';

class FavoritesList extends StatelessWidget {
  final VoidCallback updateParent;
  final List<Result> favoritesList;
  const FavoritesList(
      {super.key, required this.updateParent, required this.favoritesList});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8,
        ),
        child: Column(
          children: List.generate(
            favoritesList.length,
            (index) => Column(
              children: [
                const SizedBox(
                  height: 4,
                ),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.chargingStation,
                        color: AppTheme.weveSkyBlue,
                        size: 25,
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.red[500],
                          size: 24,
                        ),
                        onPressed: () async {
                          await HttpRequestServices().deleteFavoriteById(
                            favoritesList[index].id,
                          );
                          updateParent();
                        },
                      ),
                      title: Text(favoritesList[index].name),
                      subtitle: Text(favoritesList[index].address),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
