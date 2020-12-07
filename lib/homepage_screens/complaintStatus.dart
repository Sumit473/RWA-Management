import '../reusable_components/reusable_display.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants.dart';

class ComplaintStatus extends StatefulWidget {
  final communityName;
  final phoneNumber;
  final gmailId;

  ComplaintStatus({this.communityName, this.phoneNumber, this.gmailId});

  @override
  _ComplaintStatusState createState() => _ComplaintStatusState();
}

class _ComplaintStatusState extends State<ComplaintStatus> {
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
        title: Text('Complaint Status'),
      ),
      body: ReusableDisplay(
        imageNo: 1,
        description: 'Resolve your complaint directly with the RWA staff.',
        displaychild: StreamBuilder(
            stream: widget.gmailId != null
                ? _firesore
                .collection('complaint manager')
                .doc(widget.communityName)
                .collection('complaints')
                .where('gmailId', isEqualTo: widget.gmailId)
                .snapshots()
                : _firesore
                .collection('complaint manager')
                .doc(widget.communityName)
                .collection('complaints')
                .where('phoneNumber', isEqualTo: widget.phoneNumber)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final complaints = snapshot.data.docs;
                List<String> statuses = [];
                List<String> complaintTitles = [];
                List<String> complaintDescriptions = [];
                List<Timestamp> dates = [];
                List<String> ticketNos = [];

                for (var complaint in complaints) {
                  final status = complaint['status'];
                  final title = complaint['complaintTitle'];
                  final description = complaint['complaint'];
                  final date = complaint['date'];
                  final ticketNo = complaint['ticketNo'];

                  statuses.add(status);
                  complaintTitles.add(title);
                  complaintDescriptions.add(description);
                  dates.add(date);
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
                                                complaintTitles[index],
                                                style: TextStyle(
                                                    fontSize: 25.0,
                                                    color: kYellowColor),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Ticket no. ${ticketNos[index]}',
                                                    style: TextStyle(
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 40.0,
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
                                      Text("${complaintDescriptions[index]}"),
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

