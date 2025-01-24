## Descripción para un Login Administrado en Flutter

### Sistema de Cloud Firestore y  Authentication de Firebase para comenzar app en Flutter

Este proyecto implementa un sistema de autenticación completo desarrollado en Flutter. Está diseñado para aplicaciones que requieren un acceso seguro y controlado, ideal para paneles administrativos o sistemas donde se gestionan permisos de usuario.

##### Authentication

#### Características clave:
- **Login**: Para acceso a la aplicación.
- **SignUp**: Registro de usuarios en Firebase.
- **Widget de SignOut**: Para salir de sesión y desconectar.
- **Widget de TextButtonDeleteCount**: Para eliminar cuentas en Firebase.


---

### Configuraciones esenciales para integrar o migrar a un proyecto

#### Dependencias:
```yaml
cloud_firestore: ^5.6.1
firebase_auth_mocks: ^0.14.1
firebase_core: ^3.10.0
fl_country_code_picker: ^0.1.9+1
get: ^4.6.6
get_storage: ^2.1.1
google_sign_in: ^6.2.2
```

#### Versión de Flutter y Dart:
- **Flutter**: `3.27.2`
- **Dart**: `3.6.1`

---

### Configuraciones en Android

#### Archivo: `android\app\build.gradle`
1. Agregar Java versión 17:
```gradle
compileOptions {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

kotlinOptions {
    jvmTarget = "17"
}
```

2. Cambiar el mínimo SDK:
```gradle
defaultConfig {
    minSdkVersion 23
}
```

---

#### Archivo: `android\settings.gradle`
1. Agregar versión 8.3.2 del plugin:
```gradle
plugins {
    id "com.android.application" version "8.3.2" apply false
}
```

---

#### Archivo: `android\app\src\main\AndroidManifest.xml`
1. Habilitar tráfico no cifrado:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="test"
        android:name="${applicationName}"
        android:usesCleartextTraffic="true"
        android:icon="@mipmap/ic_launcher">
```

---

#### Archivo: `android\gradle\wrapper\gradle-wrapper.properties`
1. Configurar Gradle versión 8.10.2:
```properties
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.10.2-all.zip
```

---

##### Firestore

#### Características clave:
- **Extender BaseModel**: Permite conectar modelos personalizados con Firestore.
- **Valores iniciales en Firestore**: Evita conflictos de datos con valores predeterminados.
- **Clase modelo para pantallas**: Implementa `UserModel` como ejemplo base.
- **Eliminación de firebase_options**: Facilita migrar a otra base de datos Firebase.

---

### Configuraciones esenciales para integrar o migrar a un proyecto

#### Dependencias:
```yaml
dependencies:
  cupertino_icons: ^1.0.8
  flutter:
    sdk: flutter
  flutter_json_view: ^1.1.5

dev_dependencies:
  cloud_firestore: ^5.6.1
  firebase_auth_mocks: ^0.14.1
  firebase_core: ^3.10.0
  fl_country_code_picker: ^0.1.9+1
  flutter_lints: ^5.0.0
  flutter_test:
    sdk: flutter
  get: ^4.6.6
  get_storage: ^2.1.1
  google_sign_in: ^6.2.2
```

---

#### Configuración inicial:
1. **Extender BaseModel**:
   ```dart
   import 'dart:convert';
   import '../data/storage_provider.dart';

   class UserModel extends BaseModel {
     String id;
     String name;
     String email;
     String phone;
     List<ListPerson> listPeople;

     UserModel({
       required this.id,
       required this.name,
       required this.email,
       required this.phone,
       required this.listPeople,
     });

     factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
           id: json['id'],
           name: json['name'],
           email: json['email'],
           phone: json['phone'],
           listPeople: (json['listPeople'] as List)
               .map((e) => ListPerson.fromJson(e))
               .toList(),
         );

     Map<String, dynamic> toJson() => {
           "id": id,
           "name": name,
           "email": email,
           "phone": phone,
           "listPeople": listPeople.map((e) => e.toJson()).toList(),
         };
   }
   ```

2. **Valores iniciales en Firestore**:
   ```dart
   await _createItem(userCredential.user!.uid, {
     "id": userCredential.user!.uid,
     "email": userCredential.user!.email,
     "name": name,
     "phone": phone,
     "listPeople": [],
   });
   ```

3. **Implementar la clase modelo**:
   ```dart
   import 'package:flutter/material.dart';
   import 'package:get/get.dart';
   import '../data/storage_provider.dart';
   import '../models/user_model.dart';

   class HomeScreen extends StatelessWidget {
     HomeScreen({super.key});

     final StorageProvider<UserModel> storageProvider = Get.put(
       StorageProvider<UserModel>(
         collectionPath: "users",
         modelFactory: (json) => UserModel.fromJson(json),
       ),
     );

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(
           title: const Text("Home Page"),
         ),
         body: Obx(() {
           final myUser = storageProvider.model.value;
           if (myUser == null) {
             return const CircularProgressIndicator.adaptive();
           }
           return Center(
             child: Text("Welcome, ${myUser.name}"),
           );
         }),
       );
     }
   }
   ```

---

### Eliminación de firebase_options
Si deseas implementar otra base de datos Firebase, elimina el archivo `firebase_options.dart` y ajusta las configuraciones en `main.dart`.

 ---
