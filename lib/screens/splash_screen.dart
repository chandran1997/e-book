import 'package:flutter/material.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/utils/Colors.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import '../main.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    setStatusBarColor(Colors.white);
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      body: CustomTheme(
        child: SplashScreenView(
          navigateRoute: DashboardScreen(),
          duration: 2000,
          imageSize: 200,
          imageSrc: ic_logo,
          text: keyString(context, "app_name"),
          textType: TextType.ColorizeAnimationText,
          textStyle: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
          colors: [
            PRIMARY_COLOR,
            accentColor,
            PRIMARY_COLOR,
            accentColor,
            PRIMARY_COLOR,
            accentColor,
          ],
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
