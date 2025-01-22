import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_auth/auth/Data/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:test_auth/auth/services/tools_TextFormField_provider.dart';
import 'package:test_auth/screen/home_screen.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthProvider authProvider = Get.put(AuthProvider(), permanent: true);
  final toolsTextformfield = ValidatorsTextformfieldProvider();
  final LoginScreenController thisController = Get.put(LoginScreenController());

  LoginScreen({super.key});
  // Expresión regular para validar el correo

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<String>(
      future: authProvider.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              body:
                  CircularProgressIndicator()); // Mostrando indicador de carga.
        } else if (snapshot.hasError) {
          return Scaffold(
              body: CircularProgressIndicator()); // Mostrando error.
        } else if (snapshot.hasData) {
          
          final String token = snapshot.data ?? '';
          if (token.isEmpty) {
            return Login(
              formKey: _formKey,
              emailController: _emailController,
              toolsTextformfield: toolsTextformfield,
              passwordController: _passwordController,
              thisController: thisController,
              authProvider: authProvider,
            );
          } else {
            // Si el token no está vacío, navegamos a la pantalla principal.
            // 'Get.offAndToNamed' es utilizado para cambiar de pantalla sin que la anterior esté en la pila de navegación.
            return HomeScreen();
          } // Mostrando datos.
        } else {
          return Text('Sin datos disponibles'); // Sin datos.
        }
      },
    );
  }
}

class Login extends StatelessWidget {
  const Login({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required this.toolsTextformfield,
    required TextEditingController passwordController,
    required this.thisController,
    required this.authProvider,
  })  : _formKey = formKey,
        _emailController = emailController,
        _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final ValidatorsTextformfieldProvider toolsTextformfield;
  final TextEditingController _passwordController;
  final LoginScreenController thisController;
  final AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Formulario para entrar'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                  ),
                  validator: toolsTextformfield.emailValidator,
                ),
                SizedBox(height: 20),
                Obx(() => TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () async {
                              thisController.obscureText.value =
                                  !thisController.obscureText.value;
                            },
                            icon: Icon(thisController.obscureText.value
                                ? Icons.remove_red_eye
                                : Icons.remove_red_eye_outlined)),
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: thisController.obscureText.value,
                      validator: toolsTextformfield.passwordValidartor,
                    )),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Get.offAndToNamed('/singup');
                        },
                        child: Text('Registrate')),
                    TextButton(
                        onPressed: () {
                          Get.toNamed('/resetpass');
                        },
                        child: Text('Olvidates la contraseña'))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Esto devuelve un User lo cual puede User de Firebase esta la UID y el token
                      User? userLog =
                          await authProvider.signInWithEmailAndPassword(
                        context: context,
                        email: _emailController.text,
                        password: _passwordController.text,
                      );

                      if (userLog != null) {
                        // Registro exitoso
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Usuario registrado con éxito')),
                        );

                        Get.offAndToNamed('/home');
                        Get.delete<LoginScreenController>();
                      } else {
                        // Error en el registro
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error en el registro')),
                        );
                      }
                    }
                  },
                  child: Text('Entrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreenController extends GetxController {
  final RxBool obscureText = true.obs;
}
