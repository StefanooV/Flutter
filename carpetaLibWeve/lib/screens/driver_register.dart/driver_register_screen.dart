// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weveapp/helper/helper.dart';
import 'package:weveapp/services/auth_service.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/widgets.dart';

class DriverRegisterScreen extends StatefulWidget {
  const DriverRegisterScreen({super.key});

  @override
  State<DriverRegisterScreen> createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends State<DriverRegisterScreen> {
  late GlobalKey<FormState> formKey;
  late ScrollController scrollController;
  late Future<String> errorMessageFuture;
  late final MaterialStatesController _materialStatesController;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    scrollController = ScrollController();
    _materialStatesController = MaterialStatesController();
  }

  void setLoadingState(bool newState) {
    setState(() {
      loading = newState;
    });
  }

  Map<String, String> formValues = {
    "name": "",
    "lastName": "",
    "email": "",
    "phone": "",
    "password": "",
  };
  String? emailErrorText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Registro conductor",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Comenzá a crear tu cuenta",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 22,
                    width: 22,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: AppTheme.wevePrimaryBlue,
                      ),
                    ),
                    child: const Material(
                      color: AppTheme.wevePrimaryBlue,
                      shape: CircleBorder(),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  Container(
                    height: 22,
                    width: 22,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: AppTheme.wevePrimaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FormTitle(text: "Nombre"),
                        TextForm(
                          hintText: "Ingresá tu nombre",
                          fieldContent: "nombre",
                          fieldName: "name",
                          formValues: formValues,
                        ),
                        const SizedBox(height: 24),
                        const FormTitle(text: "Apellido"),
                        TextForm(
                          hintText: "Ingresá tu apellido",
                          fieldContent: "apellido",
                          fieldName: "lastName",
                          formValues: formValues,
                        ),
                        const SizedBox(height: 24),
                        const FormTitle(text: "E-mail"),
                        EmailForm(
                          hintText: "Ingresá tu e-mail",
                          fieldName: "email",
                          formValues: formValues,
                          errorText: emailErrorText,
                        ),
                        const SizedBox(height: 24),
                        const FormTitle(text: "Número de teléfono"),
                        PhoneForm(
                          fieldName: "phone",
                          formValues: formValues,
                        ),
                        const SizedBox(height: 24),
                        const FormTitle(text: "Contraseña"),
                        PasswordForm(
                          hintText: "Creá una contraseña",
                          fieldName: "password",
                          formValues: formValues,
                        ),
                        const SizedBox(height: 24),
                        const FormTitle(text: "Repetir contraseña"),
                        PasswordForm(
                          hintText: "Repetí la contraseña",
                          formValues: formValues,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  statesController: _materialStatesController,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return AppTheme.weveSkyBlue;
                      }
                      return AppTheme.weveSkyBlue;
                    }),
                  ),
                  onPressed: loading
                      ? () {}
                      : () async {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          emailErrorText = null;
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          _materialStatesController.update(
                              MaterialState.disabled, true);
                          setLoadingState(true);
                          if (formKey.currentState!.validate()) {
                            String? firebaseError =
                                await AuthService().registerNewUserWithEmail(
                              formValues["email"]!,
                              formValues["password"]!,
                              formValues["name"]!,
                              formValues["lastName"]!,
                            );
                            if (firebaseError != null) {
                              setState(() {
                                emailErrorText = Helper()
                                    .handleFirebaseExMessage(firebaseError);
                                if (emailErrorText == "") {
                                  emailErrorText = "Error desconocido";
                                }
                              });
                              setLoadingState(false);
                              _materialStatesController.update(
                                  MaterialState.disabled, false);
                            } else {
                              await AuthService().logInBackend(
                                FirebaseAuth.instance.currentUser!.uid,
                                formValues["email"]!,
                                context,
                              );
                              context.go(
                                "/registerFinish?displayName=${formValues["name"]}",
                              );
                            }
                          }
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    child: loading == false
                        ? const Text(
                            "Siguiente",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          )
                        : const SizedBox(
                            height: 18,
                            width: 18,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
