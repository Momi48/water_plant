import 'package:flutter/material.dart';
import 'package:water_plant/helper/global_varaibles.dart';
import 'package:water_plant/model/user_model.dart';
import 'package:water_plant/screens/auth/login_screen.dart';
import 'package:water_plant/screens/auth/pin_code_screen.dart';

import 'package:water_plant/screens/home_screen.dart';
import 'package:water_plant/services/sqflite_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // await SqfliteServices().delete();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColorPlant,
          titleTextStyle: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
            fontSize: 18,
          ),
        ),
      ),
      home: FutureBuilder<UserModel?>(
        future: SqfliteServices().getLoggedInUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasData && snapshot.data != null) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
