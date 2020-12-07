import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../register_screens/name_community_screen.dart';

class FindCommunity extends StatefulWidget {
  @override
  _FindCommunityState createState() => _FindCommunityState();
}

class _FindCommunityState extends State<FindCommunity> {
  final _firestore = FirebaseFirestore.instance;
  String name;
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF191720),
          leading: Icon(
            FontAwesomeIcons.search,
            color: Colors.white,
          ),
          title: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'LOOK FOR YOUR COMMUNITY',
              hintStyle: TextStyle(
                color: Color(0xFF777883),
              ),
            ),
            autofocus: true,
            onChanged: (community) {
              setState(() {
                name = community;
              });
            },
          ),
          actions: [
            GestureDetector(
              child: Icon(FontAwesomeIcons.times),
              onTap: () {
                setState(() {
                  textEditingController.clear();
                });
              },
            ),
          ],
        ),
        backgroundColor: Color(0xFF191720),
        body: name == null || name == ''
            ? Center(child: Image.asset('images/search.png'))
            : StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('communities')
                    .where(
                      'communityName',
                      isGreaterThanOrEqualTo: name,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data.docs.length != 0) {
                    return Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              QueryDocumentSnapshot data =
                                  snapshot.data.docs[index];
                              return Card(
                                shadowColor: Color(0xFF777883),
                                color: Color(0xFF191720),
                                elevation: 3.0,
                                child: ListTile(
                                  title: Text(data['communityName']),
                                  trailing: Text(
                                    'Select',
                                    style: TextStyle(
                                      color: Color(0xFFFFC727),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context, data['communityName']);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        ListTile(
                          title: GestureDetector(
                            child: Text(
                              'Cannot Find your Community?',
                              style: TextStyle(
                                color: Color(0xFFFFC727),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, NameCommunityScreen.id);
                            },
                          ),
                        )
                      ],
                    );
                  } else {
                    return Center(child: Image.asset('images/search.png'));
                  }
                },
              ),
      ),
    );
  }
}
