// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weveapp/helper/helper.dart';
import 'package:weveapp/models/access_model.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:weveapp/screens/router/app_routes.dart';
import 'package:weveapp/services/auth_error_handler.dart';
import 'package:weveapp/theme/app_theme.dart';

class AuthService {
  bool backendAuth = false;
  String? appEnv = dotenv.env['APP_ENV'];
  static final _firebaseMessaging = FirebaseMessaging.instance;

  // -- 3rd party login providers -- //

  Future<bool> logInBackend(String uid, String email, BuildContext context,
      [bool? deepLinkAccess, double? latitude, double? longitude]) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("coldStart", true);
    var status = prefs.getBool("logedIn?");
    prefs.setBool("savedRegistrationToken?", false);
    if (status == true) {
      print("ya estaba logeado viejito");
      return true;
    }

    if (!Helper().isValidEmail(email)) {
      String aux = email;
      email = uid;
      uid = aux;
    }
    String authority =
        appEnv == "test" ? dotenv.env["TEST_URL"]! : dotenv.env["PROD_URL"]!;
    Uri url = appEnv == "test"
        ? Uri.https(authority, '/Account/Driver/Access')
        : Uri.https(authority, '/Account/Driver/Access');
    print("backend ${email} ${uid}");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(
          {"email": email, "uid": uid},
        ),
      );
      if (deepLinkAccess != null) {
        if (!deepLinkAccess) {
          context.go("/");
        } else {
          context.go(
            "/station?lat=$latitude&long=$longitude",
          );
        }
      } else {
        context.go("/");
      }
      print(response.body);
      Access parsedAccess = Access.fromMap(jsonDecode(response.body));
      bool? savedRegistrationToken = prefs.getBool("savedRegistrationToken?");
      if (savedRegistrationToken == null || savedRegistrationToken == false) {
        updateUserRegistrationToken();
      }
      prefs.setString("token", parsedAccess.token);
      prefs.setBool("logedIn?", true);
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  void updateUserRegistrationToken() async {
    final registrationToken = await _firebaseMessaging.getToken();
    final Map<String, String> body = {"registrationToken": registrationToken!};
    await HttpRequestServices().updateDriverUser(body);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("savedRegistrationToken?", true);
  }

  Future<void> signInWithGoogle(BuildContext context,
      [bool? deepLinkAccess, double? latitude, double? longitude]) async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: <String>["Email"]).signIn();
      print("Googleuser: $googleUser");
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final a = await FirebaseAuth.instance.signInWithCredential(credential);
      final userEmail = a.user?.providerData[0].email;
      final userUid = a.user?.uid;
      if (userEmail != null && userUid != null) {
        await logInBackend(
            userUid, userEmail, context, deepLinkAccess, latitude, longitude);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                "Ocurrió un error iniciando sesión. Intenta más tarde."),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red[400],
            duration: const Duration(seconds: 1),
            dismissDirection: DismissDirection.down,
          ),
        );
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              "Ocurrió un error iniciando sesión. Intenta más tarde."),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[400],
          duration: const Duration(seconds: 1),
          dismissDirection: DismissDirection.down,
        ),
      );
      print("Exception: $err");
    }
  }

  void signInWithApple(BuildContext context,
      [bool? deepLinkAccess, double? latitude, double? longitude]) async {
    final appleProvider = AppleAuthProvider();
    await FirebaseAuth.instance.signInWithProvider(appleProvider);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Inicio de sesión correcto!"),
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppTheme.wevePrimaryBlue,
      duration: Duration(seconds: 1),
      dismissDirection: DismissDirection.down,
    ));
  }

  // signInWithFacebook() async {
  //   final loginResult = await FacebookAuth.instance.login();
  //   print(loginResult);
  //   try {
  //     final OAuthCredential facebookAuthCredential =
  //         FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //     return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //   } catch (err) {
  //     print("Error cumpa");
  //   }
  // }

  Future<String?> signInWithEmail(
      String email, String password, BuildContext context,
      [bool? deepLinkAccess, double? latitude, double? longitude]) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await logInBackend(
        FirebaseAuth.instance.currentUser!.uid,
        FirebaseAuth.instance.currentUser!.email!,
        context,
        deepLinkAccess,
        latitude,
        longitude,
      );
      return null;
    } on FirebaseAuthException catch (err) {
      return err.code;
    } catch (err) {
      return "";
    }
  }

  void updateUserInfo(String name, String lastName, String phone, User user) {
    try {} catch (err) {
      print(err);
    }
  }

  Future<String?> registerNewUserWithEmail(
      String email, String password, String name, String lastName) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName("$name $lastName");
      print(userCredential);
      return null;
    } on FirebaseAuthException catch (err) {
      print("FirebaseEx ${err.code}");
      return err.code;
    } catch (err) {
      print("Ex $err");
      return err.toString();
    }
  }

  void recoverPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email enviado! Revisá tu correo!"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.wevePrimaryBlue,
        dismissDirection: DismissDirection.down,
      ));
    } on FirebaseAuthException catch (err) {
      print("There was a biggo error: $err");
      String message = AuthErrorHandler().getPasswordRecoveryError(err);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
        dismissDirection: DismissDirection.down,
      ));
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Error desconocido"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
        dismissDirection: DismissDirection.down,
      ));
    }
  }

  //sign out

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    AppRoutes().clearNavigationStack(context, "/");
  }
}
