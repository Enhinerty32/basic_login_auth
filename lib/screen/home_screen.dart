import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_auth/auth/Data/auth_provider.dart';
import 'package:test_auth/data/main_db.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final authProvider = AuthProvider();
  final mainDB = Get.put(Maindb());
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Home Page"),
      ),
 
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text("++${authProvider}"),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
 
}
 