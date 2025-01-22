class ValidatorsTextformfieldProvider {

  String? emailValidator(String? value) {
    String pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    RegExp regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'El correo es obligatorio';
    } else if (!regExp.hasMatch(value)) {
      return 'Introduce un correo válido';
    }
    return null;
  }

  String? passwordValidartor(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    } else if (value.length <= 7) {
      return 'La contraseña debe tener más de 7 caracteres';
    }
    return null;
  }

  String? nameValidartor(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es obligatorio';
    }
    return null;
  }

}
