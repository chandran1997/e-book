import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/NoInternetConnection.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'error_view_screeen.dart';

class ChangePasswordScreen extends StatefulWidget {
  static String tag = '/ChangePasswordScreen';

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController mOldPasswordCont = TextEditingController();
  TextEditingController mNewPasswordCont = TextEditingController();
  TextEditingController mConfirmPasswordCont = TextEditingController();

  FocusNode mOldPassNode = FocusNode();
  FocusNode mNewPasswordNode = FocusNode();
  FocusNode mConfirmPasswordNode = FocusNode();

  bool autoValidate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  ///change password api call
  Future<void> changePwdAPI() async {
    var request = {'password': mOldPasswordCont.text, 'new_password': mNewPasswordCont.text, 'username': appStore.userEmail};
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        appStore.setLoading(true);

        changePassword(request).then((res) {
          appStore.setLoading(false);
          toast(res["message"]);
          finish(context);
        }).catchError((onError) {
          appStore.setLoading(false);
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appStore.scaffoldBackground,
        appBar: appBar(context, title: ""),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(keyString(context, 'lbl_change_pwd')!, style: boldTextStyle(size: 24)),
                    4.height,
                    Text('Your new password must be different from previous used passwords.', style: secondaryTextStyle()),
                    16.height,
                    AppTextField(
                        controller: mOldPasswordCont,
                        focus: mOldPassNode,
                        textFieldType: TextFieldType.PASSWORD,
                        validator: (s) {
                          if (s!.trim().isEmpty) return keyString(context, "lbl_old_pwd")! + " " + keyString(context, "lbl_field_required")!;
                          if (s.length <= 5) return keyString(context, "error_pwd_length");
                          return null;
                        },
                        nextFocus: mNewPasswordNode,
                        decoration: inputDecoration(keyString(context, 'lbl_old_pwd'))),
                    16.height,
                    AppTextField(
                        controller: mNewPasswordCont,
                        focus: mNewPasswordNode,
                        textFieldType: TextFieldType.PASSWORD,
                        validator: (s) {
                          if (s!.trim().isEmpty) return keyString(context, "lbl_new_pwd")! + " " + keyString(context, "lbl_field_required")!;
                          if (s.length <= 5) return keyString(context, "error_pwd_length");
                          return null;
                        },
                        nextFocus: mConfirmPasswordNode,
                        decoration: inputDecoration(keyString(context, 'lbl_new_pwd'))),
                    16.height,
                    AppTextField(
                        controller: mConfirmPasswordCont,
                        focus: mConfirmPasswordNode,
                        textFieldType: TextFieldType.PASSWORD,
                        validator: (s) {
                          if (s!.trim().isEmpty) return keyString(context, "lbl_confirm_pwd")! + " " + keyString(context, "lbl_field_required")!;
                          if (mNewPasswordCont.text != mConfirmPasswordCont.text) return keyString(context, "lbl_pwd_not_match");
                          return null;
                        },
                        nextFocus: mConfirmPasswordNode,
                        decoration: inputDecoration(keyString(context, 'lbl_confirm_pwd'))),
                    16.height,
                    AppButton(
                      color: PRIMARY_COLOR,
                      width: context.width(),
                      textColor: Colors.white,
                      text: keyString(context, "lbl_submit"),
                      onTap: () {
                        hideKeyboard(context);
                        if (!mounted) return;
                        setState(() {
                          if (_formKey.currentState!.validate()) {
                            appStore.setLoading(true);
                            changePwdAPI();
                          } else {
                            appStore.setLoading(false);
                            setState(() {
                              autoValidate = true;
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Observer(builder: (context) => appLoaderWidget.visible(appStore.isLoading)).center(),
          ],
        ),
      ),
    );
  }
}
