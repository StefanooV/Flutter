import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weveapp/models/country_model.dart';
import 'package:weveapp/models/driver_user_model.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/widgets.dart';

import '../../providers/country_provider.dart';
import '../../providers/firebase_login_provider.dart';

class DriverPersonalInformation extends StatefulWidget {
  const DriverPersonalInformation({Key? key}) : super(key: key);

  @override
  State<DriverPersonalInformation> createState() =>
      _DriverPersonalInformation();
}

class _DriverPersonalInformation extends State<DriverPersonalInformation> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bornDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (defaultTargetPlatform == TargetPlatform.android) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.transparent));
        }
      },
    );
    final dataProvider = Provider.of<AppData>(context, listen: false);
    dataProvider.getDriverUserById();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countryService = Provider.of<CountryService>(context, listen: false);
    final dataProvider = Provider.of<AppData>(context, listen: true);
    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
    if (dataProvider.driverUser != null) {
      _bornDateController.text =
          DateFormat('dd/MM/yyyy').format(dataProvider.driverUser!.bornDate);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Información personal",
          style: TextStyle(fontFamily: "Montserrat"),
        ),
      ),
      body: dataProvider.driverUser != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Form(
                key: myFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: List(dataProvider, countryService, context),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Text(
                            "Guardar Cambios",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await updateDriverUserInfo(dataProvider);
                          await dataProvider.getDriverUserById();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Cambios guardados!",
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppTheme.wevePrimaryBlue,
                              duration: Duration(seconds: 5),
                              dismissDirection: DismissDirection.down,
                            ),
                          );
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> updateDriverUserInfo(AppData dataProvider) async {
    if (dataProvider.driverUserData['userName'] != null) {
      await FirebaseAuth.instance.currentUser
          ?.updateDisplayName(dataProvider.driverUserData['userName']);
    }
    if (dataProvider.driverUserUpdateBody['email'] != null) {
      await FirebaseAuth.instance.currentUser
          ?.updateEmail(dataProvider.driverUserUpdateBody['email']!);
    }
    await HttpRequestServices()
        .updateDriverUser(dataProvider.driverUserUpdateBody);
  }

  ListView List(AppData dataProvider, CountryService countryService,
      BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        const Center(
          child: Text("INFORMACIÓN DE LA CUENTA",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                  fontSize: 18)),
        ),
        const SizedBox(height: 15),
        //NOMBRE DE USUARIO
        const FormTitle(text: "Nombre de usuario"),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: FirebaseAuth.instance.currentUser?.displayName,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            hintText: "Ingresá tu nombre de usuario",
          ),
          onChanged: (value) => dataProvider.driverUserData["userName"] = value,
        ),
        const SizedBox(height: 15),
        const Center(
          child: Text("INFORMACIÓN PERSONAL",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                  fontSize: 18)),
        ),
        const SizedBox(height: 20),
        //NOMBRE
        const FormTitle(text: "Nombre"),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: dataProvider.driverUser!.name,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            hintText: "Ingresá tu nombre",
          ),
          onChanged: (value) =>
              dataProvider.driverUserUpdateBody["name"] = value,
        ),
        const SizedBox(height: 15),
        //APELLIDO
        const FormTitle(text: "Apellido"),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: dataProvider.driverUser!.lastName,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            hintText: "Ingresá tu apellido",
          ),
          onChanged: (value) =>
              dataProvider.driverUserUpdateBody["lastName"] = value,
        ),
        const SizedBox(height: 15),
        //EMAIL
        const FormTitle(text: "E-mail"),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: dataProvider.driverUser?.email,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            hintText: "Ingresá tu email",
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    "Deberás confirmar el cambio de e-mail desde tu correo!"),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppTheme.wevePrimaryBlue,
                duration: Duration(seconds: 5),
                dismissDirection: DismissDirection.down,
              ),
            );
          },
          onChanged: (value) =>
              dataProvider.driverUserUpdateBody["email"] = value,
        ),
        //TELÉFONO
        const SizedBox(height: 15),
        const FormTitle(text: "Número de teléfono"),
        const SizedBox(height: 5),
        TextFormField(
          key:
              Key("+${countryService.countryData['phone_code'].toLowerCase()}"),
          initialValue: dataProvider.driverUser?.phoneNumber?.isEmpty == true
              ? "+${countryService.countryData['phone_code'].toLowerCase()}"
                  .toString()
              : dataProvider.driverUser?.phoneNumber,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              prefixIcon: Container(
                width: 60,
                child: InkWell(
                  onTap: () => context.push("/selectCountry").then(
                    (_) {
                      setState(() {
                        dataProvider.driverUser!.clearPhone();
                      });
                    },
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Image.asset(
                          'assets/flags/${countryService.countryData['iso2'].toLowerCase()}.png',
                          width: 25,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
              )),
          onChanged: (newValue) =>
              dataProvider.driverUserUpdateBody["phoneNumber"] = newValue,
        ),
        const SizedBox(height: 15),
        //CIUDAD
        const FormTitle(text: "Ciudad"),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: dataProvider.driverUser!.city,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            hintText: "Ingresá tu ciudad",
          ),
          onChanged: (value) =>
              dataProvider.driverUserUpdateBody["city"] = value,
        ),
        const SizedBox(height: 15),
        //PAIS
        const FormTitle(text: "País"),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: dataProvider.driverUser!.country,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            hintText: "Ingresá tu país",
          ),
          onChanged: (value) =>
              dataProvider.driverUserUpdateBody["country"] = value,
        ),
        //FECHA DE NACIMIENTO
        const SizedBox(height: 15),
        const FormTitle(text: "Fecha de nacimiento"),
        const SizedBox(height: 5),
        TextFormField(
          controller: _bornDateController,
          readOnly: true,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            hintText: "Fecha de nacimiento",
          ),
          onTap: Platform.isAndroid
              ? () {
                  selectedDate = dataProvider.driverUser!.bornDate;
                  _selectDate(context, dataProvider);
                }
              : () {
                  selectedDate = dataProvider.driverUser!.bornDate;
                  _iosSelectDate(context, dataProvider);
                },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Future<void> _iosSelectDate(
      BuildContext context, AppData dataProvider) async {
    DateTime selectedDate = dataProvider.driverUser!.bornDate;
    await showModalBottomSheet<DateTime>(
        context: context,
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar"),
                  ),
                  const Text("Fecha de nacimiento"),
                  CupertinoButton(
                    onPressed: () {
                      _bornDateController.text =
                          DateFormat('dd/MM/yyyy').format(selectedDate);
                      dataProvider.driverUserUpdateBody['bornDate'] =
                          selectedDate.toString();
                      Navigator.pop(context);
                    },
                    child: const Text("Confirmar"),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: dataProvider.driverUser!.bornDate,
                  minimumYear: 1925,
                  maximumYear: DateTime.now().year,
                  onDateTimeChanged: (DateTime newDate) {
                    selectedDate = newDate;
                  },
                ),
              ),
            ],
          );
        });
  }

  Future<void> _selectDate(BuildContext context, AppData dataProvider) async {
    try {
      final DateTime? picked = await showDatePicker(
          locale: const Locale('es', 'AR'),
          context: context,
          initialDate: dataProvider.driverUser!.bornDate,
          firstDate: DateTime(1925),
          lastDate: DateTime.now());
      if (picked != null && picked != selectedDate) {
        _bornDateController.text = DateFormat('dd/MM/yyyy').format(picked);
        dataProvider.driverUserUpdateBody['bornDate'] = picked.toString();
        print(
            "elegido en body ${dataProvider.driverUserUpdateBody['bornDate']}");
      }
    } catch (err) {
      print("error date $err");
    }
  }
}
