import 'reusable_components/reusable_display.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';

class ManageComplaints extends StatefulWidget {
  final communityName;
  final phoneNumber;
  final gmailId;

  ManageComplaints({this.communityName, this.phoneNumber, this.gmailId});

  @override
  _ManageComplaintsState createState() => _ManageComplaintsState();
}

class _ManageComplaintsState extends State<ManageComplaints> {
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
        title: Text('Manage Complaints'),
      ),
      body: ReusableDisplay(
        imageNo: 17,
        description: 'Manage the complaints of residents',
        displaychild: StreamBuilder(
            stream: widget.gmailId != null
                ? _firestore
                    .collection('complaint manager')
                    .doc(widget.communityName)
                    .collection('complaints')
                    .snapshots()
                : _firestore
                    .collection('complaint manager')
                    .doc(widget.communityName)
                    .collection('complaints')
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final complaints = snapshot.data.docs;
                List<String> statuses = [];
                List<String> complaintTitles = [];
                List<String> complaintDescriptions = [];
                List<Timestamp> dates = [];
                List<String> gmailIds = [];
                List<String> ticketNos = [];

                for (var complaint in complaints) {
                  final status = complaint['status'];
                  final title = complaint['complaintTitle'];
                  final description = complaint['complaint'];
                  final date = complaint['date'];
                  final gmailId = complaint['gmailId'];
                  final ticketNo = complaint['ticketNo'];

                  statuses.add(status);
                  complaintTitles.add(title);
                  complaintDescriptions.add(description);
                  dates.add(date);
                  gmailIds.add(gmailId);
                  ticketNos.add(ticketNo);
                }

                return ListView.builder(
                    itemCount: complaintTitles.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              complaintTitles[index],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: kYellowColor),
                            ),
                            subtitle: Text(
                              "${dates[index].toDate().day} ${months[dates[index].toDate().month - 1]}, ${dates[index].toDate().year}:\t${complaintDescriptions[index]}",
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
                                                complaintTitles[index],
                                                style: TextStyle(
                                                    fontSize: 25.0,
                                                    color: kYellowColor),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Column(
                                                children: <Widget> [
                                                  Text(
                                                    'Ticket no. ${ticketNos[index]}',
                                                    style: TextStyle(
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 5.0,),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        gmailIds[index],
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                      SizedBox(width: 5.0,),
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
                                          )
                                        ],
                                      ),
                                      content: Text(
                                          "${complaintDescriptions[index]}"),
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
