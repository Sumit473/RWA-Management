import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'apartment_details_screen.dart';
import '../constants.dart';

class EnterCredentialsScreen extends StatefulWidget {
  final String communityName;
  final String ownerName;
  final DateTime dateOfBirth;
  final String gender;

  EnterCredentialsScreen(
      {this.communityName, this.ownerName, this.dateOfBirth, this.gender});

  @override
  _EnterCredentialsScreenState createState() => _EnterCredentialsScreenState();
}

class _EnterCredentialsScreenState extends State<EnterCredentialsScreen> {
  String phoneNumber;
  String gmailId;
  CountryCode countryCode = CountryCode(dialCode: '+91');
  bool pressed = false;

  String gmailValidator() {
    if (pressed) {
      if (gmailId == null || gmailId == '') {
        return 'Gmail Id is required';
      }
      if (!gmailId.contains(
          RegExp(r'^[a-z0-9](\.?[a-z0-9]){5,}@g(oogle)?mail\.com$'))) {
        return 'Enter a valid Id';
      }
    }
    return 'null';
  }

  String phoneNumberValidator() {
    if (pressed) {
      if (phoneNumber == null || phoneNumber == '') {
        return 'Mobile No. is required';
      }
      if (!phoneNumber.contains(RegExp(r'^[0-9]{10,12}$'))) {
        return 'Enter a valid mobile number';
      }
    }
    return 'null';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                              'Step 3 of 4',
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
                          'Your Credentials?',
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
                          'So that you can login your account.',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Product Sans',
                            color: Colors.black87,
                            fontSize: 15.0,
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              'Gmail Id',
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
                              padding: EdgeInsets.only(left: 10.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black54,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Icon(
                                      FontAwesomeIcons.google,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Expanded(
                                    flex: 12,
                                    child: TextField(
                                      onChanged: (id) {
                                        setState(() {
                                          gmailId = id;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        suffixIcon: gmailValidator() != 'null'
                                            ? Icon(
                                                FontAwesomeIcons
                                                    .exclamationCircle,
                                                color: Colors.red,
                                              )
                                            : null,
                                        border: InputBorder.none,
                                        hintText: 'E.g., sumitgarg@gmail.com',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Visibility(
                              visible:
                                  gmailValidator() == 'null' ? false : true,
                              child: Text(
                                gmailValidator(),
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
                              'Mobile No.',
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
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black54,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: CountryCodePicker(
                                      initialSelection: '+91',
                                      alignLeft: true,
                                      textStyle: TextStyle(
                                        fontFamily: 'Product Sans',
                                      ),
                                      onChanged: (code) {
                                        countryCode = code;
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      onChanged: (number) {
                                        setState(() {
                                          phoneNumber = number;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          FontAwesomeIcons.mobileAlt,
                                          color: Colors.black,
                                        ),
                                        suffixIcon:
                                            phoneNumberValidator() != 'null'
                                                ? Icon(
                                                    FontAwesomeIcons
                                                        .exclamationCircle,
                                                    color: Colors.red,
                                                  )
                                                : null,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Visibility(
                              visible: phoneNumberValidator() == 'null'
                                  ? false
                                  : true,
                              child: Text(
                                phoneNumberValidator(),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'ProductSans',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            FlatButton(
                              color: kContinueButtonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: () {
                                pressed = true;
                                setState(() {
                                  gmailValidator();
                                  phoneNumberValidator();
                                });
                                if (gmailValidator() == 'null' &&
                                    phoneNumberValidator() == 'null') {
                                  pressed = false;
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: ApartmentDetailsScreen(
                                        communityName: widget.communityName,
                                        ownerName: widget.ownerName,
                                        dateOfBirth: widget.dateOfBirth,
                                        gender: widget.gender,
                                        gmailId: gmailId,
                                        phoneNumber: countryCode.toString() +
                                            ' ' +
                                            phoneNumber,
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
                      height: 152.0,
                    ),
                    SizedBox(
                      width: 150.0,
                      child: Hero(
                        tag: 'indicator',
                        child: LinearProgressIndicator(
                          value: 0.5,
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
