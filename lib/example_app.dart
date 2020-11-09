import 'package:flutter/material.dart';
import 'package:flutter_onboarding_screen/OnbordingData.dart';
import 'package:flutter_onboarding_screen/flutteronboardingscreens.dart';


class TestScreen extends StatelessWidget {
  final List<OnbordingData> list = [
    OnbordingData(
      imagePath: "images/16.png",
      title: "Important announcements and reminders",
      desc:
      "Never miss any society important announcement and reminders about events.",
    ),
    OnbordingData(
      imagePath: "images/9.png",
      title: "Fee collection and management",
      desc:
      "Record Fees Payment from residents/members, view the fees paid history and the total fees received by end of month.",
    ),
    OnbordingData(
      imagePath: "images/2.png",
      title: "Complaint registration and Issue Management",
      desc:
      "Track and resolve resident complaints, efficiently.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return  IntroScreen(
      list, MaterialPageRoute(builder: (context) => TestScreen()),
    );
  }
}
