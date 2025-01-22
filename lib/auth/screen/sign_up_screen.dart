import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_auth/auth/Data/auth_provider.dart';
import 'package:test_auth/auth/services/tools_TextFormField_provider.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final AuthProvider authProvider = AuthProvider();
  final toolsTextformfield = ValidatorsTextformfieldProvider();
  final SignUpScreenController thisController =
      Get.put(SignUpScreenController());

  final FlCountryCodePicker countryPicker = const FlCountryCodePicker(
    title: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        "Seleciona tu pais",
        style: TextStyle(fontSize: 25),
      ),
    ),
    searchBarDecoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(width: 2.0),
      ),
    ),
  );

  SignUpScreen({super.key});
  // Expresión regular para validar el correo

  String? _phoneValidartor(String? value) {
    if (value == null || value.isEmpty) {
      return 'El numero es obligatorio';
    } else if (thisController.countryCode.isEmpty) {
      return 'Seleciona el codigo de region';
    } else if (value.length > 12) {
      return 'Muy largo es mayor a 12 digitos';
    } else if (value.length < 4) {
      return 'Muy corto es menor a 4 digitos';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Formulario Registrarse'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  validator: toolsTextformfield.nameValidartor,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Celular',
                    // Botón para abrir el selector de códigos de país
                    prefixIcon: ButtonCode(
                      thisController:thisController,
                        countryPicker: countryPicker,
                        authProvider: authProvider),
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: _phoneValidartor,
                ),
                SizedBox(height: 20),
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
                Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        onPressed: () {
                          Get.offAndToNamed('/login');
                        },
                        child: Text('Ya eres usuario ?'))),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        thisController.countryCode.value.isEmpty == false) {
                      var result =
                          await authProvider.registerWithEmailAndPassword(
                        phone:
                            '${thisController.countryCode.value} ${_phoneController.text}',
                        name: _nameController.text,
                        context: context,
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      if (result != null) {
                        // Registro exitoso
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Usuario registrado con éxito')),
                        );
                        Get.offAndToNamed('/login');
                        Get.delete<SignUpScreenController>();
                      } else {
                        // Error en el registro
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error en el registro')),
                        );
                      }
                    }
                  },
                  child: Text('Registrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonCode extends StatelessWidget {
  const ButtonCode({
    super.key,
    required this.countryPicker,
    required this.authProvider,
    required this.thisController
  });

  final FlCountryCodePicker countryPicker;
  final AuthProvider authProvider;
  final SignUpScreenController thisController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Muestra el picker para seleccionar el código de país
        final picked = await countryPicker.showPicker(
          context: context,
          backgroundColor: Colors.black,
        );
        if (picked != null) {
          // Si se selecciona un código, actualizamos el estado de la interfaz
          thisController.countryCode.value =
              picked.dialCode; // Asigna el código seleccionado
        }
      },
      child: SizedBox(
        width: 70,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Obx(
            () => Text(
              thisController.countryCode.isNotEmpty
                  ? '${thisController.countryCode.value} '
                  : 'Select',
              style: TextStyle(fontSize: 17),
            ), // Prefijo del código de país
          ),
        ),
      ),
    );
  }
}

class SignUpScreenController extends GetxController {
  final RxBool obscureText = true.obs;
  var countryCode = ''.obs; // Observables  gestionar el código de país
}
