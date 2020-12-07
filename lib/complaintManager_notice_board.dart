import 'reusable_components/reusable_display.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_notice.dart';
import 'constants.dart';

class ComplaintManagerNoticeBoard extends StatefulWidget {
  final communityName;
  final phoneNumber;
  final gmailId;

  ComplaintManagerNoticeBoard({this.communityName, this.phoneNumber, this.gmailId});

  @override
  _ComplaintManagerNoticeBoardState createState() => _ComplaintManagerNoticeBoardState();
}

class _ComplaintManagerNoticeBoardState extends State<ComplaintManagerNoticeBoard> {
  final _firestore = FirebaseFirestore.instance;
  Color _isImportant = ThemeData.dark().disabledColor;
  final List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  String title;
  String description;
  List<String> issuedNotice;

  String getInitials(String fullName) {
    List<String> splits = fullName.split(' ');

    return fullName.substring(0, splits[0].length);
  }

  Future<Map<String, dynamic>> getUsersDocumentData() async {
    DocumentReference documentRef;

    if (widget.gmailId == null) {
      documentRef = _firestore
          .collection('complaint manager')
          .doc(widget.communityName)
          .collection('data')
          .doc(widget.phoneNumber);
    } else {
      documentRef = _firestore
          .collection('complaint manager')
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Notice Board'),
        actions: [IconButton(icon: Icon(Icons.filter_list), onPressed: () {})],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 30.0,
        ),
        backgroundColor: kYellowColor,
        onPressed: () async {
          issuedNotice = await showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => AddNotice(),
            isScrollControlled: true,
          );
          if (issuedNotice != null) {
            description = issuedNotice[0];
            title = issuedNotice[1];

            var data = await getUsersDocumentData();

            _firestore
                .collection('communities')
                .doc(widget.communityName)
                .collection('notices')
                .add({
              'admin': 'Complaint Manager',
              'name': data['name'],
              'title': title,
              'description': description,
              'date': DateTime.now().toUtc(),
            });
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ReusableDisplay(
        imageNo: 16,
        description:
        'View the latest notices \nand Issue new ones from the RWA \nand stay updated on the society affairs.',
        displaychild: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('communities')
              .doc(widget.communityName)
              .collection('notices')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final notices = snapshot.data.docs;
              List<String> admins = [];
              List<String> names = [];
              List<String> titles = [];
              List<String> descriptions = [];
              List<Timestamp> dates = [];

              for (var notice in notices) {
                final admin = notice['admin'];
                final name = notice['name'];
                final title = notice['title'];
                final description = notice['description'];
                final date = notice['date'];

                admins.add(admin);
                names.add(name);
                titles.add(title);
                descriptions.add(description);
                dates.add(date);
              }
              return ListView.builder(
                itemCount: descriptions.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('images/1.png'),
                        ),
                        title: Text(
                          titles[index],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: kYellowColor),
                        ),
                        subtitle: Text(
                          "${dates[index].toDate().day} ${months[dates[index].toDate().month - 1]}, ${dates[index].toDate().year}:\t${descriptions[index]}",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: GestureDetector(
                            child: Icon(
                              Icons.label_important,
                              color: _isImportant,
                            ),
                            onTap: () {
                              if (_isImportant ==
                                  ThemeData.dark().disabledColor) {
                                setState(() {
                                  _isImportant = Color(0xFFFFC727);
                                });
                              } else {
                                setState(() {
                                  _isImportant = ThemeData.dark().disabledColor;
                                });
                              }
                            }),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundImage:
                                        AssetImage('images/1.png'),
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            titles[index],
                                            style: TextStyle(fontSize: 25.0, color: kYellowColor),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${admins[index]}    ${getInitials(names[index])}',
                                                style:
                                                TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(width: 10.0),
                                              Text(
                                                "${dates[index].toDate().day} ${months[dates[index].toDate().month - 1]}, ${dates[index].toDate().year}",
                                                style:
                                                TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  content: Text("${descriptions[index]}"),
                                  scrollable: true,
                                );
                              });
                        },
                        onLongPress: () {

                        },
                      ),
                      Divider(),
                    ],
                  );
                },
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
    );
  }
}
