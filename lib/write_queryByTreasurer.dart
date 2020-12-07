import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';

class WriteQueryByTreasurer extends StatefulWidget {
  final communityName;
  final phoneNumber;
  final gmailId;

  WriteQueryByTreasurer({this.communityName, this.phoneNumber, this.gmailId});

  @override
  _WriteQueryByTreasurerState createState() => _WriteQueryByTreasurerState();
}

class _WriteQueryByTreasurerState extends State<WriteQueryByTreasurer> {
  final _firestore = FirebaseFirestore.instance;
  final editTextController = TextEditingController();
  String queryTitle;
  String query;

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
            title: Text('Make Query'),
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
                        queryTitle = newText;
                      },
                      decoration: InputDecoration(
                        hintText: 'Query Title',
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
                        query = newText;
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
                    if (query != null && query != '' &&  queryTitle != null && queryTitle != '') {
                      var data = await getUsersDocumentData();
                      String name = data['name'];
                      String gmailId = data['gmailId'];
                      String phoneNumber = data['phoneNumber'];

                      _firestore.collection('secretaries').doc(widget.communityName).collection('queries').add({
                        'memberType': 'Treasurer',
                        'name': name,
                        'phoneNumber': phoneNumber,
                        'gmailId': gmailId,
                        'date': DateTime.now().toUtc(),
                        'queryTitle': queryTitle,
                        'query': query,
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
