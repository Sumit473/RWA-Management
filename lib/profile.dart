import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: 'Product Sans',
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 55.0,
                      backgroundColor: Colors.red,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      'Sumit Garg',
                      style:
                          TextStyle(fontSize: 20.0, fontFamily: 'Product Sans'),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(width: 2.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.email),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'gargs473@gmail.com',
                                style: TextStyle(
                                  fontFamily: 'Product Sans',
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.edit),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
