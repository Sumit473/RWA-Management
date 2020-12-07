import 'paidBills.dart';
import 'unpaidBills.dart';
import '../reusable_components/reusable_card.dart';
import '../reusable_components/reusable_display.dart';
import 'package:flutter/material.dart';

class BillingnPayment extends StatefulWidget {
  @override
  _BillingnPaymentState createState() => _BillingnPaymentState();
}

class _BillingnPaymentState extends State<BillingnPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Billing & Payment'),
      ),
      body: ReusableDisplay(
        imageNo: 9,
        description:
            'View your pending dues, send payment receipt,\nview past payments, etc.',
        displaychild: ListView(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
          children: [
            ReusableCard(
              cardColor: Colors.black,
              imageNo: 4,
              cardTitle: 'Pending payments',
              cardDescription:
                  'View your unpaid bills and send their receipts to get approved.',
              onTapCard: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UnpaidBills(),
                    ),
                  );
                });
              },
            ),
            ReusableCard(
              cardColor: Colors.black,
              imageNo: 19,
              cardTitle: 'Past payments',
              cardDescription: 'View your past payment record.',
              onTapCard: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaidBills(),
                    ),
                  );
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Managed by RWA Treasurer:\nMr. Anirudh Sharma\nContact info: +91 3333333333',
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
