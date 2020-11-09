import 'package:RWA/add_member_screen.dart';
import 'package:RWA/global_buzz.dart';
import 'package:RWA/login_or_register_screen.dart';
import 'package:RWA/profile.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() => runApp(MyApp());

// ignore: camel_case_types
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueAccent,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFACADB1),
            ),
          ),
        ),
      ),
      initialRoute: LoginOrRegisterScreen.id,
      routes: {
        LoginOrRegisterScreen.id: (context) => LoginOrRegisterScreen(),
        LoginScreen.id: (context) => LoginScreen(),
      },
    );
  }
}
