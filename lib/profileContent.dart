import 'dart:io';
import 'package:flutter/material.dart';
import 'add_member_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

Color _yellowcolor = Color(0xFFFFC727);

enum MemberEdit { edit, delete }
enum DPEdit { upload, camera, delete }

final _firestore = FirebaseFirestore.instance;

class ProfileContent extends StatefulWidget {
  final String communityName;
  final String phoneNumber;
  final String gmailId;

  ProfileContent({this.communityName, this.phoneNumber, this.gmailId});

  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
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
          .collection('communities')
          .doc(widget.communityName)
          .collection('users')
          .doc(widget.phoneNumber);
    } else {
      documentRef = _firestore
          .collection('communities')
          .doc(widget.communityName)
          .collection('users')
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
              'Address',
              textScaleFactor: 1.1,
              style: TextStyle(color: _yellowcolor),
            ),
            subtitle: FutureBuilder(
              future: getUsersDocumentData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    snapshot.data['block'] != 'null'
                        ? '${snapshot.data['block']}-${snapshot.data['unitNo']}, ${widget.communityName}'
                        : '${snapshot.data['unitNo']}, ${widget.communityName}',
                  );
                } else {
                  return Text(
                    'Loading...',
                  );
                }
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Primary member details',
              textScaleFactor: 1.1,
              style: TextStyle(color: _yellowcolor),
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
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Members',
                style: TextStyle(
                  color: _yellowcolor,
                  fontSize: 25.0,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              IconButton(
                iconSize: 25,
                icon: Icon(Icons.person_add),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) => AddMemberScreen(
                      communityName: widget.communityName,
                      phoneNumber: widget.phoneNumber,
                      gmailId: widget.gmailId,
                    ),
                    isScrollControlled: true,
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0),
                ),
                color: Colors.black,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: widget.gmailId == null
                    ? _firestore
                        .collection('communities')
                        .doc(widget.communityName)
                        .collection('users')
                        .doc(widget.phoneNumber)
                        .collection('members')
                        .snapshots()
                    : _firestore
                        .collection('communities')
                        .doc(widget.communityName)
                        .collection('users')
                        .doc(widget.gmailId)
                        .collection('members')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final members = snapshot.data.docs;
                    List<MemberCard> memberWidgets = [];
                    int index = -1;

                    for (var member in members) {
                      final memberName = member['name'];
                      final gender = member['gender'];
                      final dob = member['DOB'];
                      index++;
                      final messageWidget = MemberCard(
                        name: memberName,
                        gender: gender,
                        age: getAge(dob.toDate()),
                        snapshot: snapshot,
                        index: index,
                      );
                      memberWidgets.add(messageWidget);
                    }
                    return ListView(
                      padding: EdgeInsets.only(bottom: 10.0),
                      children: memberWidgets,
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color(0xFFFEC64F),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final String name;
  final String gender;
  final int age;
  final int index;
  final AsyncSnapshot<QuerySnapshot> snapshot;

  MemberCard({this.name, this.gender, this.age, this.index, this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        color: ThemeData.dark().scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('images/20.png'),
          radius: 25,
        ),
        title: Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        isThreeLine: true,
        subtitle: Text(
          'Gender: $gender\nAge: $age',
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white60,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            await _firestore.runTransaction((Transaction myTransaction) async {
              myTransaction.delete(snapshot.data.docs[index].reference);
            });
          },
          highlightColor: Colors.red,
          splashRadius: 3.0,
          splashColor: Colors.red,
        ),
        contentPadding: EdgeInsets.all(2),
      ),
    );
  }
}
