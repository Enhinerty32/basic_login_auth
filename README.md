## Descripción para un Login Administrado en Flutter

### Sistema de Login Administrado en Flutter

Este proyecto implementa un sistema de autenticación completo desarrollado en Flutter. Está diseñado para aplicaciones que requieren un acceso seguro y controlado, ideal para paneles administrativos o sistemas donde se gestionan permisos de usuario.

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
