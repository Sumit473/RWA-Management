import 'reusable_components/reusable_card.dart';
import 'reusable_components/reusable_display.dart';
import 'package:flutter/material.dart';
import 'approved_collections.dart';
import 'unapproved_collections.dart';

class Collections extends StatefulWidget {
  @override
  _CollectionsState createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Collections'),
      ),
      body: ReusableDisplay(
        imageNo: 9,
        description:
        'View abd Update un/approved fee status \nfrom the RWA',
        displaychild: ListView(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
          children: [
            ReusableCard(
              cardColor: Colors.black,
              imageNo: 4,
              cardTitle: 'Approved Collections',
              cardDescription:
              'View approved collections',
              onTapCard: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewCollections(),
                    ),
                  );
                });
              },
            ),
            ReusableCard(
              cardColor: Colors.black,
              imageNo: 19,
              cardTitle: 'UnApproved Collections',
              cardDescription: 'View unseen and unapproved collections',
              onTapCard: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PastCollections(),
                    ),
                  );
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Managed by RWA Treasurer:\nMr. Anirudh Sharma\nContact info: XXXXXXXXXX',
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
