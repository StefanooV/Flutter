import 'package:flutter/material.dart';
import 'package:weveapp/models/favorites_model.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/widgets/widgets.dart';

class DriverMyFavoritesScreen extends StatefulWidget {
  const DriverMyFavoritesScreen({Key? key}) : super(key: key);

  @override
  State<DriverMyFavoritesScreen> createState() =>
      _DriverMyFavoritesScreenState();
}

class _DriverMyFavoritesScreenState extends State<DriverMyFavoritesScreen> {
  late Future<List<Result>?> _favoritesFuture;
  @override
  void initState() {
    super.initState();
    _favoritesFuture = HttpRequestServices().getUserFavorites();
  }

  void updateList() {
    setState(() {
      _favoritesFuture = HttpRequestServices().getUserFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Mis favoritos",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
      ),
      body: FutureBuilder<List<Result>?>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null) {
              List<Result> favoritesList = snapshot.data!;
              if (favoritesList.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      HttpRequestServices().getFillerImageUrl("MyFavorites"),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Todavía no has sumado ninguna\nestación a tus favoritos",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Agrégalas para tenerlas siempre a mano",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                );
              } else {
                return FavoritesList(
                  updateParent: updateList,
                  favoritesList: favoritesList,
                );
              }
            } else {
              return Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage("assets/images/connerr.png"),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Oops!\nAlgo salió mal",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                          fontFamily: "Montserrat",
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Column(
              children: List.generate(
                6,
                (index) => Column(
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    ShimmerContainer(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
