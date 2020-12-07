import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'choose_screen.dart';
import 'intro_screen.dart';
import 'login_or_register_or_myStatus_screen.dart';
import 'register_screens/name_community_screen.dart';
import 'see_registration_status.dart';
import 'login_screens/login_screen.dart';
import 'constants.dart';

void main() {
  Get.lazyPut<ThemeController>(() => ThemeController());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ThemeController.to.getThemeModeFromPreferences();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData.light().copyWith(
        brightness: Brightness.dark,
        textTheme: ThemeData.dark().textTheme.apply(
            fontFamily: 'Product Sans',
            //bodyColor: _blackLight,
            displayColor: kOliveGreenLight),
        primaryTextTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Product Sans',
              bodyColor: kBlack,
            ),
        accentTextTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Product Sans',
              //bodyColor: _black,
            ),
        buttonColor: kOliveGreen,
        accentColor: kOliveGreen,
        primaryColor: kBackgroundWhite,
        toggleableActiveColor: kYellowColor,
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Product Sans',
            ),
        primaryTextTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Product Sans',
            ),
        accentTextTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Product Sans',
            ),
        buttonColor: kOliveGreen,
        accentColor: kAccentDarkYellow,
        toggleableActiveColor: kYellowColor,
      ),
      initialRoute: IntroScreen.id,
      routes: {
        ChooseScreen.id: (context) => ChooseScreen(),
        IntroScreen.id: (context) => IntroScreen(),
        LoginOrRegisterOrMyStatusScreen.id: (context) =>
            LoginOrRegisterOrMyStatusScreen(),
        NameCommunityScreen.id: (context) => NameCommunityScreen(),
        SeeRegistrationStatus.id: (context) => SeeRegistrationStatus(),
        LoginScreen.id: (context) => LoginScreen(),
      },
    );
  }
}

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  SharedPreferences prefs;
  ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode themeMode) async {
    Get.changeThemeMode(themeMode);
    _themeMode = themeMode;
    update();
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', themeMode.toString().split('.')[1]);
  }

  getThemeModeFromPreferences() async {
    ThemeMode themeMode;
    prefs = await SharedPreferences.getInstance();
    String themeText = prefs.getString('theme') ?? 'system';
    try {
      themeMode =
          ThemeMode.values.firstWhere((e) => describeEnum(e) == themeText);
    } catch (e) {
      themeMode = ThemeMode.system;
    }
    setThemeMode(themeMode);
  }
}
