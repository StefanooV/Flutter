import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/widgets/widgets.dart';

class StationBottomSheet extends StatefulWidget {
  final ChargingStation station;
  final double multiplier;
  const StationBottomSheet(
      {super.key, required this.station, required this.multiplier});

  @override
  State<StationBottomSheet> createState() => _StationBottomSheetState();
}

class _StationBottomSheetState extends State<StationBottomSheet>
    with TickerProviderStateMixin {
  late DraggableScrollableController _draggableScrollableController;
  late CarouselController _carouselController;
  late TabController _tabController;
  bool expanded = false;
  late AppData appData;
  late List<StationConnector> stationConnectors;

  @override
  void initState() {
    super.initState();
    _draggableScrollableController = DraggableScrollableController();
    _carouselController = CarouselController();
    _tabController = TabController(length: 3, vsync: this);
    appData = Provider.of<AppData>(context, listen: false);
    stationConnectors = widget.station.getConnectorsSummary();
    print("Esta es la estación: ${(widget.station.toJson()).toString()}");
  }

  void setExpansionState(bool state) {
    appData.setSheetExpansionState(state);
  }

  void expandSheet(ScrollController scrollController) {
    setExpansionState(true);
    _draggableScrollableController.animateTo(
      0.9,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeIn,
    );
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    appData = Provider.of<AppData>(context, listen: true);

    print("menú redibujado");
    List<AvailabilityOnTheDay> chargerAvailability =
        orderList(widget.station.schedule.availabilityOnTheDay);
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (DraggableScrollableNotification dsNotification) {
        if (dsNotification.extent > 0.75) {
          setExpansionState(true);
        } else {
          setExpansionState(false);
        }

        print("Notification: ${dsNotification.extent}");
        return true;
      },
      child: DraggableScrollableSheet(
        expand: false,
        controller: _draggableScrollableController,
        maxChildSize: 0.9,
        minChildSize: widget.multiplier - 0.2,
        initialChildSize: widget.multiplier,
        snap: true,
        shouldCloseOnMinExtent: true,
        snapSizes: <double>[widget.multiplier, 0.9],
        builder: (context, scrollController) => Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              color: Colors.white,
            ),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              slivers: [
                if (widget.station.imagesLink.isNotEmpty)
                  SliverAppBar(
                    expandedHeight: 200,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: CarouselSlider.builder(
                              carouselController: _carouselController,
                              itemCount: widget.station.imagesLink.length,
                              disableGesture: false,
                              itemBuilder: (context, index, realIndex) {
                                return InkWell(
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Center(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: widget
                                                  .station.imagesLink[index],
                                              placeholder: (context, url) =>
                                                  ShimmerContainer(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    2,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    2,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fill,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          widget.station.imagesLink[index],
                                      placeholder: (context, url) =>
                                          ShimmerContainer(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                viewportFraction: 1,
                              ),
                            ),
                          ),
                          if (widget.station.imagesLink.length > 1)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      splashColor: Colors.transparent,
                                      onPressed: () =>
                                          _carouselController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 100),
                                        curve: Curves.fastOutSlowIn,
                                      ),
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      splashColor: Colors.transparent,
                                      onPressed: () =>
                                          _carouselController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 100),
                                        curve: Curves.fastOutSlowIn,
                                      ),
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.station.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              widget.station.locationName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      if (stationConnectors.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: NoConnectorsContainer(),
                        ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(0),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(
                              stationConnectors.length,
                              (index) => ChargerConnector(
                                stationConnector: stationConnectors[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GotoButton(station: widget.station),
                          FutureBuilder<bool>(
                            future: HttpRequestServices()
                                .checkFavorite(widget.station.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.data! == false) {
                                  return Column(
                                    children: [
                                      OutlinedButton(
                                        onPressed: () async {
                                          print("tapeado pa");
                                          await HttpRequestServices()
                                              .addNewFavorite(
                                                  widget.station.id, context);
                                          setState((() {}));
                                        },
                                        style: OutlinedButton.styleFrom(
                                          shape: const CircleBorder(),
                                          padding: const EdgeInsets.all(12),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.favorite_border_rounded,
                                            color:
                                                Color.fromARGB(255, 40, 40, 40),
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        "Añadir a\nfavoritos",
                                        style:
                                            TextStyle(fontFamily: "Montserrat"),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      OutlinedButton(
                                        onPressed: () async {
                                          print("tapeado pa");
                                          await HttpRequestServices()
                                              .deleteFavoriteByStationId(
                                                  widget.station.id);
                                          setState(() {});
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: const CircleBorder(),
                                          padding: const EdgeInsets.all(12),
                                        ),
                                        child: const Center(
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.favorite,
                                                color: Colors.white,
                                                size: 22,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        "Eliminar de\nfavoritos",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              } else {
                                return Column(
                                  children: [
                                    OutlinedButton(
                                      onPressed: null,
                                      style: OutlinedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(12),
                                      ),
                                      child: const Center(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.favorite_border_rounded,
                                              color: Color.fromARGB(
                                                  255, 40, 40, 40),
                                              size: 22,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: Text(
                                        "Cargando\n",
                                        style:
                                            TextStyle(fontFamily: "Montserrat"),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          ShareButton(
                            station: widget.station,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      TabBar(
                        controller: _tabController,
                        tabs: [
                          InkWell(
                            onTap: () {
                              if (!expanded) {
                                expandSheet(scrollController);
                              }

                              _tabController.animateTo(0);
                            },
                            child: const Tab(
                              child: AutoSizeText(
                                maxLines: 1,
                                maxFontSize: 16,
                                minFontSize: 8,
                                "INFORMACIÓN",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (!expanded) {
                                expandSheet(scrollController);
                              }
                              _tabController.animateTo(1);
                            },
                            child: const Tab(
                              child: AutoSizeText(
                                maxLines: 1,
                                maxFontSize: 16,
                                minFontSize: 8,
                                "CONECTORES",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (!expanded) {
                                expandSheet(scrollController);
                              }
                              _tabController.animateTo(2);
                            },
                            child: const Tab(
                              child: AutoSizeText(
                                maxLines: 1,
                                maxFontSize: 16,
                                minFontSize: 8,
                                "OPINIONES",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: TabBarView(
                            physics: const BouncingScrollPhysics(),
                            controller: _tabController,
                            children: [
                              InformationSection(
                                widget: widget,
                                chargerAvailability: chargerAvailability,
                              ),
                              ConnectorSection(
                                connectors: stationConnectors,
                                station: widget.station,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Center(
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            "assets/images/opinionsection.png"),
                                        const Text.rich(
                                          textAlign: TextAlign.center,
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    "Pronto podrás ver las opiniones de otros usuarios",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
