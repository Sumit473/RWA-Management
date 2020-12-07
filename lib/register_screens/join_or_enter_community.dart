import 'package:RWA/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JoinOrEnterCommunity extends StatefulWidget {
  @override
  _JoinOrEnterCommunityState createState() => _JoinOrEnterCommunityState();
}

class _JoinOrEnterCommunityState extends State<JoinOrEnterCommunity> {
  final _firestore = FirebaseFirestore.instance;
  String name;
  final textEditingController = TextEditingController();
  List<String> matchingNames = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Icon(
            FontAwesomeIcons.igloo,
            color: Colors.black54,
          ),
          title: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'NAME OF YOUR COMMUNITY',
              hintStyle: TextStyle(
                color: kHintColor,
              ),
            ),
            autofocus: true,
            onChanged: (community) {
              setState(() {
                name = community;
              });
            },
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            GestureDetector(
              child: Icon(
                FontAwesomeIcons.times,
                color: Colors.black54,
              ),
              onTap: () {
                setState(() {
                  textEditingController.clear();
                  name = '';
                });
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: name == null || name == ''
            ? Center(child: Hero(tag: 'welcome_image',child: Image.asset('images/high_five.png')))
            : StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('communities')
                    .where(
                      'communityName',
                      isGreaterThanOrEqualTo: name,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  return Column(
                    children: <Widget>[
                      Visibility(
                        visible: !matchingNames.contains(name),
                        child: Card(
                          elevation: 4.0,
                          color: kSelectedColor,
                          child: ListTile(
                            title: Text(
                              name,
                              style: TextStyle(color: Colors.black),
                            ),
                            trailing: Text(
                              'Create',
                              style: TextStyle(
                                color: kYellowColor,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context, name);
                            },
                          ),
                        ),
                      ),
                      snapshot.hasData && snapshot.data.docs.length != 0
                          ? Expanded(
                              flex: 20,
                              child: ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  QueryDocumentSnapshot data =
                                      snapshot.data.docs[index];
                                  if (!matchingNames
                                      .contains(data['communityName'])) {
                                    matchingNames.add(data['communityName']);
                                  }
                                  return Card(
                                    elevation: 3.0,
                                    color: matchingNames.contains(name) && index == 0 ? kSelectedColor : Colors.white,
                                    child: ListTile(
                                      title: Text(
                                        data['communityName'],
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      trailing: Text(
                                        'Join',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: kYellowColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(
                                            context, data['communityName']);
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                          : Expanded(child: Center(child: Image.asset('images/high_five.png'))),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
