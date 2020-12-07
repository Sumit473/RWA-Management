import 'package:flutter/material.dart';

class AddNotice extends StatefulWidget {
  @override
  _AddNoticeState createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  final editTextController = TextEditingController();
  String title;
  String description;

  List<String> issuedNotice = [];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      TextSpan text = new TextSpan(
        text: editTextController.text,
      );

      TextPainter tp = new TextPainter(
        text: text,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
      );
      tp.layout(maxWidth: size.maxWidth);

      int lines = (tp.size.height / tp.preferredLineHeight).ceil();
      int maxLines = 6;

      return Container(
        color: Color(0xFF161616),
        child: Container(
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Issue Notice',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                      ),
                    ),
                    TextField(
                      autofocus: true,
                      onChanged: (newText) {
                        title = newText;
                      },
                      decoration: InputDecoration(
                        hintText: 'Title',
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    TextField(
                      autofocus: true,
                      controller: editTextController,
                      maxLines: lines > maxLines ? null : maxLines,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(hintText: "Description..."),
                      onChanged: (newText) {
                        description = newText;
                      },
                    ),
                  ],
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  color: Color(0xFF303030),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (title != null &&
                        title != '' &&
                        description != null &&
                        description != '' &&
                        title.length < 20) {
                      issuedNotice.add(description);
                      issuedNotice.add(title);

                      Navigator.pop(context, issuedNotice);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
