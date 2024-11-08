import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/search_location.dart';
import 'package:weveapp/widgets/widgets.dart';
import 'package:weveapp/screens/screens.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  late Future<List<SearchHistory>?> _searchHistoryFuture;

  @override
  void initState() {
    super.initState();
    _searchHistoryFuture = HttpRequestServices().getUserSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    final navigationDataProvider = Provider.of<AppData>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 6, 8, 16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () => context.push("/"),
                                    icon: const Icon(Icons.arrow_back),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.go("/");
                                    },
                                    icon: const Icon(Icons.close),
                                  )
                                ],
                              ),
                              SearchLocation(
                                originController: originController,
                                destinationController: destinationController,
                              ),
                              const SizedBox(
                                height: 36,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, left: 48),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (Platform.isAndroid) {
                                        final mapsLauncherUrl = Uri.https(
                                          'www.google.com',
                                          '/maps/dir/',
                                          {
                                            'api': '1',
                                            'origin':
                                                '${navigationDataProvider.startNavigationData['latitude']},${navigationDataProvider.startNavigationData['longitude']}',
                                            'destination':
                                                '${navigationDataProvider.destinationNavigationData['latitude']},${navigationDataProvider.destinationNavigationData['longitude']}',
                                            'travelmode': 'driving',
                                            'units': 'metric',
                                          },
                                        );

                                        print(
                                            "Url google maps $mapsLauncherUrl , destino ${navigationDataProvider.destinationNavigationData},  inicio ${navigationDataProvider.startNavigationData}");
                                        try {
                                          await launchUrl(mapsLauncherUrl,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        } catch (err) {
                                          print("error de la url $err ");
                                        }
                                      }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.directions,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Ir",
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, left: 48),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(
                                        width: 2,
                                        color: AppTheme.weveSkyBlue,
                                      ),
                                    ),
                                    onPressed: () {
                                      _onFiltersButtonPressed();
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.tune,
                                            color: AppTheme.weveSkyBlue,
                                          ),
                                          Text(
                                            "Ver filtros",
                                            style: TextStyle(
                                              fontFamily: "Montserrat",
                                              color: AppTheme.weveSkyBlue,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    FutureBuilder<List<SearchHistory>?>(
                      future: _searchHistoryFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data == null) {
                            return const SizedBox.shrink();
                          } else {
                            List<SearchHistory> searchHistory =
                                snapshot.data!.reversed.toList();
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SearchTitle(
                                          text: "Búsquedas recientes",
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        ListView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          children: List.generate(
                                            searchHistory.length,
                                            (index) {
                                              return Column(
                                                children: [
                                                  SearchHistoryElement(
                                                    searchHistoryElement:
                                                        searchHistory[index],
                                                    destinationController:
                                                        destinationController,
                                                    updateParent: () =>
                                                        setState(() {}),
                                                    navigationDataProvider:
                                                        navigationDataProvider,
                                                    origin: "SearchScreen",
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFiltersButtonPressed() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (context) =>
          const Padding(padding: EdgeInsets.all(2.0), child: SelectFilters()),
    );
  }
}
