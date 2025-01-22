import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_auth/auth/Data/auth_provider.dart';
import 'package:test_auth/auth/screen/settings_screen.dart';
import 'package:test_auth/screen/home_screen.dart';
import 'package:test_auth/auth/screen/login_screen.dart';
import 'package:test_auth/auth/screen/sign_up_screen.dart';
import 'package:test_auth/firebase_options.dart';

import 'auth/screen/reset_pass_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding:  BindingsBuilder(() {
        Get.put(AuthProvider()); // Inicializa el controlador principal
      }),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      initialRoute: '/login',
       
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
        ),
        GetPage(
          name: '/singup',
          page: () => SignUpScreen(),
        ),
        GetPage(
          name: '/home',
          page: () => HomeScreen(),
        ),
            GetPage(
          name: '/resetpass',
          page: () => ResetPass(),
        ),
            GetPage(
          name: '/settings',
          page: () => SettingsScreen(),
        ),
      ],
    );
  }
}
