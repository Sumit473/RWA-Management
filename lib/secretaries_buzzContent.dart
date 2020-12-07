import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class SecretaryBuzzContent extends StatefulWidget {
  final String communityName;
  final String phoneNumber;
  final String gmailId;

  SecretaryBuzzContent({this.communityName, this.phoneNumber, this.gmailId});

  @override
  _SecretaryBuzzContentState createState() => _SecretaryBuzzContentState();
}

class _SecretaryBuzzContentState extends State<SecretaryBuzzContent> {
  String messageText;
  final messageTextController = TextEditingController();

  DocumentReference getUsersDocumentReference(String documentId) {
    DocumentReference documentRef;

    documentRef = _firestore
        .collection('secretaries')
        .doc(widget.communityName)
        .collection('data')
        .doc(documentId);

    return documentRef;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
        EdgeInsets.only(left: 20.0, top: 25.0, bottom: 30.0, right: 10.0),
        child: Stack(
          children: <Widget>[
            Center(child: Icon(FontAwesomeIcons.globe, size: 280.0, color: Color(0x50FEC64F),)),
            Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: widget.gmailId == null
                      ? _firestore
                      .collection('communities')
                      .doc(widget.communityName)
                      .collection('messagesWithCredentials')
                      .doc('byPhoneNumber')
                      .collection('messages')
                      .snapshots()
                      : _firestore
                      .collection('communities')
                      .doc(widget.communityName)
                      .collection('messagesWithCredentials')
                      .doc('byGmailId')
                      .collection('messages')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final messages = snapshot.data.docs;
                      List<MessageBubble> messageWidgets = [];
                      for (var message in messages) {
                        final messageText = message.data()['text'];
                        final messageSender = message.data()['sender'];

                        final messageWidget = MessageBubble(
                          sender: messageSender,
                          textMessage: messageText,
                          isMe: widget.gmailId == null
                              ? widget.phoneNumber == messageSender
                              : widget.gmailId == messageSender,
                          communityName: widget.communityName,
                        );

                        messageWidgets.add(messageWidget);
                      }
                      return Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20.0),
                          children: messageWidgets,
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color(0xFFFEC64F),
                      ),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                            controller: messageTextController,
                            onChanged: (text) {
                              messageText = text;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              hintText: 'Type message...',
                              hintStyle: TextStyle(
                                color: Color(0xFFC8C8C8),
                                fontFamily: 'Product Sans',
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Icon(
                            FontAwesomeIcons.chevronCircleRight,
                            color: Color(0xFF467DFC),
                            size: 55.0,
                          ),
                          onTap: () async {
                            if (messageText != null && messageText != '') {
                              messageTextController.clear();
                              if (widget.gmailId == null) {
                                _firestore
                                    .collection('communities')
                                    .doc(widget.communityName)
                                    .collection('messagesWithCredentials')
                                    .doc('byPhoneNumber')
                                    .collection('messages')
                                    .add({
                                  'text': messageText,
                                  'sender': widget.phoneNumber,
                                });

                                Map<String, dynamic> data;
                                await getUsersDocumentReference(widget.phoneNumber)
                                    .get()
                                    .then((snapshot) {
                                  data = snapshot.data();
                                });
                                String gmailId = data['gmailId'];

                                _firestore
                                    .collection('communities')
                                    .doc(widget.communityName)
                                    .collection('messagesWithCredentials')
                                    .doc('byGmailId')
                                    .collection('messages')
                                    .add({
                                  'text': messageText,
                                  'sender': gmailId,
                                });
                              } else {
                                _firestore
                                    .collection('communities')
                                    .doc(widget.communityName)
                                    .collection('messagesWithCredentials')
                                    .doc('byGmailId')
                                    .collection('messages')
                                    .add({
                                  'text': messageText,
                                  'sender': widget.gmailId,
                                });

                                Map<String, dynamic> data;
                                await getUsersDocumentReference(widget.gmailId)
                                    .get()
                                    .then((snapshot) {
                                  data = snapshot.data();
                                });
                                String phoneNumber = data['phoneNumber'];

                                _firestore
                                    .collection('communities')
                                    .doc(widget.communityName)
                                    .collection('messagesWithCredentials')
                                    .doc('byPhoneNumber')
                                    .collection('messages')
                                    .add({
                                  'text': messageText,
                                  'sender': phoneNumber,
                                });
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String textMessage;
  final bool isMe;
  final String communityName;
  MessageBubble(
      {@required this.sender,
        @required this.textMessage,
        @required this.isMe,
        @required this.communityName});

  Future<Map<String, dynamic>> getUsersDocumentData(String sender) async {
    DocumentReference documentRef;

    documentRef = _firestore
        .collection('communities')
        .doc(communityName)
        .collection('users')
        .doc(sender);

    Map<String, dynamic> data;

    await documentRef.get().then((snapshot) {
      data = snapshot.data();
    });

    if (data == null) {
      documentRef = _firestore
          .collection('secretaries')
          .doc(communityName)
          .collection('data')
          .doc(sender);

      await documentRef.get().then((snapshot) {
        data = snapshot.data();
      });
    }

    if (data == null) {
      documentRef = _firestore
          .collection('treasurers')
          .doc(communityName)
          .collection('data')
          .doc(sender);
      await documentRef.get().then((snapshot) {
        data = snapshot.data();
      });
    }

    if (data == null) {
      documentRef = _firestore
          .collection('complaint manager')
          .doc(communityName)
          .collection('data')
          .doc(sender);

      await documentRef.get().then((snapshot) {
        data = snapshot.data();
      });

    }

    return data;
  }

  String getInitials(String fullName) {
    List<String> splits = fullName.split(' ');

    return fullName.substring(0, splits[0].length);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment:
        isMe ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Material(
              borderRadius: isMe
                  ? BorderRadius.only(
                topLeft: Radius.circular(50.0),
                bottomLeft: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0),
              )
                  : BorderRadius.only(
                topRight: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0),
                bottomLeft: Radius.circular(25.0),
              ),
              elevation: 10.0,
              color: isMe ? Color(0xFF4B4F5A) : Color(0xFF2A2E37),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        isMe
                            ? Text(
                          'You',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Product Sans',
                            color: isMe
                                ? Color(0xFFFEC64F)
                                : Color(0xFFF1F2F2),
                          ),
                        )
                            : FutureBuilder(
                          future: getUsersDocumentData(sender),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return Text(
                                snapshot.data == null ? 'Admin' : getInitials(snapshot.data['name']),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Product Sans',
                                  color: isMe
                                      ? Color(0xFFFEC64F)
                                      : Color(0xFFF1F2F2),
                                ),
                              );
                            }
                            else {
                              return Text(
                                'Loading...',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Product Sans',
                                  color: isMe
                                      ? Color(0xFFFEC64F)
                                      : Color(0xFFF1F2F2),
                                ),
                              );
                            }
                          },
                        ),
                        Text(
                          'Time',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Product Sans',
                            color: Color(0xFFF1F2F2),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      textMessage,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontFamily: 'Product Sans',
                        color: Color(0xFFF1F2F2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Visibility(
            visible: isMe ? false : true,
            child: GestureDetector(
              child: Icon(
                FontAwesomeIcons.heart,
                color: Colors.red,
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
