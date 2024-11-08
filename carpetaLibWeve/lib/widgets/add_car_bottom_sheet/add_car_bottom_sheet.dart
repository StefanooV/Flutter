import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/widgets/widgets.dart';

class AddCarBottomSheet extends StatefulWidget {
  final double multiplier;
  final BuildContext sheetContext;
  final bool isRegistering;
  const AddCarBottomSheet({
    super.key,
    required this.multiplier,
    required this.sheetContext,
    required this.isRegistering,
  });

  @override
  State<AddCarBottomSheet> createState() => _AddCarBottomSheetState();
}

class _AddCarBottomSheetState extends State<AddCarBottomSheet> {
  late Future<List<VehicleBrand>?> _vehicleBrandFuture;
  bool connectionError = false;
  @override
  void initState() {
    super.initState();
    _vehicleBrandFuture = HttpRequestServices().getCarBrands();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * widget.multiplier,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Añade tu vehículo",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<List<VehicleBrand>?>(
              future: _vehicleBrandFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        connectionError = true;
                      });
                    });
                    return const Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage("assets/images/connerr.png"),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Oops!\nAlgo salió mal",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    List<VehicleBrand> vehicleBrandsList = snapshot.data!;
                    List<DropdownMenuItem<String>> brandsListDescription = [];

                    for (var element in vehicleBrandsList) {
                      brandsListDescription.add(
                        DropdownMenuItem(
                          value: element.description,
                          child: Text(element.description),
                        ),
                      );
                    }
                    return Expanded(
                      child: SelectBrandDropdown(
                        vehiclesBrandList: vehicleBrandsList,
                        brandsListDescription: brandsListDescription,
                        sheetContext: widget.sheetContext,
                        isRegistering: widget.isRegistering,
                      ),
                    );
                  }
                } else {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: ShimmerContainer(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        borderRadius: 8,
                      ),
                    ),
                  );
                }
              },
            ),
            Visibility(
              visible: connectionError,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => widget.sheetContext.pop(),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    child: Text(
                      "Volver",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
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
