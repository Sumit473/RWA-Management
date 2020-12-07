import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'login_or_register_or_myStatus_screen.dart';
import 'constants.dart';

class IntroScreen extends StatefulWidget {
  static String id = 'intro_slider';

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  Slide slide(String title, String description, String pathImage) {
    return Slide(
      title: title,
      description: description,
      pathImage: pathImage,
      widthImage: kWidthImage,
      heightImage: kHeightImage,
      backgroundColor: kBlackBackgroundColor,
    );
  }

  @override
  void initState() {
    super.initState();

    slides.addAll([
      slide(
          "Welcome",
          "Here's a quick overview of how this app works and how it can help you.",
          "images/welcome.gif"),
      slide(
          "Notice Board",
          "View the latest notices from the RWA and stay in the loop on important society decisions.",
          "images/notice_board.gif"),
      slide(
          "Billing & Payment",
          "Send payment receipts to the RWA treasurer and view pending + past payments.",
          "images/payment.gif"),
      slide(
          "Complaint Manager",
          "File online complaints and view ticket status.",
          "images/complaint.gif"),
      slide(
          "Community Buzz",
          "A global chat for anyone and everyone in the society. Stay connected with what your neighbours have to share.",
          "images/community_buzz.gif"),
      slide(
          "Multilingual Support",
          "Change the language to English/Hindi/Punjabi... so anyone in the family can understand.",
          "images/multiLingual.gif"),
      slide(
          "Query and Help",
          "Don't seem to understand how it all works?\nDunno worry, directly have a chat with the RWA staff.",
          "images/help.gif")
    ]);
  }

  void onDonePress() {
    Navigator.pop(context);
    Navigator.pushNamed(context, LoginOrRegisterOrMyStatusScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      styleNameSkipBtn:
          TextStyle(color: kBlackBackgroundColor, fontWeight: FontWeight.w600),
      styleNameDoneBtn: TextStyle(
        color: kYellowColor,
      ),
      colorSkipBtn: kYellowColor,
      colorActiveDot: kYellowColor,
    );
  }
}
