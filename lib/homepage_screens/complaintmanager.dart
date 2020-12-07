import 'complaintStatus.dart';
import 'fileComplaint.dart';
import '../reusable_components/reusable_card.dart';
import '../reusable_components/reusable_display.dart';
import 'package:flutter/material.dart';

class ComplaintManager extends StatefulWidget {
  final communityName;
  final phoneNumber;
  final gmailId;

  ComplaintManager({this.communityName, this.gmailId, this.phoneNumber});

  @override
  _ComplaintManagerState createState() => _ComplaintManagerState();
}

class _ComplaintManagerState extends State<ComplaintManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Complaint Manager'),
      ),
      body: ReusableDisplay(
        imageNo: 17,
        description:
            'Your personalised complaint manager.\nFile complaints and view their status.',
        displaychild: ListView(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
          children: [
            ReusableCard(
              cardColor: Colors.black,
              imageNo: 4,
              cardTitle: 'File a complaint',
              cardDescription: 'It\'s just like filling an online form.',
              onTapCard: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FileAComplaint(
                        communityName: widget.communityName,
                        phoneNumber: widget.phoneNumber,
                        gmailId: widget.gmailId,
                      ),
                    ),
                  );
                });
              },
            ),
            ReusableCard(
              cardColor: Colors.black,
              imageNo: 1,
              cardTitle: 'Complaint status',
              cardDescription:
                  'View your complaint status and past complaints.',
              onTapCard: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComplaintStatus(
                        communityName: widget.communityName,
                        phoneNumber: widget.phoneNumber,
                        gmailId: widget.gmailId,
                      ),
                    ),
                  );
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Managed by RWA Complaint Manager:\nMs. Apoorva Kumar\nContact info: +91 1111111111',
              textAlign: TextAlign.center,
              textScaleFactor: 1.2,
              style: TextStyle(
                color: ThemeData.dark().disabledColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
