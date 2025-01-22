import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_auth/auth/Data/auth_provider.dart';

class TextButtonDeleteCount extends StatelessWidget {
  final String email;
  final String password;

  TextButtonDeleteCount({
    super.key,
    required this.email,
    required this.password,
  });

  final AuthProvider authProvider = AuthProvider();

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text('¿Estás seguro de que quieres eliminar la cuenta?'),
                content: Text('Esta acción no se puede deshacer.'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      // Cerrar el diálogo sin confirmar
                      Get.back();
                      authProvider.deleteUser(email: email, password: password);
                    },
                    child: Text('Eliminar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back(); // Cerrar el diálogo sin confirmar
                    },
                    child: Text('Cancelar'),
                  )
                ]),
          );
        },
        label: Text(
          "Eliminar la cuenta",
          style: TextStyle(color: Colors.red),
        ));
  }
}
