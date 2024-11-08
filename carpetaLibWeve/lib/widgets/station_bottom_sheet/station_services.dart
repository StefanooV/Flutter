import 'package:flutter/material.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/widgets/widgets.dart';

class StationServices extends StatelessWidget {
  const StationServices({
    super.key,
    required this.station,
  });

  final ChargingStation station;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const InformationSectionText(
            title: "Servicios: ",
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  station.service.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(
                      right: 12,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Icon(
                            getServiceIcon(
                              station.service[index].description,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

IconData getServiceIcon(String serviceDescription) {
  switch (serviceDescription) {
    case "Hotel/Alojamiento":
      return Icons.hotel_outlined;
    case "Restaurante":
      return Icons.restaurant_outlined;
    case "Centro comercial":
      return Icons.shopping_bag_outlined;
    case "Atracción turística":
      return Icons.attractions_outlined;
    case "Estación de servicio":
      return Icons.local_gas_station_outlined;
    case "Aeropuerto":
      return Icons.local_airport_outlined;
  }
  return Icons.error_outline;
}
