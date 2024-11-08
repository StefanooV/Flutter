import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorHandler {
  String getPasswordRecoveryError(FirebaseAuthException err) {
    switch (err.code) {
      case "user-not-found":
        return "El email ingresado no está registrado";
      case "invalid-email":
        return "El email ingresado no es válido";
    }
    return "Error desconocido!";
  }

  String getLoginError(FirebaseAuthException err) {
    switch (err.code) {
      case "user-not-found":
        return "El email ingresado no está registrado";
      case "invalid-email":
        return "El email ingresado no es válido";
      case "user-disabled":
        return "El usuario está deshabilitado";
      case "wrong-password":
        return "Contraseña incorrecta";
    }
    return "Error desconocido";
  }

  String getEmailRegisterErrors(FirebaseAuthException err) {
    switch (err.code) {
      case "email-already-in-use":
        return "El email ingresado ya está en uso";
      case "invalid-email":
        return "El email ingresado no es válido";
      case "operation-not-allowed":
        return "Función no habilitada. ";
      case "weak-password":
        return "Contraseña inválida";
    }
    return "Error desconocido";
  }
}
