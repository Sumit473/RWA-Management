import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';

class DatabaseManagement extends StatefulWidget {
  final String communityName;

  DatabaseManagement({this.communityName});

  @override
  _DatabaseManagementState createState() => _DatabaseManagementState();
}

class _DatabaseManagementState extends State<DatabaseManagement> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Manage Database'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('communities')
            .doc(widget.communityName)
            .collection('users')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final details = snapshot.data.docs;

            List<DataRow> memberDetails = [];
            List<String> gmailIds = [];
            int index = -1;
            for (var detail in details) {
              if (!gmailIds.contains(detail['gmailId'])) {
                index++;
                final cellDetails = MemberDetails(
                  name: detail['name'],
                  gmailId: detail['gmailId'],
                  phoneNumber: detail['mobileNumber'],
                  gender: detail['gender'],
                  blockNo: detail['block'],
                  unitNo: detail['unitNo'],
                );

                memberDetails.add(DataRow(
                  cells: <DataCell>[
                    DataCell(Text(cellDetails.name, style: TextStyle(fontSize: 16.0),)),
                    DataCell(Text(cellDetails.gmailId, style: TextStyle(fontSize: 16.0),)),
                    DataCell(Text(cellDetails.phoneNumber, style: TextStyle(fontSize: 16.0),)),
                    DataCell(Text(cellDetails.gender, style: TextStyle(fontSize: 16.0),)),
                    DataCell(Text(cellDetails.blockNo != 'null'
                        ? cellDetails.blockNo
                        : 'NAN', style: TextStyle(fontSize: 16.0),)),
                    DataCell(Text(cellDetails.unitNo)),
                    DataCell(IconButton(icon: Icon(Icons.delete), onPressed: () async {
                      await _firestore.runTransaction((Transaction myTransaction) async {
                        myTransaction.delete(snapshot.data.docs[index].reference);
                      });
                    },)),
                  ],
                ));
                gmailIds.add(detail['gmailId']);
              }
              
            }
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(columns: <DataColumn>[
                  DataColumn(label: Text('Name', style: TextStyle(color: kYellowColor, fontSize: 20.0, fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text('Gmail Id', style: TextStyle(color: kYellowColor, fontSize: 20.0, fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text('Mobile Number', style: TextStyle(color: kYellowColor, fontSize: 20.0, fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text('Gender', style: TextStyle(color: kYellowColor, fontSize: 20.0, fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text('Block No.', style: TextStyle(color: kYellowColor, fontSize: 20.0, fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text('Unit No.', style: TextStyle(color: kYellowColor, fontSize: 20.0, fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text('Delete?', style: TextStyle(color: kYellowColor, fontSize: 20.0, fontWeight: FontWeight.bold),))
                ], rows: memberDetails),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class MemberDetails {
  final String name;
  final String gmailId;
  final String phoneNumber;
  final String gender;
  final String blockNo;
  final String unitNo;

  MemberDetails(
      {this.name,
      this.gmailId,
      this.phoneNumber,
      this.gender,
      this.blockNo,
      this.unitNo});
}
