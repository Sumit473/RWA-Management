import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../register_screens/join_or_enter_community.dart';
import 'personal_info_screen.dart';
import '../constants.dart';

class NameCommunityScreen extends StatefulWidget {
  static String id = 'name_community_screen';

  @override
  _NameCommunityScreenState createState() => _NameCommunityScreenState();
}

class _NameCommunityScreenState extends State<NameCommunityScreen> {
  String communityName = 'E.g., Shivalik Residence';
  bool pressed = false;
  final _textEditingController = TextEditingController();

  String validator() {
    if (pressed) {
      if (communityName ==  'E.g., Shivalik Residence') {
        return 'Community name is required';
      }
      if (communityName.length < 3) {
        return 'Min. length is 3';
      }
      if (communityName.length > 30) {
        return 'Max. length is 30';
      }
    }
    return 'null';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(40.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Step 1 of 4',
                  style: TextStyle(
                    fontFamily: 'Product Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                  ),
                ),
                Expanded(
                  child: Hero(
                    tag: 'welcome_image',
                    child: Image.asset(
                      'images/high_five.png',
                    ),
                  ),
                ),
                Text(
                  'Name of your Community',
                  style: TextStyle(
                    fontFamily: 'Product Sans',
                    fontWeight: FontWeight.w900,
                    fontSize: 20.0,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: 20.0, top: 20.0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black54,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.igloo,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Text(
                                    communityName,
                                    style: TextStyle(
                                        color: kHintColor,
                                        fontFamily: 'Product Sans'),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async {
                              String name = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        JoinOrEnterCommunity(),
                                  ));
                              setState(() {
                                communityName = 'E.g., Shivalik Residence';
                                pressed = true;
                              });
                              if (name != null && name != '') {
                                setState(() {
                                  communityName = name;
                                });
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.chevronCircleRight,
                            size: 40.0,
                          ),
                          onPressed: () {
                            setState(() {
                              pressed = true;
                              validator();
                            });
                            if (validator() == 'null') {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: PersonalInfoScreen(
                                    communityName: communityName,
                                  ),
                                ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Visibility(
                      visible: validator() == 'null' ? false : true,
                      child: Text(
                        validator(),
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'ProductSans',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
                SizedBox(
                  width: 150.0,
                  child: Hero(
                    tag: 'indicator',
                    child: LinearProgressIndicator(
                      value: 0,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(kYellowColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }
}
