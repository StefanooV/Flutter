import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:weveapp/models/favorites_model.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/theme/app_theme.dart';

class FavoriteCard extends StatefulWidget {
  const FavoriteCard({
    Key? key,
  }) : super(key: key);

  @override
  State<FavoriteCard> createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<FavoriteCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Result>?>(
      future: HttpRequestServices().getUserFavorites(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: NetworkImage(
                      HttpRequestServices().getFillerImageUrl("MyFavorites"),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Todavía no has sumado ninguna estación a tus favoritos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w200,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Agrégalas para tenerlas siempre a mano",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w200,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ),
                ],
              );
            }
            if (snapshot.data!.isNotEmpty) {
              final favoritesList = snapshot.data;
              return Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: List.generate(
                    favoritesList!.length,
                    (index) => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: const FaIcon(
                              FontAwesomeIcons.chargingStation,
                              color: AppTheme.weveSkyBlue,
                              size: 25),
                          title: Text(favoritesList[index].name),
                          subtitle: Text(
                            favoritesList[index].address,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              await HttpRequestServices()
                                  .deleteFavoriteById(favoritesList[index].id);
                              setState(() {});
                            },
                            icon: const Icon(Icons.favorite,
                                color: Colors.red, size: 25),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(120),
              child: LoadingIndicator(
                indicatorType: Indicator.ballPulseSync,
                colors: AppTheme.colorsCollection,
              ),
            ),
          );
        } else {
          return const Center(
            child: Text("Error recuperando tus favoritos."),
          );
        }
      },
    );
  }
}
