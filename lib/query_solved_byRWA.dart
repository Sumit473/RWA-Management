import 'reusable_components/reusable_display.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';

class QuerySolvedByRWA extends StatefulWidget {
  final communityName;
  final phoneNumber;
  final gmailId;

  QuerySolvedByRWA({this.communityName, this.phoneNumber, this.gmailId});

  @override
  _QuerySolvedByRWAState createState() => _QuerySolvedByRWAState();
}

class _QuerySolvedByRWAState extends State<QuerySolvedByRWA> {
  final _firestore = FirebaseFirestore.instance;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Manage Queries'),
      ),
      body: ReusableDisplay(
        imageNo: 1,
        description: 'Manage the queries of residents and other admins',
        displaychild: StreamBuilder(
            stream: widget.gmailId != null
                ? _firestore
                    .collection('secretaries')
                    .doc(widget.communityName)
                    .collection('queries')
                    .snapshots()
                : _firestore
                    .collection('secretaries')
                    .doc(widget.communityName)
                    .collection('queries')
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final queries = snapshot.data.docs;
                List<String> statuses = [];
                List<String> queryTitles = [];
                List<String> queryDescriptions = [];
                List<Timestamp> dates = [];
                List<String> memberTypes = [];
                List<String> gmailIds = [];

                for (var query in queries) {
                  final status = query['status'];
                  final title = query['queryTitle'];
                  final description = query['query'];
                  final date = query['date'];
                  final memberType = query['memberType'];
                  final gmailId = query['gmailId'];

                  statuses.add(status);
                  queryTitles.add(title);
                  queryDescriptions.add(description);
                  dates.add(date);
                  memberTypes.add(memberType);
                  gmailIds.add(gmailId);
                }

                return ListView.builder(
                    itemCount: queryTitles.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              queryTitles[index],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: kYellowColor),
                            ),
                            subtitle: Text(
                              "${dates[index].toDate().day} ${months[dates[index].toDate().month - 1]}, ${dates[index].toDate().year}:\t${queryDescriptions[index]}",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: statuses[index] == 'Not Solved'
                                      ? ThemeData.dark().disabledColor
                                      : Color(0xFFBBF7DE),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  statuses[index],
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                      color: statuses[index] == 'Not Solved'
                                          ? Colors.red
                                          : Color(0xFF1D9C69)),
                                ),
                              ),
                              onTap: () async {
                                if (statuses[index] == 'Not Solved') {
                                  await _firestore.runTransaction(
                                      (Transaction myTransaction) async {
                                    myTransaction.update(
                                        snapshot.data.docs[index].reference,
                                        {'status': 'Solved'});
                                  });
                                } else {
                                  await _firestore.runTransaction(
                                      (Transaction myTransaction) async {
                                    myTransaction.update(
                                        snapshot.data.docs[index].reference,
                                        {'status': 'Not Solved'});
                                  });
                                }
                              },
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Row(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                queryTitles[index],
                                                style: TextStyle(
                                                    fontSize: 25.0,
                                                    color: kYellowColor),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    memberTypes[index],
                                                    style: TextStyle(
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        gmailIds[index],
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        width: 5.0,
                                                      ),
                                                      Text(
                                                        "${dates[index].toDate().day} ${months[dates[index].toDate().month - 1]}, ${dates[index].toDate().year}",
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      content:
                                          Text("${queryDescriptions[index]}"),
                                      scrollable: true,
                                    );
                                  });
                            },
                          ),
                        ],
                      );
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
