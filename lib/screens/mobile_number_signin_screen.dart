import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/sign_up_screen.dart';
import 'package:flutterapp/utils/PinEntryTextField.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';
import '../main.dart';
import 'dashboard_screen.dart';

class MobileNumberSignInScreen extends StatefulWidget {
  static String tag = '/MobileNumberSignInScreen';

  MobileNumberSignInScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  MobileNumberSignInScreenState createState() => MobileNumberSignInScreenState();
}

class MobileNumberSignInScreenState extends State<MobileNumberSignInScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  TextEditingController numberController = TextEditingController();
  String? countryCode = '';

  late String _verificationId;
  String? smsOTP;
  String? data;

  ///verify phone number
  Future<void> verifyPhoneNumber(BuildContext context) async {
    return await _auth.verifyPhoneNumber(
      phoneNumber: countryCode! + numberController.text.toString(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        //
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          toast(keyString(context, 'lbl_phone_no_invalid'));
          throw 'The provided phone number is not valid.';
        } else {
          toast(e.toString());
          throw e.toString();
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        toast(keyString(context, 'lbl_please_check_phone_for_code'));
        _verificationId = verificationId;
        await showInDialog(
          context,
          builder: (_) => Container(
            height: 85,
            child: Column(
              children: [
                PinEntryTextField(
                  onSubmit: (value) {
                    this.smsOTP = value;
                  },
                ),
              ],
            ),
          ),
          contentPadding: EdgeInsets.all(0),
          title: Text(keyString(context, "lbl_sms_code")!, style: boldTextStyle(color: appStore.appTextPrimaryColor)),
          actions: <Widget>[
            AppButton(
                width: context.width(),
                textStyle: boldTextStyle(color: Colors.white),
                text: keyString(context, "lbl_done"),
                onTap: () {
                  hideKeyboard(context);
                  finish(context);
                  signInWithPhoneNumber();
                },
                color: PRIMARY_COLOR),
          ],
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        //
        appStore.setLoading(false);
      },
    );
  }

  ///sign in with phone number
  Future<void> signInWithPhoneNumber() async {
    setState(() {});
    AuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: smsOTP.validate());

    await FirebaseAuth.instance.signInWithCredential(credential).then((result) async {
      Map req = {
        'username': result.user!.phoneNumber!.replaceAll('+', ''),
        'password': result.user!.phoneNumber!.replaceAll('+', ''),
      };
      await signInApi(req);
    }).catchError((e) {
      log(e);
      toast(e.toString());
      appStore.setLoading(false);
      setState(() {});
    });
  }

  ///sign in api call here
  Future<void> signInApi(req) async {
    appStore.setLoading(true);

    await getLoginUserRestApi(req).then((res) async {
      if (!mounted) return;
      await appStore.setUserName(res['user_nicename']);
      await appStore.setToken(res['token']);
      await appStore.setFirstName(res['first_name']);
      await appStore.setLastName(res['last_name']);
      await appStore.setDisplayName(res['user_display_name']);
      await appStore.setUserId(res['user_id']);
      await appStore.setUserEmail(res['user_email']);
      await appStore.setAvatar(res['avatar']);
      await appStore.setLoggedIn(true);
      await appStore.setSocialLogin(true);

      if (res['book_profile_image'] != null) {
        appStore.setProfileImage(res['book_profile_image']);
      }
      appStore.setLoading(false);
      DashboardScreen().launch(context, isNewTask: true);
    }).catchError((error) {
      appStore.setLoading(false);
      if (error.toString() == "Invalid Credential.") {
        finish(context);
        SignUpScreen(userName: '${countryCode!.replaceAll('+', '') + numberController.text}').launch(context);
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(context, title: keyString(context, "lbl_otp_verification"), showBack: true),
      backgroundColor: appStore.scaffoldBackground,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: appStore.editTextBackColor!,
                  borderRadius: radius(8),
                  border: Border.all(color: Theme.of(context).textTheme.subtitle1!.color!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CountryCodePicker(
                      padding: EdgeInsets.all(0),
                      showDropDownButton: true,
                      initialSelection: 'IN',
                      favorite: ['+91', 'IN'],
                      showCountryOnly: false,
                      showFlag: true,
                      textStyle: primaryTextStyle(),
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                      onInit: (c) {
                        countryCode = c!.dialCode;
                      },
                      onChanged: (c) {
                        countryCode = c.dialCode;
                      },
                    ),
                    AppTextField(
                      textFieldType: TextFieldType.PHONE,
                      controller: numberController,
                      maxLines: 1,
                      autoFocus: false,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: keyString(context, "hint_mobile_number"),
                          hintStyle: secondaryTextStyle()),
                      onFieldSubmitted: (s) {
                        verifyPhoneNumber(context);
                      },
                    ).expand()
                  ],
                ),
              ),
              46.height,
              AppButton(
                  textStyle: boldTextStyle(color: Colors.white),
                  width: context.width(),
                  text: keyString(context, "lbl_verify"),
                  onTap: () {
                    hideKeyboard(context);
                    if (numberController.text.isEmpty) {
                      toast(keyString(context, "lbl_field_required"));
                    } else {
                      verifyPhoneNumber(context);
                    }
                  },
                  color: PRIMARY_COLOR),
            ],
          ).paddingAll(16),
          Observer(builder: (_) => Center(child: CircularProgressIndicator()).visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
