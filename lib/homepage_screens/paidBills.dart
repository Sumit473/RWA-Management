import 'package:flutter/material.dart';
import '../constants.dart';

TextStyle attributestyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: kYellowColor,
);

class PaidBills extends StatefulWidget {
  @override
  _PaidBillsState createState() => _PaidBillsState();
}

class _PaidBillsState extends State<PaidBills> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Past payments'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(
                label: Text(
                  'Date',
                  style: attributestyle,
                ),
              ),
              DataColumn(
                label: Text(
                  'Collection ID',
                  style: attributestyle,
                ),
                numeric: true,
              ),
              DataColumn(
                label: Text(
                  'Description',
                  style: attributestyle,
                ),
              ),
              DataColumn(
                label: Text(
                  'Amount',
                  style: attributestyle,
                ),
                numeric: true,
              ),
            ],
            rows: unpaid
                .map(
                  (tuple) => DataRow(
                cells: [
                  DataCell(
                    Text(tuple.date),
                  ),
                  DataCell(
                    Text(tuple.cID),
                  ),
                  DataCell(Text(tuple.description)),
                  DataCell(Text(tuple.amount)),
                ],
              ),
            )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class UnpaidCollection {
  String date;
  String cID;
  String description;
  String amount;
  UnpaidCollection({this.date, this.cID, this.description, this.amount});
}

var unpaid = <UnpaidCollection>[
  UnpaidCollection(
    date: "01/11/2000",
    cID: "99",
    description: "Night Watchman(monthly)",
    amount: "500",
  ),
  UnpaidCollection(
    date: "01/10/2000",
    cID: "98",
    description: "Nigh Watchman(monthly)",
    amount: "500",
  ),
];