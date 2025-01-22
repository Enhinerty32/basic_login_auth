import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

import '../services/error_auth_provider.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  final   firestore = FirebaseFirestore.instance.collection("users");

  // final errorAuth=Get.put(ErrorAuthProvider());

// Registrar Usuario
  Future<User?> registerWithEmailAndPassword(
      {required String name,
      required String email,
      required String password,
      required String phone,
      required BuildContext context}) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Crear un documento en Firestore con el ID del usuario
      await createItem(userCredential.user!.uid, {
        "id": userCredential.user!.uid,
        "email": userCredential.user!.email,
        "name": name,
        "phone": phone
      });
      signOut();
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      ErrorAuthProvider().registerWithEmailAndPasswordErrors(
          error: e.message, context: context);

      // print("Error: ${e.message}");
      return null;
    }
  }

  // Crear un documento con un ID específico
  Future<void> createItem(String id, Map<String, dynamic> data) async {
    try {
      DocumentReference docRef =
         firestore.doc(id);

      // Guardar el documento en Firestore con el ID proporcionado
      await docRef.set(data);
      // print("Documento creado con ID: $id");
    } catch (e) {
      // print("Error al crear el documento: $e");
    }
  }

// Iniciar Sesión
  Future<User?> signInWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      try {
        // final String? tokenId = await userCredential.user?.getIdToken(true);
      } catch (e) {
        // print('Error en login :Mact Tokenid y RxTokenID');
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      ErrorAuthProvider()
          .signInWithEmailAndPasswordErrors(error: e.message, context: context);
      // print("Error: ${e.message}");
      return null;
    }
  }


 
  // Convertir las variables User en un Map
  Map<String, dynamic> mapUserProperties({required User user, String? token}) {
    return {
      'uid': user.uid,
      'email': user.email ?? 'No disponible',
      'displayName': user.displayName ?? 'No disponible',
      'photoURL': user.photoURL ?? 'No disponible',
      'phoneNumber': user.phoneNumber ?? 'No disponible',
      'isAnonymous': user.isAnonymous,
      'metadata':
          'Creado: ${user.metadata.creationTime}, Última sesión: ${user.metadata.lastSignInTime}',
      'providerData':
          user.providerData.map((info) => info.providerId).join(', '),
      'isEmailVerified': user.emailVerified.toString(),
      'tenantId': user.tenantId ?? 'No disponible',
    };
  }

  // Verificar el ID token
  Future<void> verifyIdToken() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // String? idToken = await user.getIdToken(true);
      // print("ID Token: $idToken (Permanece en el usuario)");
      // Aquí puedes enviar el ID token a tu backend para su verificación
    } else {
      // print("No hay usuario autenticado (Salir del usuario)");
    }
  }

  
   

  // Autenticacion por Google

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    }
    return null;
  }

  // Autenticacion por Phone

  void signInWithPhone({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        // print("Error: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Almacena el `verificationId` para usarlo al ingresar el código.
        // print("Código enviado: $verificationId");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> cambiarCorreoElectronico(String newEmail) async {
    User? usuario = FirebaseAuth.instance.currentUser;

    if (usuario != null) {
      try {
        // Verificar antes de actualizar el correo
        await usuario.verifyBeforeUpdateEmail(newEmail);
        print('Se envió un correo de verificación al nuevo correo.');
      } on FirebaseAuthException catch (e) {
        // Manejo de errores
        if (e.code == 'invalid-email') {
          print('El correo electrónico proporcionado no es válido.');
        } else if (e.code == 'email-already-in-use') {
          print('El correo electrónico ya está en uso.');
        } else if (e.code == 'requires-recent-login') {
          print(
              'La sesión del usuario no es reciente. Reautentica al usuario.');
          // Aquí puedes reautenticar al usuario si es necesario.
        } else {
          print('Error desconocido: ${e.message}');
        }
      } catch (e) {
        print('Error inesperado: $e');
      }
    } else {
      print('No hay ningún usuario autenticado.');
    }
  }

// Eliminar el usuario
Future<void> deleteUser({required String email, required String password}) async {
  try {
    // Obtén el usuario actualmente autenticado
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Crea las credenciales para reautenticar al usuario
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,  // Debes pedirle al usuario que ingrese su contraseña
      );

      // Reautentica al usuario con las credenciales proporcionadas
      await user.reauthenticateWithCredential(credential);
      print('Iniciando la eliminación');

      // Eliminar el documento del usuario de Firestore
      await firestore.doc(user.uid).delete();
      print('Eliminación en Firestore exitosa');

      // Eliminar la cuenta de Firebase Authentication
      await user.delete();
      print('Eliminación en Authentication exitosa');
      // Redirigir al usuario a la página de login
      
       
       
      print('Usuario eliminado exitosamente');
    } else {
      print('No hay usuario autenticado');
    }
  } catch (e) {
    print('Error en eliminar la cuenta: ${e.toString()}');
  }
   Get.offNamed("/login");
}


// Cerrar sesion
  Future<void> signOut() async {
    try {
      await _auth.signOut();
     
    Get.offNamed("/login");
    // Get.deleteAll();
    } catch (e) {
      
    }
      Get.offNamed("/login");
  }

// Recuperar contrasena

  Future<String?> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Active ";
    } on FirebaseAuthException catch (e) {
      // print("Error: ${e.message}");
      return "Error: ${e.message}";
    }
  }

  Future<String> getToken() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Si hay token obténdre el token de ID del usuario autenticado
      return await user.getIdToken() ?? '';
    } else {
      print("No hay usuario autenticado.");
      //De lo contrario obtendre
      return '';
    }
  }

  Future<void> checkTokenExpiration() async {
    try {
      // Obtén el usuario actual
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Obtén información detallada del token
        IdTokenResult idTokenResult = await user.getIdTokenResult();

        // Tiempo de expiración del token
        DateTime expirationTime = idTokenResult.expirationTime!;
        DateTime currentTime = DateTime.now();

        // Calcula el tiempo restante en segundos
        Duration timeRemaining = expirationTime.difference(currentTime);

        if (timeRemaining.isNegative) {
          print("El token ya ha expirado.");
        } else {
          print(
              "El token expirará en ${timeRemaining.inSeconds} segundos (${timeRemaining.inMinutes} minutos).");
        }
      } else {
        print("No hay ningún usuario autenticado.");
      }
    } catch (e) {
      print("Error al verificar el token: $e");
    }
  }
}
