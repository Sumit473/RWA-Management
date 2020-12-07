import '../reusable_components/reusable_display.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../write_query.dart';
import '../constants.dart';

class QueryToRWA extends StatefulWidget {
  final communityName;
  final phoneNumber;
  final gmailId;

  QueryToRWA({this.communityName, this.phoneNumber, this.gmailId});

  @override
  _QueryToRWAState createState() => _QueryToRWAState();
}

class _QueryToRWAState extends State<QueryToRWA> {
  final _firesore = FirebaseFirestore.instance;
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
        title: Text('Query to the RWA'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kYellowColor,
        child: Icon(
          Icons.add,
          size: 30.0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteQuery(
                communityName: widget.communityName,
                phoneNumber: widget.phoneNumber,
                gmailId: widget.gmailId,
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ReusableDisplay(
        imageNo: 1,
        description: 'Resolve your query directly with the RWA staff.',
        displaychild: StreamBuilder(
            stream: widget.gmailId != null
                ? _firesore
                    .collection('secretaries')
                    .doc(widget.communityName)
                    .collection('queries')
                    .where('gmailId', isEqualTo: widget.gmailId)
                    .snapshots()
                : _firesore
                    .collection('secretaries')
                    .doc(widget.communityName)
                    .collection('queries')
                    .where('phoneNumber', isEqualTo: widget.phoneNumber)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final queries = snapshot.data.docs;
                List<String> statuses = [];
                List<String> queryTitles = [];
                List<String> queryDescriptions = [];
                List<Timestamp> dates = [];

                for (var query in queries) {
                  final status = query['status'];
                  final title = query['queryTitle'];
                  final description = query['query'];
                  final date = query['date'];

                  statuses.add(status);
                  queryTitles.add(title);
                  queryDescriptions.add(description);
                  dates.add(date);
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
                            trailing: Container(
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
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 150.0,
                                                  ),
                                                  Text(
                                                    "${dates[index].toDate().day} ${months[dates[index].toDate().month - 1]}, ${dates[index].toDate().year}",
                                                    style: TextStyle(
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.bold),
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
