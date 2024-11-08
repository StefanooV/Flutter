// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:weveapp/helper/helper.dart';
import 'package:weveapp/screens/router/app_routes.dart';
import 'package:weveapp/services/auth_service.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  final bool? deepLinkAccess;
  final double? latitude;
  final double? longitude;

  const LoginScreen({
    super.key,
    this.deepLinkAccess,
    this.latitude,
    this.longitude,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late GlobalKey<FormState> loginFormKey;
  Map<String, String> formValues = {
    "email": "",
    "password": "",
  };
  String? emailErrorText;
  String? passwordErrorText;
  bool loading = false;
  late final MaterialStatesController _materialStatesController;

  @override
  void initState() {
    super.initState();
    loginFormKey = GlobalKey<FormState>();
    _materialStatesController = MaterialStatesController();
  }

  void setLoadingState(bool newState) {
    setState(() {
      loading = newState;
    });
    print("acá");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 90,
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/logowevesintexto.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    "Te damos la bienvenida a Weve",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sos nuevo?",
                        style: TextStyle(
                            color: Colors.grey[400], fontFamily: "Montserrat"),
                      ),
                      TextButton(
                        onPressed: () => context.push("/driverRegister"),
                        child: const Text(
                          "Creá una cuenta",
                          style: TextStyle(
                              color: AppTheme.weveSkyBlue,
                              fontFamily: "Montserrat"),
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        const FormTitle(text: "E-mail"),
                        EmailForm(
                          hintText: "Ingresá tu e-mail",
                          fieldName: "email",
                          formValues: formValues,
                          errorText: emailErrorText,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const FormTitle(text: "Contraseña"),
                            InkWell(
                              onTap: () => context.push("/passwordRecovery"),
                              child: const Text(
                                "Olvidaste tu contraseña?",
                                style: TextStyle(
                                  color: AppTheme.weveSkyBlue,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                            ),
                          ],
                        ),
                        PasswordForm(
                          hintText: "Ingresá tu contraseña",
                          fieldName: "password",
                          formValues: formValues,
                          errorText: passwordErrorText,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        statesController: _materialStatesController,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) {
                            if (states.contains(MaterialState.disabled)) {
                              return AppTheme.weveSkyBlue;
                            }
                            return AppTheme.weveSkyBlue;
                          }),
                        ),
                        onPressed: loading
                            ? () {}
                            : () async {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                emailErrorText = null;
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                _materialStatesController.update(
                                    MaterialState.disabled, true);
                                setLoadingState(true);
                                if (loginFormKey.currentState!.validate()) {
                                  String? firebaseError =
                                      await AuthService().signInWithEmail(
                                    formValues["email"]!,
                                    formValues["password"]!,
                                    context,
                                    widget.deepLinkAccess,
                                    widget.latitude,
                                    widget.longitude,
                                  );
                                  if (firebaseError != null) {
                                    setState(
                                      () {
                                        emailErrorText = Helper()
                                            .handleFirebaseExMessage(
                                                firebaseError);
                                        if (emailErrorText == "") {
                                          emailErrorText = "Error desconocido";
                                        }
                                        if (emailErrorText ==
                                            "Contraseña incorrecta!") {
                                          emailErrorText = null;
                                          passwordErrorText =
                                              "Contraseña incorrecta!";
                                        }
                                      },
                                    );
                                    setLoadingState(false);
                                    _materialStatesController.update(
                                        MaterialState.disabled, false);
                                  } else {
                                    await AuthService().logInBackend(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      formValues["email"]!,
                                      context,
                                    );
                                    AppRoutes()
                                        .clearNavigationStack(context, "/");
                                  }
                                }
                              },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: loading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                )
                              : const Text(
                                  "Iniciar sesión",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "O Iniciar Sesión con",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontFamily: "Montserrat",
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: loading
                              ? () {}
                              : () async {
                                  setLoadingState(true);
                                  await AuthService()
                                      .signInWithGoogle(
                                    context,
                                    widget.deepLinkAccess,
                                    widget.latitude,
                                    widget.longitude,
                                  )
                                      .then(
                                    (value) {
                                      User? currentUser =
                                          FirebaseAuth.instance.currentUser;
                                      if (currentUser == null) {
                                        setLoadingState(false);
                                      }
                                    },
                                  );
                                },
                          icon: const FaIcon(FontAwesomeIcons.google),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
