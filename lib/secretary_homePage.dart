import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'secretary_homePageContent.dart';
import 'secretaries_buzzContent.dart';
import 'secretary_profileContent.dart';
import 'secretary_drawer_menu.dart';
import 'package:firebase_core/firebase_core.dart';

class SecretaryHomePage extends StatefulWidget {
  final String communityName;
  final String phoneNumber;
  final String gmailId;

  SecretaryHomePage({this.communityName, this.phoneNumber, this.gmailId});
  @override
  _SecretaryHomePageState createState() => _SecretaryHomePageState();
}

class _SecretaryHomePageState extends State<SecretaryHomePage> {
  int _currentIndex = 0;

  Widget bodyWidget() {
    if (_currentIndex == 0) {
      return SecretaryHomePageContent(
        communityName: widget.communityName,
        phoneNumber: widget.phoneNumber,
        gmailId: widget.gmailId,
      );
    }
    if (_currentIndex == 1) {
      return SecretaryBuzzContent(
        communityName: widget.communityName,
        phoneNumber: widget.phoneNumber,
        gmailId: widget.gmailId,
      );
    }
    return SecretaryProfileContent(
      communityName: widget.communityName,
      phoneNumber: widget.phoneNumber,
      gmailId: widget.gmailId,
    );
  }

  List<String> appBarTitle = <String>[
    'Home',
    'Community Buzz',
    'Profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(appBarTitle[_currentIndex]),
      ),
      drawer: SafeArea(
        child: SecretaryDrawerMenu(
          communityName: widget.communityName,
          phoneNumber: widget.phoneNumber,
          gmailId: widget.gmailId,
        ),
      ),
      body: SafeArea(
        child: bodyWidget(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: FaIcon(FontAwesomeIcons.home),
          ),
          BottomNavigationBarItem(
            label: 'Buzz',
            icon: FaIcon(FontAwesomeIcons.users),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: FaIcon(FontAwesomeIcons.userCircle),
          ),
        ],
      ),
    );
  }
}
