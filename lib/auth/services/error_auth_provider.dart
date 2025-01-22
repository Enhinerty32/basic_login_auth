import 'package:flutter/material.dart';

class ErrorAuthProvider {
  Future<String?> registerWithEmailAndPasswordErrors(
      {required String? error, required BuildContext context}) async {
    if (error == "The email address is already in use by another account.") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Este usuario ya esta registrado')),
      );
    } else if (error == String) {
      // print(error);
    }
    return null;
  }

  Future<String?> signInWithEmailAndPasswordErrors(
      {required String? error, required context}) async {
    if (error == "The supplied auth credential is incorrect, malformed or has expired.") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Su contraseña o correo son incorrectos')),
      );
    } else {
      // print(error);
    }
    return null;
  }
}
