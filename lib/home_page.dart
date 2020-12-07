import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'homePageContent.dart';
import 'buzzContent.dart';
import 'profileContent.dart';
import 'drawer_menu.dart';

class HomePage extends StatefulWidget {
  final String communityName;
  final String phoneNumber;
  final String gmailId;

  HomePage({this.communityName, this.phoneNumber, this.gmailId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  Widget bodyWidget() {
    if (_currentIndex == 0) {
      return HomePageContent(
        communityName: widget.communityName,
        phoneNumber: widget.phoneNumber,
        gmailId: widget.gmailId,
      );
    }
    if (_currentIndex == 1) {
      return BuzzContent(
        communityName: widget.communityName,
        phoneNumber: widget.phoneNumber,
        gmailId: widget.gmailId,
      );
    }
    return ProfileContent(
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(appBarTitle[_currentIndex]),
      ),
      drawer: SafeArea(
        child: DrawerMenu(
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
