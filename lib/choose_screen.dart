import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:after_layout/after_layout.dart';
import 'intro_screen.dart';
import 'login_or_register_or_myStatus_screen.dart';

class ChooseScreen extends StatefulWidget {
  static String id = 'choose_screen';

  ChooseScreen();

  @override
  ChooseScreenState createState() => ChooseScreenState();
}

class ChooseScreenState extends State<ChooseScreen>
    with AfterLayoutMixin<ChooseScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    Navigator.pop(context);

    if (_seen) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginOrRegisterOrMyStatusScreen(),
        ),
      );
    } else {
      await prefs.setBool('seen', true);
      Navigator.pushNamed(context, IntroScreen.id);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
