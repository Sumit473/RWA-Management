import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants.dart';
import 'dart:math';

class FileAComplaint extends StatefulWidget {
  final communityName;
  final phoneNumber;
  final gmailId;

  FileAComplaint({this.communityName, this.phoneNumber, this.gmailId});

  @override
  _FileAComplaintState createState() => _FileAComplaintState();
}

class _FileAComplaintState extends State<FileAComplaint> {
  final _firestore = FirebaseFirestore.instance;
  final editTextController = TextEditingController();
  String complaintTitle;
  String complaint;
  String _chars = '1234567890';
  Random _rnd = Random();
  
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      TextSpan text = new TextSpan(
        text: editTextController.text,
      );

      TextPainter tp = new TextPainter(
        text: text,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
      );
      tp.layout(maxWidth: size.maxWidth);

      int lines = (tp.size.height / tp.preferredLineHeight).ceil();
      int maxLines = 6;

      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('File a complaint'),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget> [
                    TextField(
                      autofocus: true,
                      onChanged: (newText) {
                        complaintTitle = newText;
                      },
                      decoration: InputDecoration(
                        hintText: 'Complaint Title',
                      ),
                    ),
                    SizedBox(height: 30.0,),
                    TextField(
                      autofocus: true,
                      controller: editTextController,
                      maxLines: lines > maxLines ? null : maxLines,
                      textInputAction: TextInputAction.newline,
                      decoration:
                      InputDecoration(hintText: "Start Writing here..."),
                      onChanged: (newText) {
                        complaint = newText;
                      },
                    ),
                  ],
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  color: kYellowColor,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  onPressed: () async{
                    if (complaint != null && complaint != '' &&  complaintTitle != null && complaintTitle != '') {
                      var data = await getUsersDocumentData();
                      String name = data['name'];
                      String gmailId = data['gmailId'];
                      String phoneNumber = data['mobileNumber'];

                      _firestore.collection('complaint manager').doc(widget.communityName).collection('complaints').add({
                        'ticketNo': getRandomString(7),
                        'name': name,
                        'phoneNumber': phoneNumber,
                        'gmailId': gmailId,
                        'date': DateTime.now().toUtc(),
                        'complaintTitle': complaintTitle,
                        'complaint': complaint,
                        'status': 'Not Solved',
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
