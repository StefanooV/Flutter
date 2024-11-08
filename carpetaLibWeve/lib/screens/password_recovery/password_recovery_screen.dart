import 'package:flutter/material.dart';
import 'package:weveapp/services/auth_service.dart';

import '../../theme/app_theme.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  late String email;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    email = "";
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
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/logowevesintexto.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Recuperá tu contraseña",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                  fontSize: 19,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Ingresa tu e-mail para ayudarte a modificar tu contraseña",
                style: TextStyle(color: Colors.grey, fontFamily: "Montserrat"),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "E-Mail",
                style: TextStyle(color: Colors.black, fontFamily: "Montserrat"),
              ),
              const SizedBox(
                height: 12,
              ),
              Form(
                key: formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value != "") {
                      RegExp regex = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+");
                      if (!regex.hasMatch(value!)) {
                        return "Ingresá un email valido!";
                      }
                    } else {
                      return "Ingresá tu email!";
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 236, 236, 236), width: 0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: AppTheme.weveSkyBlue, width: 1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 255, 0, 0), width: 1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    hintStyle: const TextStyle(
                        fontFamily: "Montserrat", fontWeight: FontWeight.w200),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 236, 236, 236),
                    hintText: "Ingresá tu e-mail",
                  ),
                  onSaved: (newValue) => email = newValue!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Text(
                          "Continuar",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
                      onPressed: () async {
                        formKey.currentState!.save();
                        AuthService().recoverPassword(email, context);
                      }),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("¿Recordaste la contraseña?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Inicía sesión acá",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
