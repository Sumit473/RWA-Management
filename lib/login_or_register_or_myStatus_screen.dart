import 'package:RWA/login_screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'register_screens/name_community_screen.dart';
import 'see_registration_status.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants.dart';

class LoginOrRegisterOrMyStatusScreen extends StatefulWidget {
  static String id = 'login_or_registration_or_myStatus_screen';

  LoginOrRegisterOrMyStatusScreen();

  @override
  _LoginOrRegisterOrMyStatusScreenState createState() =>
      _LoginOrRegisterOrMyStatusScreenState();
}

class _LoginOrRegisterOrMyStatusScreenState
    extends State<LoginOrRegisterOrMyStatusScreen> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBlackBackgroundColor,
        body: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset('images/appLogo.png'),
              Column(
                children: <Widget>[
                  Text(
                    'RWA Manager',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 30.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "A Society Management Software.\nExplore the possibilities in a Connected Community.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kYellowColor,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF3B3A42),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            RegisterOrLoginButton(
                              title: 'Register',
                              titleColor: Colors.black,
                              backgroundColor: Colors.white,
                              navigateId: NameCommunityScreen.id,
                            ),
                            RegisterOrLoginButton(
                              title: 'Login',
                              titleColor: kYellowColor,
                              navigateId: LoginScreen.id,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Already Registered?',
                        style: TextStyle(
                          color: kHintColor,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      GestureDetector(
                        child: Text(
                          'See Application Status',
                          style: TextStyle(
                            color: kYellowColor,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, SeeRegistrationStatus.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterOrLoginButton extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Color backgroundColor;
  final String navigateId;

  RegisterOrLoginButton(
      {this.title, this.titleColor, this.backgroundColor, this.navigateId});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          navigateId,
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: backgroundColor,
      child: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 15.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
