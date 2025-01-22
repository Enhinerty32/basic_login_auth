import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_auth/auth/Data/auth_provider.dart';

class ResetPass extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final AuthProvider authProvider = Get.put(AuthProvider(), permanent: true);


  ResetPass({super.key});

  String? _emailValidator(String? value) {
    String pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    RegExp regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'El correo es obligatorio';
    } else if (!regExp.hasMatch(value)) {
      return 'Introduce un correo válido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true, 
      appBar: AppBar(
        title: Text("Reinicio de contraseña"),
      ),
      body: SingleChildScrollView (
        child: Center(
          child: Padding(
          padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(alignment: Alignment.centerLeft,child: Padding(
                  padding: const EdgeInsets.only(bottom:10 ),
                  child: Text("Ingresa tu correo para recuperar tu contraña"),
                )),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                  ),
                  validator: _emailValidator,
                ),SizedBox(height: 20,),
                 ElevatedButton(
                  onPressed: () async {
              await authProvider.resetPassword(email: _emailController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Se a enviado con exito')),
                        );
                          Get.back();
                  },
                  child: Text('Enviar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
