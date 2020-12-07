import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'drawer_screens/settings_screen.dart';
import 'login_or_register_or_myStatus_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ComplaintManagerDrawerMenu extends StatefulWidget {
  final String communityName;
  final String phoneNumber;
  final String gmailId;

  ComplaintManagerDrawerMenu({this.communityName, this.phoneNumber, this.gmailId});
  @override
  _ComplaintManagerDrawerMenuState createState() => _ComplaintManagerDrawerMenuState();
}

class _ComplaintManagerDrawerMenuState extends State<ComplaintManagerDrawerMenu> {
  final _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>> getUsersDocumentData() async {
    DocumentReference documentRef;
    if (widget.gmailId == null) {
      documentRef = _firestore
          .collection('complaint manager')
          .doc(widget.communityName)
          .collection('data')
          .doc(widget.phoneNumber);
    } else {
      documentRef = _firestore
          .collection('complaint manager')
          .doc(widget.communityName)
          .collection('data')
          .doc(widget.gmailId);
    }

    Map<String, dynamic> data;

    await documentRef.get().then((snapshot) {
      data = snapshot.data();
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('images/12.png'),
                  radius: 50,
                ),
                SizedBox(
                  height: 5,
                ),
                FutureBuilder<Map<String, dynamic>>(
                  future: getUsersDocumentData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text(
                        snapshot.data['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      );
                    } else {
                      return Text(
                        'Loading...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () async {
              await _googleSignIn.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginOrRegisterOrMyStatusScreen.id,
                    (r) => false,
              );
            },
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.powerOff,
                color: Color(0xFFFEC64F),
              ),
              title: Text(
                'Log out',
                style: TextStyle(
                  color: Color(0xFFFEC64F),
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: getUsersDocumentData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListTile(
                  title: Text(
                    '${widget.communityName}',
                    textScaleFactor: 1.3,
                  ),
                );
              } else {
                return ListTile(
                  title: Text(
                    'Loading...',
                    textScaleFactor: 1.3,
                  ),
                );
              }
            },
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          ),
          AboutListTile(
            icon: Icon(Icons.widgets_outlined),
            applicationName: 'RWA Management',
            applicationVersion: 'November 2020',
            applicationLegalese: '\u{a9} 2020 RWA, ${widget.communityName}',
            child: Text('About'),
            aboutBoxChildren: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Our software- \'RWA Management App\' aims to provide software solutions to aide the management process of the RWA(Resident’s Welfare Association) Committee of any housing society – from the smallest neighborhood to the more populous ones as well.',
                textAlign: TextAlign.justify,
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text('Donate'),
            onTap: () {
              showDialog(
                context: context,
                useSafeArea: true,
                builder: (context) => AlertDialog(
                  title: Text('Coming up soon!'),
                  content: Text(
                    'Here we will implement a donation reroute when this app. is actually deployed.',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help and Feedback'),
            onTap: () {
              showDialog(
                context: context,
                useSafeArea: true,
                builder: (context) => AlertDialog(
                  title: Text('Coming up soon!'),
                  content: Text(
                    'Here we intend to implement a helpdesk reroute when this app. is actually deployed.',
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: 100.0,
          ),
          Image.asset('images/appLogo.png'),
          Center(
            child: Text(
              'Residents Welfare Association',
              textScaleFactor: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
