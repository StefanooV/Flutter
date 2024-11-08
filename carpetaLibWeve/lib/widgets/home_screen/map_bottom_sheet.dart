import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/services/app_constants.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/shimmer_container.dart';

class MapBottomSheet extends StatefulWidget {
  final Function(double, double) onLocationSelected;
  final DraggableScrollableController draggableController;
  const MapBottomSheet({
    Key? key,
    required this.onLocationSelected,
    required this.draggableController,
  }) : super(key: key);

  @override
  State<MapBottomSheet> createState() => _MapBottomSheetState();
}

class _MapBottomSheetState extends State<MapBottomSheet>
    with WidgetsBindingObserver {
  final TextEditingController textEditingController = TextEditingController();

  // - Creamos la variable cómo "late" y después en initState le asignamos el controller.
  late DraggableScrollableController draggableController;

  // - Definimos una vez el Future, así no se redibuja cuando se actualiza el tamaño del mapa. - //
  final Future<List<SearchHistory>?> _searchHistoryFuture =
      HttpRequestServices().getUserSearchHistory();

  @override
  void initState() {
    super.initState();
    draggableController = widget.draggableController;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: draggableController,
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.8,
      snapSizes: const [0.1, 0.62, 0.8],
      snap: true,
      builder: (context, scrollController) => ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  pinned: true,
                  elevation: 0,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                    ),
                    child: PlacesTextFormField(
                      textEditingController: textEditingController,
                      onLocationSelected: widget.onLocationSelected,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => context.push("/search"),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.route,
                                  size: 18,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),
                            const Text(
                              "Trazar una ruta A - B",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      const Divider(thickness: 1),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        "Búsquedas recientes",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      FutureBuilder<List<SearchHistory>?>(
                        future: _searchHistoryFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(
                              children: List.generate(
                                3,
                                (index) {
                                  return const HistoryShimmerPlaceholder();
                                },
                              ),
                            );
                          } else {
                            if (snapshot.data == null) {
                              return const Center(
                                child: Text(
                                  "Error recuperando tu historial de búsqueda.",
                                ),
                              );
                            } else {
                              List<SearchHistory> searchHistory =
                                  snapshot.data!;
                              searchHistory =
                                  searchHistory.reversed.take(3).toList();
                              return Column(
                                children: List.generate(
                                  searchHistory.length,
                                  (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          textEditingController.text =
                                              searchHistory[index].title;
                                          double latitude =
                                              searchHistory[index].latitude;
                                          double longitude =
                                              searchHistory[index].longitude;
                                          widget.onLocationSelected(
                                              latitude, longitude);
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Center(
                                                child: Icon(Icons.history),
                                              ),
                                            ),
                                            const SizedBox(width: 18),
                                            Flexible(
                                              child: Text(
                                                searchHistory[index].title,
                                                style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          }
                        },
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            context.push("/searchHistory");
                          },
                          child: const Text("Historial de búsqueda"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryShimmerPlaceholder extends StatelessWidget {
  const HistoryShimmerPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ShimmerContainer(
            height: 60,
            width: 60,
            borderRadius: 100,
          ),
          SizedBox(
            width: 18,
          ),
          ShimmerContainer(
            height: 16,
            width: 120,
            borderRadius: 2,
          ),
        ],
      ),
    );
  }
}

class PlacesTextFormField extends StatelessWidget {
  const PlacesTextFormField({
    super.key,
    required this.textEditingController,
    required this.onLocationSelected,
  });

  final TextEditingController textEditingController;
  final Function(double, double) onLocationSelected;

  @override
  Widget build(BuildContext context) {
    return GooglePlacesAutoCompleteTextFormField(
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/logowevesintexto.png",
            width: 24,
            height: 24,
          ),
        ),
        suffixIcon: const Icon(
          Icons.search,
          size: 24,
          color: AppTheme.weveSkyBlue,
        ),
        hintText: '¿A dónde vas?',
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: const BorderSide(
            color: AppTheme.weveSkyBlue,
            width: 1.5,
          ),
        ),
      ),
      textEditingController: textEditingController,
      googleAPIKey: AppConstants.googleMapsApiKey,
      debounceTime: 600,
      countries: const ["ar"],
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: (prediction) {
        onLocationSelected(
            double.parse(prediction.lat!), double.parse(prediction.lng!));
        if (prediction.description != null) {
          textEditingController.text = prediction.description!;
        }
        print(
            "Coordinates: (${prediction.lat},${prediction.lng}, ${prediction.description})");
      },
      itmClick: (prediction) {
        // Manejar el clic en los resultados
      },
    );
  }
}
