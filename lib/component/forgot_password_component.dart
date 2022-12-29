import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/NoInternetConnection.dart';
import 'package:flutterapp/screens/error_view_screeen.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';
import '../main.dart';

class ForgotPasswordComponent extends StatefulWidget {
  static String tag = '/ForgotPasswordComponent';

  @override
  ForgotPasswordComponentState createState() => ForgotPasswordComponentState();
}

class ForgotPasswordComponentState extends State<ForgotPasswordComponent> {
  var emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();

  final formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  ///forgot password api call
  Future forgotPwdApi(value) async {
    await isNetworkAvailable().then((bool) async {
      appStore.setLoading(true);

      if (bool) {
        var request = {
          'email': value,
        };
        await forgetPassword(request).then((res) async {
          appStore.setLoading(false);

          toast(res["message"]);
        }).catchError((onError) {
          appStore.setLoading(false);
          log("Error:" + onError.toString());
          ErrorViewScreen(
            message: onError.toString(),
          ).launch(context);
        });
      } else {
        appStore.setLoading(false);
        NoInternetConnection().launch(context);
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: context.width(),
          decoration: boxDecoration(color: appStore.scaffoldBackground!, radius: defaultRadius, bgColor: appStore.scaffoldBackground),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(keyString(context, "lbl_forgot_password")!, style: boldTextStyle(size: 22)).paddingOnly(left: 16, right: 16, top: 16),
                16.height,
                Form(
                  key: formKey1,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppTextField(
                        controller: emailController,
                        focus: emailFocusNode,
                        textFieldType: TextFieldType.EMAIL,
                        decoration: inputDecoration(keyString(context, 'lbl_email_id')),
                      ),
                    ],
                  ).paddingOnly(left: spacing_standard_new.toDouble(), right: spacing_standard_new.toDouble(), bottom: spacing_standard.toDouble()),
                ),
                AppButton(
                  text: keyString(context, "lbl_submit"),
                  textStyle: boldTextStyle(color: Colors.white),
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(30)),
                  width: context.width() * 0.7,
                  color: PRIMARY_COLOR,
                  onTap: () {
                    if (formKey1.currentState!.validate()) {
                      hideKeyboard(context);
                      Navigator.of(context).pop();
                      forgotPwdApi(emailController.text);
                    } else {
                      appStore.setLoading(false);
                    }
                  },
                ).paddingAll(16),
              ],
            ),
          ),
        ),
        Observer(
            builder: (context) => appStore.isLoading
                ? Container(
                    child: CircularProgressIndicator(),
                    alignment: Alignment.center,
                    height: context.height() * 0.5,
                  )
                : SizedBox())
      ],
    );
  }
}
