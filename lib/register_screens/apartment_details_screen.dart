import 'dart:async';
import 'package:RWA/constants.dart';
import 'package:RWA/login_or_register_or_myStatus_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ApartmentDetailsScreen extends StatefulWidget {
  final String communityName;
  final String ownerName;
  final DateTime dateOfBirth;
  final String gender;
  final String phoneNumber;
  final String gmailId;

  ApartmentDetailsScreen(
      {this.communityName,
      this.ownerName,
      this.dateOfBirth,
      this.gender,
      this.phoneNumber,
      this.gmailId});

  @override
  _ApartmentDetailsScreenState createState() => _ApartmentDetailsScreenState();
}

class _ApartmentDetailsScreenState extends State<ApartmentDetailsScreen> {
  String unitNo;
  String block;
  bool pressed = false;
  bool showSpinner = false;

  final _firestore = FirebaseFirestore.instance;

  String unitNumberValidator() {
    if (pressed) {
      if (unitNo == null || unitNo == '') {
        return 'Enter your unit no.';
      }
      if (!unitNo.contains(RegExp(r'^[0-9]{1,6}$'))) {
        return 'Enter a valid no.';
      }
    }
    return 'null';
  }

  String blockValidator() {
    if (pressed) {
      if (block == null) {
        return 'null';
      }
      if (block != '' && !block.contains(RegExp(r'^[a-zA-Z]{1,6}$'))) {
        return 'Enter a valid block';
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
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            progressIndicator: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kYellowColor),
              strokeWidth: 5.0,
            ),
            child: Padding(
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
                                'Step 4 of 4',
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
                            'Your Apartment Details?',
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
                            'For our own knowledge, will not be shared publicly',
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
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          'Your Block',
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
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: TextField(
                                            onChanged: (blockInfo) {
                                              setState(() {
                                                block = blockInfo;
                                              });
                                            },
                                            decoration: InputDecoration(
                                              suffixIcon:
                                                  blockValidator() != 'null'
                                                      ? Icon(
                                                          FontAwesomeIcons
                                                              .exclamationCircle,
                                                          color: Colors.red,
                                                        )
                                                      : null,
                                              border: InputBorder.none,
                                              hintText: 'E.g., Block A',
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3.0,
                                        ),
                                        Visibility(
                                          visible: blockValidator() == 'null'
                                              ? false
                                              : true,
                                          child: Text(
                                            blockValidator(),
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'ProductSans',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          'Your Unit No.',
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
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: TextField(
                                            onChanged: (unit) {
                                              setState(() {
                                                unitNo = unit;
                                              });
                                            },
                                            decoration: InputDecoration(
                                              suffixIcon:
                                                  unitNumberValidator() !=
                                                          'null'
                                                      ? Icon(
                                                          FontAwesomeIcons
                                                              .exclamationCircle,
                                                          color: Colors.red,
                                                        )
                                                      : null,
                                              border: InputBorder.none,
                                              hintText: 'E.g., 101',
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3.0,
                                        ),
                                        Visibility(
                                          visible:
                                              unitNumberValidator() == 'null'
                                                  ? false
                                                  : true,
                                          child: Text(
                                            unitNumberValidator(),
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'ProductSans',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              FlatButton(
                                color: Color(0xFFFEC64F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                onPressed: () async {
                                  pressed = true;
                                  setState(() {
                                    unitNumberValidator();
                                    blockValidator();
                                  });
                                  if (unitNumberValidator() == 'null' &&
                                      blockValidator() == 'null') {
                                    final documentReference = _firestore
                                        .collection('communities')
                                        .doc(widget.communityName);
                                    documentReference.set({
                                      'communityName': widget.communityName
                                    });
                                    final userCollectionReference =
                                        documentReference.collection('users');
                                    userCollectionReference
                                        .doc(widget.phoneNumber)
                                        .set({
                                      'name': widget.ownerName,
                                      'DOB': widget.dateOfBirth,
                                      'gender': widget.gender,
                                      'gmailId': widget.gmailId,
                                      'mobileNumber': widget.phoneNumber,
                                      'block': block == null ? 'null' : block,
                                      'unitNo': unitNo,
                                    });
                                    userCollectionReference
                                        .doc(widget.gmailId)
                                        .set({
                                      'name': widget.ownerName,
                                      'DOB': widget.dateOfBirth,
                                      'gender': widget.gender,
                                      'gmailId': widget.gmailId,
                                      'mobileNumber': widget.phoneNumber,
                                      'block': block == null ? 'null' : block,
                                      'unitNo': unitNo,
                                    });

                                    setState(() {
                                      showSpinner = true;
                                    });
                                    showSpinner = await Future.delayed(
                                        Duration(seconds: 3), () => false);
                                    setState(() {
                                      showSpinner = false;
                                    });

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LoginOrRegisterOrMyStatusScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    'REGISTER',
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
                          )
                        ],
                      ),
                      SizedBox(
                        height: 206,
                      ),
                      SizedBox(
                        width: 150.0,
                        child: Hero(
                          tag: 'indicator',
                          child: LinearProgressIndicator(
                            value: 0.75,
                            backgroundColor: Colors.grey,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFFEC64F)),
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
      ),
    );
  }
}
