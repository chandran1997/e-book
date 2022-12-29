import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';

// ignore: must_be_immutable
class ErrorViewScreen extends StatelessWidget {
  bool _isCloseApp = false;
  late String _message;

  ErrorViewScreen({isCloseApp = false, message = ""}) {
    _isCloseApp = isCloseApp;
    _message = message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(ic_error, height: 250, width: 250, fit: BoxFit.cover),
          30.height,
          Text(
            keyString(context, 'lbl_oops')! + _message,
            style: boldTextStyle(size: 24),
            textAlign: TextAlign.center,
          ),
          10.height,
          Text(
            keyString(context, "lbl_error")!,
            style: secondaryTextStyle(),
            textAlign: TextAlign.center,
          ).paddingOnly(left: 20, right: 20),
          AppButton(
            width: context.width(),
            color: PRIMARY_COLOR,
            textStyle: boldTextStyle(color: Colors.white),
            text: keyString(context, "lbl_try_again"),
            onTap: () {
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
