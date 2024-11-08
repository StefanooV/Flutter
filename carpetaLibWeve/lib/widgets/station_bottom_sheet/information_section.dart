import 'package:flutter/material.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/widgets/widgets.dart';

class InformationSection extends StatelessWidget {
  const InformationSection({
    super.key,
    required this.widget,
    required this.chargerAvailability,
  });

  final StationBottomSheet widget;
  final List<AvailabilityOnTheDay> chargerAvailability;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            InformationSectionText(
              title: "Dirección: ",
              text: widget.station.locationAddress,
            ),
            const SizedBox(
              height: 8,
            ),
            InformationSectionText(
              title: "Ubicación específica: ",
              text: widget.station.internalLocation,
            ),
            const SizedBox(
              height: 8,
            ),
            Availability(
              chargerAvailability: chargerAvailability,
            ),
            if (widget.station.chargers.isNotEmpty)
              ChargerBrandList(
                station: widget.station,
              ),
            const SizedBox(
              height: 8,
            ),
            if (widget.station.additionalInformation != null)
              InformationSectionText(
                title: "Observaciones: ",
                text: widget.station.additionalInformation,
              ),
            const SizedBox(
              height: 8,
            ),
            InformationSectionText(
              title: "Forma de uso: ",
              text: widget.station.isFree ? "Gratuito" : "De pago",
            ),
            const SizedBox(
              height: 8,
            ),
            StationServices(
              station: widget.station,
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ],
    );
  }
}
