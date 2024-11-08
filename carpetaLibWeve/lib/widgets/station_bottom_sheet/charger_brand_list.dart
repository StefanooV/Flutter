import 'package:flutter/material.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/widgets/widgets.dart';

class ChargerBrandList extends StatelessWidget {
  final ChargingStation station;
  const ChargerBrandList({
    super.key,
    required this.station,
  });

  Map<String, ChargerBrandElement> groupBrands() {
    Map<String, ChargerBrandElement> chargerBrands = {};
    for (Charger charger in station.chargers) {
      if (chargerBrands[charger.chargerBrandId] == null) {
        ChargerBrandElement newElement = ChargerBrandElement(
            description: charger.chargerBrandDescription, quantity: 1);
        chargerBrands[charger.chargerBrandId] = newElement;
      } else {
        chargerBrands[charger.chargerBrandId]!.quantity++;
      }
    }

    return chargerBrands;
  }

  @override
  Widget build(BuildContext context) {
    if (station.chargers.isNotEmpty) {}
    Map<String, ChargerBrandElement> chargerBrands = groupBrands();
    List<String> keys = chargerBrands.keys.toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const InformationSectionText(title: "Marca cargadores: "),
        SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(
              keys.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Chip(
                  backgroundColor: Colors.grey[200],
                  label: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Text(
                      chargerBrands[keys[index]]!.quantity == 1
                          ? chargerBrands[keys[index]]!.description
                          : "${chargerBrands[keys[index]]!.description} x${chargerBrands[keys[index]]!.quantity}",
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChargerBrandElement {
  String description;
  int quantity;
  ChargerBrandElement({
    required this.description,
    required this.quantity,
  });
}
