import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:RWA/main.dart';

Color _yellowcolor = Color(0xFFFFC727);

TextStyle _textStyle = TextStyle(color: Colors.white);
TextStyle _headerStyle = TextStyle(
  color: _yellowcolor,
  fontSize: 17,
);

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeMode _currentTheme = ThemeMode.dark;
  bool _phonenotif = true;
  bool _smsnotif = true;
  bool _emailnotif = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Settings'),
        ),
        body: Column(
          children: [
            ListTile(
              title: Text(
                'APP THEME',
                style: _headerStyle,
              ),
            ),
            ListTile(
              title: Text(
                'Light',
                style: _textStyle,
              ),
              trailing: Radio(
                activeColor: _yellowcolor,
                value: ThemeMode.light,
                groupValue: _currentTheme,
                onChanged: (ThemeMode value) {
                  setState(
                        () {
                      _currentTheme = value;
                      //Get.changeThemeMode(value);
                      ThemeController.to.setThemeMode(value);
                    },
                  );
                },
              ),
            ),
            ListTile(
              title: Text(
                'System default (Dark)',
                style: _textStyle,
              ),
              trailing: Radio(
                activeColor: _yellowcolor,
                value: ThemeMode.dark,
                groupValue: _currentTheme,
                onChanged: (ThemeMode value) {
                  setState(
                        () {
                      _currentTheme = value;

                      //Get.changeThemeMode(value);
                      ThemeController.to.setThemeMode(value);
                    },
                  );
                },
              ),
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              title: Text(
                'NOTIFICATIONS',
                style: _headerStyle,
              ),
            ),
            CheckboxListTile(
              title: Text('Phone notifications'),
              secondary: Icon(Icons.phone),
              controlAffinity: ListTileControlAffinity.trailing,
              activeColor: _yellowcolor,
              checkColor: ThemeData.dark().scaffoldBackgroundColor,
              value: _phonenotif,
              onChanged: (bool value) {
                setState(() {
                  _phonenotif = value;
                });
              },
            ),
            CheckboxListTile(
              title: Text('SMS notifications'),
              secondary: Icon(Icons.sms),
              controlAffinity: ListTileControlAffinity.trailing,
              activeColor: _yellowcolor,
              checkColor: ThemeData.dark().scaffoldBackgroundColor,
              value: _smsnotif,
              onChanged: (bool value) {
                setState(() {
                  _smsnotif = value;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Email notifications'),
              secondary: Icon(Icons.email),
              controlAffinity: ListTileControlAffinity.trailing,
              activeColor: _yellowcolor,
              checkColor: ThemeData.dark().scaffoldBackgroundColor,
              value: _emailnotif,
              onChanged: (bool value) {
                setState(() {
                  _emailnotif = value;
                });
              },
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              title: Text(
                'CHANGE LANGUAGE',
                style: _headerStyle,
              ),
              subtitle:
              Text('Change the app language to hindi/english/punjabi'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
