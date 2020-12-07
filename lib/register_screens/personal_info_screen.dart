import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../register_screens/enter_credentials_screen.dart';
import '../constants.dart';

enum Gender { male, female, other }

class PersonalInfoScreen extends StatefulWidget {
  final String communityName;

  PersonalInfoScreen({this.communityName});

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  String ownerName;
  DateTime dateOfBirth = DateTime.now();
  Gender gender = Gender.male;
  bool pressed = false;

  String nameValidator() {
    if (pressed) {
      if (ownerName == null || ownerName == '') {
        return 'Name is required';
      }
      if (ownerName.length < 3) {
        return 'Min. length is 3';
      }
      if (ownerName.length > 20) {
        return 'Max. length is 20';
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
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.only(
                left: 40.0, right: 40.0, top: 40.0, bottom: 39.0),
            child: ListView(
              children: [
                Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            GestureDetector(
                              child: Icon(FontAwesomeIcons.arrowLeft),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(
                              width: 95.0,
                            ),
                            Text(
                              'Step 2 of 4',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Product Sans',
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Personal Info?',
                          style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontWeight: FontWeight.w900,
                            fontSize: 35.0,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'So that we know how to call you.',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Product Sans',
                            color: Colors.black87,
                            fontSize: 15.0,
                          ),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Product Sans',
                                    fontSize: 15.0,
                                  ),
                                ),
                                GestureDetector(
                                  child: Icon(Icons.add_photo_alternate),
                                  onTap: () {},
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black54,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: TextField(
                                autofocus: false,
                                onChanged: (name) {
                                  setState(() {
                                    ownerName = name;
                                  });
                                },
                                decoration: InputDecoration(
                                  suffixIcon: nameValidator() != 'null'
                                      ? Icon(
                                          FontAwesomeIcons.exclamationCircle,
                                          color: Colors.red,
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  hintText: 'Your Full name',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Visibility(
                              visible: nameValidator() == 'null' ? false : true,
                              child: Text(
                                nameValidator(),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'ProductSans',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              'Date of Birth',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Product Sans',
                                fontSize: 15.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              height: 100.0,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                initialDateTime: DateTime.now(),
                                onDateTimeChanged: (DateTime newDateTime) {
                                  dateOfBirth = newDateTime;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              'Gender',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Product Sans',
                                fontSize: 15.0,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                          'Male',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Product Sans',
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        leading: Radio(
                                          activeColor: kYellowColor,
                                          value: Gender.male,
                                          groupValue: gender,
                                          onChanged: (gen) {
                                            setState(() {
                                              gender = gen;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                          'Female',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Product Sans',
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        leading: Radio(
                                          activeColor: kYellowColor,
                                          value: Gender.female,
                                          groupValue: gender,
                                          onChanged: (gen) {
                                            setState(() {
                                              gender = gen;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ListTile(
                                  title: Text(
                                    'Other',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Product Sans',
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  leading: Radio(
                                    activeColor: kYellowColor,
                                    value: Gender.other,
                                    groupValue: gender,
                                    onChanged: (gen) {
                                      setState(() {
                                        gender = gen;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            FlatButton(
                              color: kContinueButtonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: () {
                                pressed = true;
                                setState(() {
                                  nameValidator();
                                });
                                if (nameValidator() == 'null') {
                                  pressed = false;
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: EnterCredentialsScreen(
                                        communityName: widget.communityName,
                                        ownerName: ownerName,
                                        dateOfBirth: dateOfBirth,
                                        gender: gender.toString().substring(
                                            gender.toString().indexOf('.') + 1),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text(
                                  'CONTINUE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Product Sans',
                                    color: Colors.black87,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(
                      width: 150.0,
                      child: Hero(
                        tag: 'indicator',
                        child: LinearProgressIndicator(
                          value: 0.25,
                          backgroundColor: Colors.grey,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(kYellowColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
