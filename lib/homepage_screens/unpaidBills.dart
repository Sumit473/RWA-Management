import 'package:flutter/material.dart';

const Color _lightYellow = Color(0xFFFFC727);

TextStyle attributestyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: _lightYellow,
);

class UnpaidBills extends StatefulWidget {
  @override
  _UnpaidBillsState createState() => _UnpaidBillsState();
}

class _UnpaidBillsState extends State<UnpaidBills> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Pending payments'),
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
              DataColumn(
                label: Text(
                  'Upload payment receipt',
                  style: attributestyle,
                ),
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
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.post_add),
                          onPressed: () {
                            showDialog(
                              context: context,
                              useSafeArea: true,
                              builder: (context) => AlertDialog(
                                title: Text('Under development'),
                              ),
                            );
                            //print("henlo");
                          },
                        ),
                      ),
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
    date: "07/12/2000",
    cID: "102",
    description: "Night Watchman(monthly)",
    amount: "500",
  ),
  UnpaidCollection(
    date: "06/12/2000",
    cID: "101",
    description: "Fence construction",
    amount: "300",
  ),
  UnpaidCollection(
    date: "05/12/2000",
    cID: "100",
    description: "Day Watchman(monthly)",
    amount: "600",
  ),
];
