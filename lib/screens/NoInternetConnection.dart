import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';

// ignore: must_be_immutable
class NoInternetConnection extends StatelessWidget {
  bool _isCloseApp = false;

  NoInternetConnection({isCloseApp = false}) {
    _isCloseApp = isCloseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('noInternet.png', height: 250, width: 250, fit: BoxFit.cover),
          32.height,
          Text(keyString(context, 'lbl_no_internet')!, style: boldTextStyle(size: 24)),
          8.height,
          Text(keyString(context, 'lbl_network_msg')!, style: secondaryTextStyle(size: 14), textAlign: TextAlign.center).paddingOnly(left: 16, right: 16),
          AppBtn(
            value: keyString(context, 'lbl_close_and_try_again')!,
            onPressed: () {
              if (_isCloseApp) {
                SystemNavigator.pop();
              } else {
                finish(context);
              }
            },
          ).paddingAll(16)
        ],
      ),
    );
  }
}
