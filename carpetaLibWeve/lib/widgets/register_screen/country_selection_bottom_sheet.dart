import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weveapp/models/models.dart';

class CountrySelectionBottomSheet extends StatefulWidget {
  const CountrySelectionBottomSheet({super.key});

  @override
  State<CountrySelectionBottomSheet> createState() =>
      _CountrySelectionBottomSheetState();
}

class _CountrySelectionBottomSheetState
    extends State<CountrySelectionBottomSheet> {
  List<Country> countryList = [];
  @override
  void initState() {
    super.initState();
    if (mounted) countryList = parseCountries();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Selecciona tu país",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: countryList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(
                    'assets/flags/${countryList[index].iso2.toLowerCase()}.png',
                    width: 35,
                  ),
                  title: Text(
                      "${countryList[index].nombre} • (+${countryList[index].phoneCode})"),
                  onTap: () {
                    CountrySelection countrySelection = CountrySelection(
                      flagString: countryList[index].iso2,
                      phoneCode: "+${countryList[index].phoneCode}",
                    );
                    context.pop(countrySelection);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
