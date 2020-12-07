import 'package:flutter/material.dart';

class ReusableDisplay extends StatelessWidget {
  ReusableDisplay({this.imageNo, this.description, this.displaychild});
  final int imageNo;
  final String description;
  final Widget displaychild;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  height: 200,
                  child: Image.asset('images/$imageNo.png'),
                  margin: EdgeInsets.only(bottom: 10),
                ),
              ),
              Expanded(
                flex: 0,
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.2,
                ),
              ),
              Divider(
                thickness: 2,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: displaychild,
        ),
      ],
    );
  }
}
