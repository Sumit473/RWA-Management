import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Color _yellowcolor = Color(0xFFFFC727);
Color _defaultgrey = Color(0xFFACADB1);

enum DPEdit { upload, camera }
enum Gender { male, female, other }

TextStyle _textStyle = TextStyle(color: Colors.white60);
TextStyle _headerStyle = TextStyle(
  color: _yellowcolor,
  fontSize: 17,
);

class AddMemberScreen extends StatefulWidget {
  final String communityName;
  final String phoneNumber;
  final String gmailId;


  AddMemberScreen({this.communityName, this.phoneNumber, this.gmailId});

  @override
  _AddMemberScreenState createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _firestore = FirebaseFirestore.instance;
  String memberName;
  Gender gender = Gender.male;
  DateTime dob = DateTime.utc(2000);

  DocumentReference getUsersDocumentReference(String documentId) {
    DocumentReference documentRef;

    documentRef = _firestore
        .collection('communities')
        .doc(widget.communityName)
        .collection('users')
        .doc(documentId);

    return documentRef;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF1B1B1B),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: Column(
            children: [
              Text(
                'Add Member',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
              Divider(
                color: _yellowcolor,
                thickness: 1.0,
              ),
              SizedBox(
                height: 15.0,
              ),
              PopupMenuButton<DPEdit>(
                icon: Icon(Icons.add_photo_alternate),
                onSelected: (DPEdit result) {
                  //setState(() { _selection = result; },);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<DPEdit>>[
                  const PopupMenuItem<DPEdit>(
                    value: DPEdit.upload,
                    child: Text('Upload a new picture'),
                  ),
                  const PopupMenuItem<DPEdit>(
                    value: DPEdit.camera,
                    child: Text('Take a new picture'),
                  ),
                ],
              ),
              TextField(
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.account_box,
                    color: _defaultgrey,
                  ),
                  hintText: 'Full Name',
                  hintStyle: TextStyle(
                    color: _defaultgrey,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _defaultgrey,
                    ),
                  ),
                ),
                onChanged: (name) {
                  memberName = name;
                },
              ),
              ListTile(
                title: Text(
                  'Gender',
                  style: _headerStyle,
                ),
              ),
              ListTile(
                title: Text(
                  'Male',
                  style: _textStyle,
                ),
                trailing: Radio(
                  activeColor: _yellowcolor,
                  value: Gender.male,
                  groupValue: gender,
                  onChanged: (Gender value) {
                    setState(
                      () {
                        gender = value;
                      },
                    );
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'Female',
                  style: _textStyle,
                ),
                trailing: Radio(
                  activeColor: _yellowcolor,
                  value: Gender.female,
                  groupValue: gender,
                  onChanged: (Gender value) {
                    setState(
                      () {
                        gender = value;
                      },
                    );
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'Other',
                  style: _textStyle,
                ),
                trailing: Radio(
                  activeColor: _yellowcolor,
                  value: Gender.other,
                  groupValue: gender,
                  onChanged: (Gender value) {
                    setState(
                      () {
                        gender = value;
                      },
                    );
                  },
                ),
              ),
              Divider(
                color: _defaultgrey,
              ),
              ListTile(
                title: Text(
                  'Date of birth',
                  style: _headerStyle,
                ),
              ),
              Container(
                height: 80.0,
                child: CupertinoDatePicker(
                  maximumDate: DateTime.now(),
                  backgroundColor: _defaultgrey,
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime.utc(2000),
                  onDateTimeChanged: (DateTime dateOfBirth) {
                    dob = dateOfBirth;
                  },
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton(
                color: ThemeData.dark().scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                onPressed: () async {
                  if (widget.gmailId == null) {
                    getUsersDocumentReference(widget.phoneNumber).collection('members').doc(memberName + gender.toString() + dob.toString()).set({
                      'name': memberName,
                      'gender': gender
                          .toString()
                          .substring(gender.toString().indexOf('.') + 1),
                      'DOB': dob,
                    });

                     Map<String, dynamic> documentData;
                     await getUsersDocumentReference(widget.phoneNumber).get().then((snapshot) {documentData = snapshot.data();});

                     String gmailId = documentData['gmailId'];

                     getUsersDocumentReference(gmailId).collection('members').doc(memberName + gender.toString() + dob.toString()).set({
                       'name': memberName,
                       'gender': gender
                           .toString()
                           .substring(gender.toString().indexOf('.') + 1),
                       'DOB': dob,
                     });
                  }
                  else {
                    getUsersDocumentReference(widget.gmailId).collection('members').doc(memberName + gender.toString() + dob.toString()).set({
                      'name': memberName,
                      'gender': gender
                          .toString()
                          .substring(gender.toString().indexOf('.') + 1),
                      'DOB': dob,
                    });

                    Map<String, dynamic> documentData;
                    await getUsersDocumentReference(widget.gmailId).get().then((snapshot) {documentData = snapshot.data();});

                    String phoneNumber = documentData['gmailId'];

                    getUsersDocumentReference(phoneNumber).collection('members').doc(memberName + gender.toString() + dob.toString()).set({
                      'name': memberName,
                      'gender': gender
                          .toString()
                          .substring(gender.toString().indexOf('.') + 1),
                      'DOB': dob,
                    });
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
