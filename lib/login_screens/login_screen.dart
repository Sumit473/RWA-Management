import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home_page.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../register_screens/name_community_screen.dart';
import 'find_community.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../constants.dart';
import 'dart:io';
import '../secretary_homePage.dart';
import '../treasurer_homePage.dart';
import '../complaintManager_homePage.dart';

List<String> memberTypes = [
  'Resident',
  'Secretary',
  'Treasurer',
  'Complaint Manager'
];

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String communityName = 'Name of your Community';
  CountryCode countryCode = CountryCode(dialCode: '+91');
  String phoneNumber;
  String gmailId;
  String verificationId;
  String smsCode;
  bool pressed = false;
  bool isLoginWithGmail = true;
  bool isUserSignedIn = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String memberType = memberTypes[0];
  String gmailValidatorValue = 'null';
  bool showSpinner = false;

  Future<String> future() {
    if (isLoginWithGmail) {
      if (memberType == 'Resident') {
        return validateCommunityAndGmailIdForResident();
      } else if (memberType == 'Secretary') {
        return validateCommunityAndGmailIdForSecretary();
      } else if (memberType == 'Treasurer') {
        return validateCommunityAndGmailIdForTreasurer();
      } else if (memberType == 'Complaint Manager') {
        return validateCommunityAndGmailIdForComplaintManager();
      }
    } else {
      if (memberType == 'Resident') {
        return validateCommunityAndPhoneNumber();
      }
    }
    return null;
  }

  DropdownButtonFormField<String> dropDown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String memberType in memberTypes) {
      var newItem = DropdownMenuItem(
        value: memberType,
        child: Text(
          memberType,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );

      dropdownItems.add(newItem);
    }

    return DropdownButtonFormField(
      items: dropdownItems,
      value: memberType,
      onChanged: (value) {
        setState(() {
          memberType = value;
        });
      },
    );
  }

  Future<String> validateCommunityAndPhoneNumber() async {
    if (pressed == true &&
        communityName != 'Name of your Community' &&
        phoneNumber != null &&
        phoneNumber != '') {
      DocumentReference documentRef;
      documentRef = _firestore
          .collection('communities')
          .doc(communityName)
          .collection('users')
          .doc(phoneNumber);

      final snapshot = await documentRef.get();

      if (snapshot == null || !snapshot.exists) {
        return 'Invalid Phone Number!';
      } else {
        return 'null';
      }
    }
    if (pressed == true) {
      if (communityName == 'Name of your Community' &&
          (phoneNumber != null && phoneNumber != '')) {
        return 'Enter Community Name';
      } else if (communityName != 'Name of your Community' &&
          (phoneNumber == null || phoneNumber == '')) {
        return 'Enter Phone Number';
      } else if (communityName == 'Name of your Community' &&
          (phoneNumber == null || phoneNumber == '')) {
        return 'Enter Community Name and Phone Number';
      } else {
        return 'null';
      }
    } else {
      return 'null';
    }
  }

  Future<String> validateCommunityAndGmailIdForResident() async {
    if (pressed == true &&
        communityName != 'Name of your Community' &&
        gmailId != null) {
      DocumentReference documentRef;
      documentRef = _firestore
          .collection('communities')
          .doc(communityName)
          .collection('users')
          .doc(gmailId);

      final snapshot = await documentRef.get();

      if (!snapshot.exists) {
        return 'Invalid Sign!';
      } else {
        return 'null';
      }
    }

    if (pressed == true) {
      if (communityName == 'Name of your Community') {
        return 'Enter Community Name';
      } else if (communityName != 'Name of your Community') {
        return 'Google Sign is required!';
      } else {
        return 'null';
      }
    } else {
      return 'null';
    }
  }

  Future<String> validateCommunityAndGmailIdForSecretary() async {
    if (pressed == true &&
        communityName != 'Name of your Community' &&
        gmailId != null) {
      DocumentReference documentRef;
      documentRef = _firestore
          .collection('secretaries')
          .doc(communityName)
          .collection('data')
          .doc(gmailId);

      final snapshot = await documentRef.get();

      if (!snapshot.exists) {
        return 'Invalid Sign!';
      } else {
        return 'null';
      }
    }

    if (pressed == true) {
      if (communityName == 'Name of your Community') {
        return 'Enter Community Name';
      } else if (communityName != 'Name of your Community') {
        return 'Google Sign is required!';
      } else {
        return 'null';
      }
    } else {
      return 'null';
    }
  }

  Future<String> validateCommunityAndGmailIdForTreasurer() async {
    if (pressed == true &&
        communityName != 'Name of your Community' &&
        gmailId != null) {
      DocumentReference documentRef;
      documentRef = _firestore
          .collection('treasurers')
          .doc(communityName)
          .collection('data')
          .doc(gmailId);

      final snapshot = await documentRef.get();

      if (!snapshot.exists) {
        return 'Invalid Sign!';
      } else {
        return 'null';
      }
    }

    if (pressed == true) {
      if (communityName == 'Name of your Community') {
        return 'Enter Community Name';
      } else if (communityName != 'Name of your Community') {
        return 'Google Sign is required!';
      } else {
        return 'null';
      }
    } else {
      return 'null';
    }
  }

  Future<String> validateCommunityAndGmailIdForComplaintManager() async {
    if (pressed == true &&
        communityName != 'Name of your Community' &&
        gmailId != null) {
      DocumentReference documentRef;
      documentRef = _firestore
          .collection('complaint manager')
          .doc(communityName)
          .collection('data')
          .doc(gmailId);

      final snapshot = await documentRef.get();

      if (!snapshot.exists) {
        return 'Invalid Sign!';
      } else {
        return 'null';
      }
    }

    if (pressed == true) {
      if (communityName == 'Name of your Community') {
        return 'Enter Community Name';
      } else if (communityName != 'Name of your Community') {
        return 'Google Sign is required!';
      } else {
        return 'null';
      }
    } else {
      return 'null';
    }
  }

  Future<User> _handleSignIn() async {
    User user;
    bool isSignedIn = await _googleSignIn.isSignedIn();
    setState(() {
      isUserSignedIn = isSignedIn;
    });
    if (isSignedIn) {
      user = _auth.currentUser;
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      user = (await _auth.signInWithCredential(credential)).user;
      isSignedIn = await _googleSignIn.isSignedIn();
      setState(() {
        isUserSignedIn = isSignedIn;
      });
    }

    return user;
  }

  void onGoogleSignInForResident(BuildContext context) async {
    User user = await _handleSignIn();

    setState(() {
      gmailId = user.email;
    });

    gmailValidatorValue = await validateCommunityAndGmailIdForResident();

    if (user.email != null && gmailValidatorValue != 'Invalid Sign!') {
      setState(() {
        showSpinner = true;
      });
      showSpinner = await Future.delayed(Duration(seconds: 3), () => false);
      setState(() {
        showSpinner = false;
      });

      var userSignedIn = Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                communityName: communityName,
                phoneNumber: null,
                gmailId: user.email)),
        (r) => false,
      );
      setState(() {
        isUserSignedIn = userSignedIn == null ? true : false;
      });
    } else if (user.email != null && gmailValidatorValue == 'Invalid Sign!') {
      gmailId = null;
      await validateCommunityAndGmailIdForResident();
      await _googleSignIn.signOut();
      sleep(Duration(seconds: 2));
      setState(() {
        pressed = false;
      });
    } else {
      setState(() {
        pressed = false;
      });
    }
  }

  void onGoogleSignInForSecretary(BuildContext context) async {
    User user = await _handleSignIn();

    setState(() {
      gmailId = user.email;
    });

    gmailValidatorValue = await validateCommunityAndGmailIdForSecretary();

    if (user.email != null && gmailValidatorValue != 'Invalid Sign!') {
      setState(() {
        showSpinner = true;
      });
      showSpinner = await Future.delayed(Duration(seconds: 3), () => false);
      setState(() {
        showSpinner = false;
      });

      var userSignedIn = Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => SecretaryHomePage(
                communityName: communityName,
                phoneNumber: null,
                gmailId: user.email)),
        (r) => false,
      );
      setState(() {
        isUserSignedIn = userSignedIn == null ? true : false;
      });
    } else if (user.email != null && gmailValidatorValue == 'Invalid Sign!') {
      gmailId = null;
      await validateCommunityAndGmailIdForSecretary();
      await _googleSignIn.signOut();
      sleep(Duration(seconds: 2));
      setState(() {
        pressed = false;
      });
    } else {
      setState(() {
        pressed = false;
      });
    }
  }

  void onGoogleSignInForTreasurer(BuildContext context) async {
    User user = await _handleSignIn();

    setState(() {
      gmailId = user.email;
    });

    gmailValidatorValue = await validateCommunityAndGmailIdForTreasurer();

    if (user.email != null && gmailValidatorValue != 'Invalid Sign!') {
      setState(() {
        showSpinner = true;
      });
      showSpinner = await Future.delayed(Duration(seconds: 3), () => false);
      setState(() {
        showSpinner = false;
      });

      var userSignedIn = Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => TreasurerHomePage(
                communityName: communityName,
                phoneNumber: null,
                gmailId: user.email)),
        (r) => false,
      );
      setState(() {
        isUserSignedIn = userSignedIn == null ? true : false;
      });
    } else if (user.email != null && gmailValidatorValue == 'Invalid Sign!') {
      gmailId = null;
      await validateCommunityAndGmailIdForTreasurer();
      await _googleSignIn.signOut();
      sleep(Duration(seconds: 2));
      setState(() {
        pressed = false;
      });
    } else {
      setState(() {
        pressed = false;
      });
    }
  }

  void onGoogleSignInForComplaintManager(BuildContext context) async {
    User user = await _handleSignIn();

    setState(() {
      gmailId = user.email;
    });

    gmailValidatorValue =
        await validateCommunityAndGmailIdForComplaintManager();

    if (user.email != null && gmailValidatorValue != 'Invalid Sign!') {
      setState(() {
        showSpinner = true;
      });
      showSpinner = await Future.delayed(Duration(seconds: 3), () => false);
      setState(() {
        showSpinner = false;
      });

      var userSignedIn = Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => ComplaintManagerHomePage(
                communityName: communityName,
                phoneNumber: null,
                gmailId: user.email)),
        (r) => false,
      );
      setState(() {
        isUserSignedIn = userSignedIn == null ? true : false;
      });
    } else if (user.email != null && gmailValidatorValue == 'Invalid Sign!') {
      gmailId = null;
      await validateCommunityAndGmailIdForComplaintManager();
      await _googleSignIn.signOut();
      sleep(Duration(seconds: 2));
      setState(() {
        pressed = false;
      });
    } else {
      setState(() {
        pressed = false;
      });
    }
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter sms code'),
            content: TextField(
              onChanged: (value) {
                smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: [
              FlatButton(
                onPressed: () {
                  User user = _auth.currentUser;
                  Navigator.pop(context);
                  if (user != null) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          communityName: communityName,
                          phoneNumber: phoneNumber,
                          gmailId: null,
                        ),
                      ),
                      (r) => false,
                    );
                  } else {
                    PhoneAuthCredential phoneAuthCredential =
                        PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: smsCode,
                    );
                    _auth
                        .signInWithCredential(phoneAuthCredential)
                        .then((value) => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  communityName: communityName,
                                  phoneNumber: phoneNumber,
                                  gmailId: null,
                                ),
                              ),
                              (r) => false,
                            ))
                        .catchError(
                      (e) {
                        print(e);
                      },
                    );
                  }
                },
                child: Text('Done'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF191720),
        body: ModalProgressHUD(
          color: kBlackBackgroundColor,
          inAsyncCall: showSpinner,
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kYellowColor),
            strokeWidth: 5.0,
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: 40.0, right: 40.0, top: 50.0, bottom: 20.0),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Let\'s sign you in.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Product Sans',
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'Welcome back.',
                          style: TextStyle(
                            color: Color(0xFFDAD9DA),
                            fontSize: 25.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Product Sans',
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'You\'ve have been missed!',
                          style: TextStyle(
                            color: Color(0xFFDAD9DA),
                            fontSize: 25.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Product Sans',
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FutureBuilder<String>(
                          future: future(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Visibility(
                                visible: snapshot.data != 'null',
                                child: Text(
                                  snapshot.data,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Product Sans',
                                    fontSize: 15.0,
                                  ),
                                ),
                              );
                            } else {
                              return Visibility(
                                visible: false,
                                child: Text('Loading'),
                              );
                            }
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2.0, color: Color(0xFF777883)),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 10.0),
                              Expanded(child: dropDown()),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(23.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2.0, color: Color(0xFF777883)),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.search,
                                  color: Color(0xFF777883),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  communityName,
                                  style: TextStyle(
                                    color: Color(0xFF777883),
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            String name = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FindCommunity(),
                              ),
                            );
                            setState(() {
                              communityName = 'Name of your Community';
                            });
                            if (name != null && name != '') {
                              setState(() {
                                communityName = name;
                              });
                            }
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Visibility(
                          visible: !isLoginWithGmail,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2.0, color: Color(0xFF777883)),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: [
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
                                    decoration: InputDecoration(
                                      hintText: 'Your Mobile No.',
                                      hintStyle: TextStyle(
                                        color: Color(0xFF777883),
                                      ),
                                    ),
                                    onChanged: (number) {
                                      setState(() {
                                        phoneNumber = countryCode.toString() +
                                            ' ' +
                                            number;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: !isLoginWithGmail ? 21.0 : 93.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Don\'t  you have account?',
                              style: TextStyle(
                                color: Color(0xFF777883),
                              ),
                            ),
                            SizedBox(
                              width: 7.0,
                            ),
                            GestureDetector(
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: Color(0xFFFFC727),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Product Sans',
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, NameCommunityScreen.id);
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            isLoginWithGmail
                                ? Expanded(
                                    child: FlatButton(
                                      padding: EdgeInsets.all(18.0),
                                      color: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.google),
                                          SizedBox(
                                            width: 55.0,
                                          ),
                                          Text(
                                            'Sign in with Google',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'Product Sans',
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          pressed = true;
                                        });
                                        if (communityName !=
                                            'Name of your Community') {
                                          if (memberType == 'Resident') {
                                            onGoogleSignInForResident(context);
                                          } else if (memberType ==
                                              'Secretary') {
                                            onGoogleSignInForSecretary(context);
                                          } else if (memberType ==
                                              'Treasurer') {
                                            onGoogleSignInForTreasurer(context);
                                          } else if (memberType ==
                                              'Complaint Manager') {
                                            onGoogleSignInForComplaintManager(
                                                context);
                                          }
                                        }
                                      },
                                    ),
                                  )
                                : Expanded(
                                    child: FlatButton(
                                      padding: EdgeInsets.all(20.0),
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Text(
                                        'Sign in',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'Product Sans',
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          pressed = true;
                                        });
                                        if (communityName !=
                                            'Name of your Community') {
                                          _auth.verifyPhoneNumber(
                                            phoneNumber: phoneNumber,
                                            verificationCompleted:
                                                (PhoneAuthCredential
                                                    authCredential) {
                                              _auth.signInWithCredential(
                                                  authCredential);
                                            },
                                            verificationFailed:
                                                (FirebaseAuthException e) {
                                              print(e.message);
                                            },
                                            codeSent: (String verId,
                                                [int forceResendingToken]) {
                                              verificationId = verId;
                                              print('sms code sent');
                                              smsCodeDialog(context);
                                            },
                                            codeAutoRetrievalTimeout:
                                                (String verId) {
                                              verificationId = verId;
                                            },
                                            timeout: Duration(seconds: 8),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        GestureDetector(
                          child: Text(
                            isLoginWithGmail
                                ? 'or Use Mobile No. to Login'
                                : 'or Use Gmail ID to Login',
                            style: TextStyle(
                              color: Color(0xFFFFC727),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Product Sans',
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              pressed = false;
                            });
                            if (isLoginWithGmail) {
                              setState(() {
                                isLoginWithGmail = false;
                              });
                            } else {
                              setState(() {
                                isLoginWithGmail = true;
                              });
                            }
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
      ),
    );
  }
}
