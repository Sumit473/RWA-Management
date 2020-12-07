import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'constants.dart';

enum DPEdit { upload, camera, delete }

final _firestore = FirebaseFirestore.instance;

class TreasurerProfileContent extends StatefulWidget {
  final String communityName;
  final String phoneNumber;
  final String gmailId;

  TreasurerProfileContent({this.communityName, this.phoneNumber, this.gmailId});

  @override
  _TreasurerProfileContentState createState() => _TreasurerProfileContentState();
}

class _TreasurerProfileContentState extends State<TreasurerProfileContent> {
  String memberName;
  String gender;
  int age;
  File _image;
  final picker = ImagePicker();

  int getAge(DateTime dob) {
    DateTime now = DateTime.now();

    int age = now.year - dob.year;

    if (age <= 0) {
      return 0;
    }
    if (now.month < dob.month) {
      age--;
    } else if (now.month == dob.month) {
      if (now.day < now.day) {
        age--;
      }
    }

    return age;
  }

  Future<Map<String, dynamic>> getUsersDocumentData() async {
    DocumentReference documentRef;

    if (widget.gmailId == null) {
      documentRef = _firestore
          .collection('treasurers')
          .doc(widget.communityName)
          .collection('data')
          .doc(widget.phoneNumber);
    } else {
      documentRef = _firestore
          .collection('treasurers')
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

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile == null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            child: PopupMenuButton<DPEdit>(
              icon: Icon(Icons.add_photo_alternate),
              onSelected: (DPEdit result) {
                if (result == DPEdit.upload) {
                  getImage(ImageSource.gallery);
                } else if (result == DPEdit.camera) {
                  getImage(ImageSource.camera);
                } else {
                  setState(() {
                    _image = null;
                  });
                }
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
                const PopupMenuItem<DPEdit>(
                  value: DPEdit.delete,
                  child: Text('Remove'),
                ),
              ],
            ),
            radius: 55.0,
            backgroundColor: Colors.white,
            backgroundImage: _image != null
                ? FileImage(_image)
                : AssetImage('images/17.png'),
          ),
          SizedBox(
            height: 5.0,
          ),
          FutureBuilder(
            future: getUsersDocumentData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(
                  '${snapshot.data['name']}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600,
                  ),
                );
              } else {
                return Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }
            },
          ),
          Divider(),
          ListTile(
            title: Text(
              'Treasurer of',
              textScaleFactor: 1.1,
              style: TextStyle(color: kYellowColor, fontSize: 20.0),
            ),
            subtitle: Text(
              '${widget.communityName}',
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Private details',
              textScaleFactor: 1.1,
              style: TextStyle(color: kYellowColor, fontSize: 20.0,),
            ),
            subtitle: FutureBuilder(
              future: getUsersDocumentData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    'Gmail Id: ${snapshot.data['gmailId']}\nGender: ${snapshot.data['gender']}\nAge: ${getAge(snapshot.data['DOB'].toDate())}',
                  );
                } else {
                  return Text(
                    'Loading...',
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
